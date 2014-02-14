local fmt = string.format
local bit = require 'bit'
local ffi = require 'ffi'
local C = ffi.C
local lfs = require 'lfs'

local _COMMANDS = {}
local _SYMBOLS = {}

local M = {}

--- ChatInfo table.
--     A table containing the following fields will be passed to the
--     chat command function.
-- @table ChatInfo
-- @field channel Chat channel.
-- @field speaker Chat speaker.
-- @field cmd Chat command
-- @field param Chat command parameters.  I.e. all text
-- following the chat command.
-- @see solstice.chat.RegisterCommand

--- Chat Handler
-- @param channel
-- @param speaker
-- @param msg
-- @param to
function M.ChatHandler(channel, speaker, msg, to)
   local function get_command(start, cmd)
      local command = cmd:match(start.."(%w+)%s?") or ""
      local action = cmd:match("%s+(.+)") or ""
      return command, action
   end

   if not speaker:GetIsValid() then return false end
   if speaker.type ~= OBJECT_TRUETYPE_CREATURE then
      return false
   end
   if not speaker:GetIsPC() then return false end

   local info = {
      channel  = channel,
      speaker  = speaker,
      target   = to
   }

   local commands = msg:split('&&')

   for _, cmd in ipairs(commands) do
      local dispatch
      local symbol

      for sym, ver in pairs(_SYMBOLS) do
         if cmd:starts(sym) then
            if ver == true or ver(speaker) then
               symbol   = sym
               dispatch = _COMMANDS[sym]
            else
               speaker:SendMessage("You are not authorized to use this command!")
            end
         end
      end

      -- If not a command or emote return false and don't suppress
      -- chat.
      if not dispatch then return false end

      info.cmd, info.param = get_command(symbol, cmd)
      --print (info.cmd, info.param)

      if dispatch[info.cmd] then
         if info.param:match("--help") then
            speaker:SendMessage(dispatch[info.cmd].description)
         else
            dispatch[info.cmd].func(info)
         end

         return true
      else
         speaker:SendMessage("Invalid Command!")
      end
   end

   return false
end

local function load_dir(symbol, dir)
   local chatdir = lfs.currentdir() .. "/lua/" .. dir .. '/'

   for f in lfs.dir(chatdir) do
      if string.find(f:lower(), ".lua", -4)  then
         local file =  chatdir .. f
         local res = runfile(file, setmetatable({}, { __index = _G }))
         if res.command and type(res.command) == "string" and
            res.action and type(res.action) == "function"
         then
            C.Local_NWNXLog(0, "Loaded Chat Command: " .. file .. "\n")
            M.RegisterCommand(symbol, res.command, res.description or "", res.action)
         else
            C.Local_NWNXLog(0, "Error Loading Chat Command: " .. file .. "\n")
         end
      end
   end
end

--- Register chat symbol.
-- @param symbol
-- @param[opt] verify
function M.RegisterSymbol(symbol, dir, verify)
   if type(symbol) ~= "string" then
      error "Chat symbols must be strings!"
   end

   if verify ~= nil and type(verify) ~= "function" then
      error "The symbol verifier if passed must be a function!"
   end

   _SYMBOLS[symbol] = verify or true
   load_dir(symbol, dir)
end

--- Register chat command.
-- @param symbol
-- @param name
-- @param desc
-- @param func
function M.RegisterCommand(symbol, name, desc, func)
   if not _SYMBOLS[symbol] then
      error(fmt("Symbol %s has not been registered!", symbol))
   end
   _COMMANDS[symbol] = _COMMANDS[symbol] or {}
   _COMMANDS[symbol][name] = {func = func, description = desc }
end

function M.CCMessageHandler(msg)
   if msg.type == 11 and msg.subtype == 151 then
      return true
   end
   return false
end

local NXChat = safe_require 'solstice.nwnx.chat'
NXChat.SetChatHandler(M.ChatHandler)

return M
