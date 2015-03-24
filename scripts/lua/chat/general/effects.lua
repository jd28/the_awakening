local chat = require 'ta.chat'
local Log = System.GetLogger()

local command = "effects"
local desc = ''
local fmt = string.format

local function action(info)
   local pc = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "dump" then
      for e in pc:Effects(true) do
         pc:SendMessage(e:ToString())
      end
   elseif act[1] == "count" then
      pc:SendMessage(fmt("You currently have %d effects applied",
                         pc.obj.obj.obj_effects_len))
   elseif act[1] == "log" then
      for e in pc:Effects(true) do
         Log:info(e:ToString())
      end
   end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
