command = "lua"
description = "Lua related commands"

local safe_require = safe_require
local package = package
local collectgarbage = collectgarbage
local string = string

local System = require 'solstice.system'
local _SOL_REMOVE_CACHED_OBJECT = _SOL_REMOVE_CACHED_OBJECT

function action(chat_info)
   local act = chat_info.param:split(' ')
   if not act then return end

   if act[1] == 'reload' then
      if not package.loaded[act[2]] then
         --print ("Error: "..act[2].." not loaded!")
         chat_info.speaker:SendMessage("Error: "..act[2].." not loaded!")
      end

      package.loaded[act[2]] = nil
      safe_require(act[2])

   elseif act[1] == 'load' then
      safe_require(act[2])
   elseif act[1] == 'gc' then
      local before = collectgarbage("count")
      collectgarbage()
      local msg = string.format("Lua GC: Before %f, After: %f",
                                before, collectgarbage("count"))
      chat_info.speaker:SendMessage(msg)
   elseif act[1] == "dump_globals" then
      System.LogGlobalTable()
   elseif act[1] == "remove" then
      _SOL_REMOVE_CACHED_OBJECT(chat_info.target.id)
   end
end
