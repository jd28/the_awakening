local Item = require 'solstice.item'

command = "generate"
description = "Generate item"

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   Item.Generate(chat_info.speaker, act[1])
end

-- OR
--action = function (chat_info)
-- ...
--end
