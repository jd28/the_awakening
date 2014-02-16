local Item = require 'ta.item'

command = "item"
description = [[Item generator commands.
               |  generate <resref>
               |  list]]

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   local pc = chat_info.speaker
   if act[1] == "generate" and act[2] then
      Item.Generate(pc, act[2])
   elseif act[1] == "list" then
      pc:SendMessage(Item.List())
   end
end
