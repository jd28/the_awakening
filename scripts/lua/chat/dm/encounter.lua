local Enc = require 'ta.encounter'

local command = 'encounter'
local desc = 'Encounter Spawn System related commands'

local function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker

   if act[1] == "test" and act[2] then
      pc:SendMessage(Enc.Test(act[2]))
   elseif act[1] == "list" then
      pc:SendMessage(Enc.List())
   end
end

local chat = require 'ta.chat'
chat.RegisterCommand(CHAT_SYMBOL_DM, command, action, desc)
