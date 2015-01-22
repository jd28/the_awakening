local fmt = string.format
local bit = require 'bit'
local ffi = require 'ffi'
local C = ffi.C
local lfs = require 'lfs'
local Log = System.GetLogger()

local GetIsValid = require('solstice.object').Object.GetIsValid

local _COMMANDS = {}
local _SYMBOLS = {}

--- ChatInfo table.
--     A table containing the following fields will be passed to the
--     chat command function.
-- @table ChatInfo
-- @field channel Chat channel.
-- @field speaker Chat speaker.
-- @field cmd Chat command
-- @field param Chat command parameters.  I.e. all text
-- following the chat command.
-- @see ta.chat.RegisterCommand

local function get_command(start, cmd)
   local first_space
   for i=1, #cmd do
      if cmd:index(i) == " " then
         first_space = i
         break
      end
   end

   local command, action

   if first_space then
      command = string.sub(cmd, #start+1, first_space - 1)
      action = string.sub(cmd, first_space+1, #cmd)
   else
      command = string.sub(cmd, #start+1, #cmd)
      action = ""
   end

   return command, action
end

local info

local function get_symbol(cmd)
   for i = 1, #_SYMBOLS, 2 do
      sym, ver = _SYMBOLS[i], _SYMBOLS[i+1]
      if cmd:starts(sym) then
         return sym, ver
      end
   end
end

local function run_command(cmd)
   local dispatch
   local symbol

   local sym, ver = get_symbol(cmd)
   if not sym then return end

   local speaker = info.speaker

   if ver == true or ver(info.speaker) then
      symbol   = sym
      dispatch = _COMMANDS[sym]
   else
      speaker:ErrorMessage("You are not authorized to use this command!")
   end

   -- If not a command or emote return false and don't suppress chat.
   if not dispatch then return false end

   info.original = cmd
   info.cmd, info.param = get_command(symbol, cmd)

   -- Use levenshtein to guess what command a player might have mistyped.
   if not dispatch[info.cmd] and speaker:GetIsPC() then
      local best, highest
      for k, _ in pairs(dispatch) do
         if not highest then
            best = k
            highest = string.levenshtein(info.cmd, k)
         else
            local t = string.levenshtein(info.cmd, k)
            if t < highest then
               best, highest = k, t
            end
         end
      end
      if best then
         speaker:ErrorMessage(string.format("Invalid commad: %s!  Perhaps you meant: %s?",
                                            symbol..info.cmd, symbol..best))
      end
      return
   end

   if dispatch[info.cmd] then
      if info.param:match("--help") then
         speaker:SendMessage(dispatch[info.cmd].description)
         return true
      else
         if dispatch[info.cmd].func then
            dispatch[info.cmd].func(info)
         end
         return true
      end
   end
end

--- Register chat symbol.
-- @param symbol Chat command prefix, e.g: dm_, !, admin_, etc
-- @param dir Directory that contains the commands.
-- @param[opt] verify Function that is called to verify that a command can be used.
local function RegisterSymbol(symbol, dir, verify)
   local function load_dir(dir)
      local chatdir = lfs.currentdir() .. "/lua/" .. dir .. '/'

      for f in lfs.dir(chatdir) do
         if string.find(f:lower(), ".lua", -4)  then
            local file =  chatdir .. f

            Log:info("Loading Chat Command: " .. file)
            -- Wrap the dofile call in a pcall so that errors can be logged here
            -- and so that they will not cause the for loop to abort.
            local result, err = pcall(function() dofile(file) end)
            if not result then
               Log:error("ERROR Loading: %s : %s \n", file, err)
            end
         end
      end
   end

   if type(symbol) ~= "string" then
      error "Chat symbols must be strings!"
   end

   if verify ~= nil and type(verify) ~= "function" then
      error "The symbol verifier if passed must be a function!"
   end

   table.insert(_SYMBOLS, symbol)
   table.insert(_SYMBOLS, verify or true)
   load_dir(dir)
end

local function IsRegisteredSymbol(cmd)
   for i=1, #_SYMBOLS, 2 do
      if cmd == _SYMBOLS[i] then
         return cmd
      end
   end
end

--- Register chat command.
-- @param symbol
-- @param name
-- @param desc
-- @param func
local function RegisterCommand(symbol, name, func, desc)
   desc = desc or ''
   if not IsRegisteredSymbol(symbol) then
      error(fmt("Symbol %s has not been registered!", symbol))
   end
   _COMMANDS[symbol] = _COMMANDS[symbol] or {}
   _COMMANDS[symbol][name] = {func = func, description = desc }
end

--- Register external chat command.
-- @param symbol
-- @param name
-- @param desc
local function RegisterExternalCommand(symbol, name, desc)
   if not IsRegisteredSymbol(symbol) then
      error(fmt("Symbol %s has not been registered!", symbol))
   end
   _COMMANDS[symbol] = _COMMANDS[symbol] or {}
   _COMMANDS[symbol][name] = { description = desc or "" }
end

local function VerifyTarget(info, type, pc_only)
   local speaker, target = info.speaker, info.target
   local ret = target
   if not target:GetIsValid() then
      ret = speaker:GetLocalObject("FKY_CHAT_TARGET")
      if not ret:GetIsValid() then
         speaker:ErrorMessage("Please use Player Tool 1 or your Command Targeter to select a target, or send them a tell with the !target command!")
         speaker:SetLocalString("FKY_CHAT_COMMAND", info.original);

         if not speaker:HasItem("fky_chat_target") then
            speaker:GiveItem("fky_chat_target")
         end

         return OBJECT_INVALID;
      else
         speaker:DeleteLocalObject("FKY_CHAT_TARGET")
      end
   end

   if pc_only and not ret:GetIsPC() then
      speaker:ErrorMessage("Command requires a PC target!")
      return OBJECT_INVALID
   end

   if type and bit.band(ret:GetType(), type) == 0 then
      speaker:ErrorMessage("Incorrect target type!")
      return OBJECT_INVALID
   end

   return ret
end

--- Chat Handler
-- @param channel
-- @param speaker
-- @param msg
-- @param to
local function ChatHandler(channel, speaker, msg, to)
   -- Speaker must be a valid PC and the msg must start with
   -- a command.
   if not GetIsValid(speaker) or
      speaker.type ~= OBJECT_TRUETYPE_CREATURE or
      not speaker:GetIsPC() or
      not get_symbol(msg)
   then
      return false
   end

   local commands = msg:split('&&')

   info = {
      channel  = channel,
      speaker  = speaker,
      target   = to
   }

   local ret = false
   for _, com in ipairs(commands) do
      ret = ret or run_command(com)
   end
   return false
end

local function CCMessageHandler(msg)
   if msg.type == 11 and msg.subtype == 151 then
      return true
   elseif msg.type == 3 then
      local sum = 0
      for i = 0, 12 do
         if msg.msg_data.integers.data[i] > 0 then
            sum = sum + msg.msg_data.integers.data[i]
         end
      end
      return sum <= 0
   end
   return false
end

local NXChat = safe_require 'solstice.nwnx.chat'
NXChat.SetChatHandler(ChatHandler)
NXChat.SetCombatMessageHandler(CCMessageHandler)

local M = {}
M.IsRegisteredSymbol = IsRegisteredSymbol
M.RegisterCommand = RegisterCommand
M.RegisterExternalCommand = RegisterExternalCommand
M.RegisterSymbol = RegisterSymbol
M.VerifyTarget = VerifyTarget
return M
