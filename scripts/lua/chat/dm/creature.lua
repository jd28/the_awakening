local Creature = require 'ta.creature'

local command = "creature"
local desc = [[Creature generator commands.
              |  test]]

local function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker
   if act[1] == "generate" and act[2] then
      Creature.Generate(pc, act[2])
   elseif act[1] == "list" then
      pc:SendMessage(Creature.List())
   elseif act[1] == "test" then
      pc:SendMessage(Creature.Test(act[2], act[3] == "true"))
   end
end

local chat = require 'ta.chat'
chat.RegisterCommand(CHAT_SYMBOL_DM, command, action, desc)
