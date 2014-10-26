local chat = require 'ta.chat'

local command = "effects"
local desc = ''

local NXEffects = require 'solstice.nwnx.effects'
local fmt = string.format

function action(info)
   local pc = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "dump" then
      NXEffects.SendEffects(pc)
   elseif act[1] == "count" then
      pc:SendMessage(fmt("You currently have %d effects applied",
                         pc.obj.obj.obj_effects_len))
   elseif act[1] == "log" then
      NXEffects.Log(pc)
   end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
