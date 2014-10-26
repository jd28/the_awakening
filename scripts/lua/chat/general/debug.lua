local chat = require 'ta.chat'

local command = "debug"

local desc = [[Debugging Information:
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
   local to = chat.VerifyTarget(chat_info, OBJECT_TYPE_CREATURE)

   if pc.id ~= to.id then
      pc:ErrorMessage "You are only able to use this command on yourself!"
   end

   if act[1] == "resist" then
      pc:SendMessage(to:DebugDamageResistance())
   elseif act[1] == "soak" then
      pc:SendMessage(to:DebugDamageReduction())
   elseif act[1] == 'abilities' then
      pc:SendMessage(to:DebugAbilities())
   elseif act[1] == 'skills' then
      pc:SendMessage(to:DebugSkills())
   elseif act[1] == 'immunities' then
      pc:SendMessage(to:DebugDamageImmunities())
   elseif act[1] == 'ac' then
      pc:SendMessage(to:DebugArmorClass())
   elseif act[1] == 'ab' then
      pc:SendMessage(to:DebugAttackBonus())
   end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
