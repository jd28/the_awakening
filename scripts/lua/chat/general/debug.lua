command = "debug"

description = [[Debugging Information:
               |  Usage: !debug [option]
               |  Options:
               |    ab - Debug attack bonus
               |    abilities - Debug ability scores.
               |    ac - Debug armor class.
               |    resist - Debug damage resistance
               |    skills - Debug skills.
               |    soak - Debug damage reduction.
               |    immunities - Debug immunities]]

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
   elseif act[1] == 'immunities' then
      pc:SendMessage(pc:DebugDamageImmunities())
   elseif act[1] == 'ac' then
      pc:SendMessage(pc:DebugArmorClass())
   elseif act[1] == 'ab' then
      pc:SendMessage(pc:DebugAttackBonus())
   end
end
