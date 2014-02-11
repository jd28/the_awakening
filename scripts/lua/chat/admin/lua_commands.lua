command = "lua"
description = "Lua related commands"

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end
   
   if act[1] == 'reload' then
      if not package.loaded[act[2]] then
	 print ("Error: "..act[2].." not loaded!")
	 chat_info.speaker:SendMessage("Error: "..act[2].." not loaded!")
      end

      package.loaded[act[2]] = nil
      safe_require(act[2])

   elseif act[1] == 'load' then
      safe_require(act[2])
   end
end