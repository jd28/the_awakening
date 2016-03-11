local chat = require 'ta.chat'
local Serv = require 'ta.server'

local command = "debug"

local desc = [[Debugging Information:
              |  Usage: !debug [option]
              |  Options:
              |    ab - Debug attack bonus
              |    abilities - Debug ability scores.
              |    ac - Debug armor class.
              |    skills - Debug skills.
              |    damage [resist, soak, imm] - Debug damage reduction.
              |    immunities - Debug immunities]]

local function action(info)
  local pc  = info.speaker
  local act = info.param:split(' ')
  if not act then return end
  local to = chat.VerifyTarget(info, OBJECT_TYPE_CREATURE)
  if not to:GetIsValid() then return end

  if pc.id ~= to.id and not Serv.VerifyDM(pc) then
    pc:ErrorMessage "You are only able to use this command on yourself!"
    return
  end

  if act[1] == "damage" then
    if act[2] == 'resist' then
      pc:SendMessage(Rules.DebugDamageResistance(to))
    elseif act[2] == "soak" then
      pc:SendMessage(Rules.DebugDamageReduction(to))
    elseif act[2] == "imm" then
      pc:SendMessage(Rules.DebugDamageImmunity(to))
    end
  elseif act[1] == 'abilities' then
    pc:SendMessage(Rules.DebugAbilities(to))
  elseif act[1] == 'skills' then
    pc:SendMessage(to:DebugSkills())
  elseif act[1] == 'immunities' then
    pc:SendMessage(Rules.DebugEffectImmunities(to))
  elseif act[1] == 'ac' then
    pc:SendMessage(Rules.DebugArmorClass(to))
  elseif act[1] == 'ab' then
    pc:SendMessage(Rules.DebugAttackBonus(to))
  end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
