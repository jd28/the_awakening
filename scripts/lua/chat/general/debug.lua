command = "debug"

description = [[Debugging Information:
               |Usage:
               |  !debug abilities
               |  !debug resist
               |  !debug skills
               |  !debug soak]]

function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "resist" then
      pc:SendMessage(pc:DebugDamageResistance())
   elseif act[1] == "soak" then
      pc:SendMessage(pc:DebugDamageReduction())
   elseif act[1] == 'abilities' then
      pc:SendMessage(pc:DebugAbilities())
   elseif act[1] == 'skills' then
      pc:SendMessage(pc:DebugSkills())
   end
end
