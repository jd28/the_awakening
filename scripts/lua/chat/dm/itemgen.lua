local Item = require 'ta.item'
local chat = require 'ta.chat'

local command = "item"
local desc = [[Item generator commands.
              |  generate <resref>
              |  list]]

local function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker
   if act[1] == "generate" and act[2] then
      Item.Generate(pc, act[2])
   elseif act[1] == "list" then
      pc:SendMessage(Item.List())
   elseif act[1] == "test" then
      pc:SendMessage(Item.Test(act[2], act[3] == "true"))
   end
end

chat.RegisterCommand(CHAT_SYMBOL_DM, command, action, desc)
