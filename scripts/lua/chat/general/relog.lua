local chat = require 'ta.chat'

local command = "relog"
local desc = ''

local function action(info)
   local pc = info.speaker
   pc:ActivatePortal("173.255.209.70:5121", "", "", false)
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
