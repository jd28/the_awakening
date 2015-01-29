local chat = require 'ta.chat'

local command = 'combat'
local desc = ''

local fmt = string.format
local floor = math.floor
local tinsert = table.insert
local tconcat = table.concat

local function action(info)
   local pc  = info.speaker
   local act = info.param:split(' ')
   if not act then return end

   if act[1] == "equips" then
      pc:UpdateCombatInfo(true)
      if ce and ce.UpdateCombatInformation then
         ce.UpdateCombatInformation(pc)
      end

      pc:SendMessage(pc:DebugCombatEquips())
   elseif act[1] == "aoo" then
      if act[2] == "off" then
         pc:SendMessage("You will no longer make attacks of opportunity")
         pc:SetLocalInt('NWNX_NO_AOO', 1)
      elseif act[2] == "on" then
         pc:SendMessage("You can now make attacks of opportunity")
         pc:DeleteLocalInt('NWNX_NO_AOO')
      end
   elseif act[1] == 'offense' then
      pc:UpdateCombatInfo(true)
      if ce and ce.UpdateCombatInformation then
         ce.UpdateCombatInformation(pc)
      end

      local t = {}
      tinsert(t, "Attacks:")
      tinsert(t, fmt("    Onhand: %d", pc.ci.offense.attacks_on))
      tinsert(t, fmt("    Offhand: %d", pc.ci.offense.attacks_off))
      tinsert(t, fmt("    Extra: %d", pc.obj.cre_combat_round.cr_effect_atks))

      tinsert(t, "Critical Bonus:")
      tinsert(t, fmt("    Damage: %.2f%%", pc:GetProperty('TA_CRIT_DMG_BONUS') or 0))
      tinsert(t, fmt("    Chance: %.2f%%", pc:GetProperty('TA_CRIT_THREAT_BONUS') or 0))

      tinsert(t, "Damages:")
      for j = 0, pc.ci.offense.damage_len - 1 do
         tinsert(t, fmt("  Type: %d, Roll: %dd%d + %d, Mask: %d",
                        pc.ci.offense.damage[j].type,
                        pc.ci.offense.damage[j].roll.dice,
                        pc.ci.offense.damage[j].roll.sides,
                        pc.ci.offense.damage[j].roll.bonus,
                        pc.ci.offense.damage[j].mask))
      end


      tinsert(t, "Weapons:")
      for i = 0, EQUIP_TYPE_NUM - 1 do
         local weap = _SOL_GET_CACHED_OBJECT(pc.ci.equips[i].id)
         if weap:GetIsValid() then
            tinsert(t, fmt("  %s", weap:GetName()))
            tinsert(t, fmt("    Attack Bonus: %d",
                           pc:GetAttackBonusVs(OBJECT_INVALID, i)))
            tinsert(t, fmt("    Iteration: %d",
                           pc.ci.equips[i].iter))
            tinsert(t, fmt("    Critical Chance: %d%%",
                           5 * pc.ci.equips[i].crit_range))
            tinsert(t, fmt("    Critical Damage: %d%%",
                           pc.ci.equips[i].crit_mult * 100))

            tinsert(t, fmt("    Base Damage: %d-%d + %d",
                           pc.ci.equips[i].base_dmg_roll.dice,
                           pc.ci.equips[i].base_dmg_roll.sides,
                           pc.ci.equips[i].base_dmg_roll.bonus +
                              pc.ci.equips[i].dmg_ability))
            tinsert(t, "    Damage:")
            for j = 0, pc.ci.equips[i].damage_len - 1 do
               tinsert(t, fmt("      Type: %d, Roll: %dd%d + %d, Mask: %d",
                              pc.ci.equips[i].damage[j].type,
                              pc.ci.equips[i].damage[j].roll.dice,
                              pc.ci.equips[i].damage[j].roll.sides,
                              pc.ci.equips[i].damage[j].roll.bonus,
                              pc.ci.equips[i].damage[j].mask))
            end
         end
      end
      pc:SendMessage(tconcat(t, "\n"))
   elseif act[1] == 'defense' then
      pc:UpdateCombatInfo(true)
      if ce and ce.UpdateCombatInformation then
         ce.UpdateCombatInformation(pc)
      end

      local t = {}
      local melee = pc:GetConcealment(OBJECT_INVALID, false)
      local range = pc:GetConcealment(OBJECT_INVALID, true)

      tinsert(t, fmt("Armor Class: %d, Touch: %d",
                     pc:GetACVersus(OBJECT_INVALID, false),
                     pc:GetACVersus(OBJECT_INVALID, true)))

      tinsert(t, "Hitpoints:")
      tinsert(t, fmt("  Current: %d", pc:GetCurrentHitPoints()))
      tinsert(t, fmt("  Max: %d", pc.ci.defense.hp_max))
      tinsert(t, fmt("  From Effects: %d", pc.ci.defense.hp_eff))

      tinsert(t, "Concealment:")
      tinsert(t, fmt("  Melee: Base: %d, Vs Blindfight: %d",
                     melee, floor((melee * melee) / 100)))
      tinsert(t, fmt("  Ranged: Base: %d, Vs Blindfight: %d",
                     range, floor((range * range) / 100)))


      tinsert(t, "Immunities:")
      for i = 0, IMMUNITY_TYPE_NUM - 1 do
         tinsert(t, fmt('  %d: Amount: %d',
                        i,
                        pc.ci.defense.immunity_misc[i]))
      end

      pc:SendMessage(tconcat(t, "\n"))
   elseif act[1] == 'modifiers' then
      pc:UpdateCombatInfo(true)
      if ce and ce.UpdateCombatInformation then
         ce.UpdateCombatInformation(pc)
      end
      local t = {}
      tinsert(t, "Modifiers: ")
      for i = 0, COMBAT_MOD_NUM - 1 do
         tinsert(t, fmt("    %d: AB: %d, AC: %d, HP: %d, Damage: Type: %d, Roll: %dd%d + %d, Mask: %x",
                 i,
                 pc.ci.mods[i].ab,
                 pc.ci.mods[i].ac,
                 pc.ci.mods[i].hp,
                 pc.ci.mods[i].dmg.type,
                 pc.ci.mods[i].dmg.roll.dice,
                 pc.ci.mods[i].dmg.roll.sides,
                 pc.ci.mods[i].dmg.roll.bonus,
                 pc.ci.mods[i].dmg.mask))
      end
      pc:SendMessage(tconcat(t, "\n"))
   elseif act[1] == 'situations' then
      pc:UpdateCombatInfo(true)
      if ce and ce.UpdateCombatInformation then
         ce.UpdateCombatInformation(pc)
      end

      local t = {}
      tinsert(t, "Situations: ")
      for i = 0, SITUATION_NUM - 1 do
         tinsert(t, fmt("    %d: AB: %d, AC: %d, HP: %d, Damage: Type: %d, Roll: %dd%d + %d, Mask: %x",
                 i,
                 pc.ci.mod_situ[i].ab,
                 pc.ci.mod_situ[i].ac,
                 pc.ci.mod_situ[i].hp,
                 pc.ci.mod_situ[i].dmg.type,
                 pc.ci.mod_situ[i].dmg.roll.dice,
                 pc.ci.mod_situ[i].dmg.roll.sides,
                 pc.ci.mod_situ[i].dmg.roll.bonus,
                 pc.ci.mod_situ[i].dmg.mask))
      end
      pc:SendMessage(tconcat(t, "\n"))
   elseif act[1] == 'mode' then
      pc:UpdateCombatInfo(true)

      pc:SendMessage(fmt("Mode: %d : AB: %d, AC: %d, HP: %d, Damage: Type: %d, Roll: %dd%d + %d, Mask: %x",
                         pc.obj.cre_mode_combat,
                         pc.ci.mod_mode.ab,
                         pc.ci.mod_mode.ac,
                         pc.ci.mod_mode.hp,
                         pc.ci.mod_mode.dmg.type,
                         pc.ci.mod_mode.dmg.roll.dice,
                         pc.ci.mod_mode.dmg.roll.sides,
                         pc.ci.mod_mode.dmg.roll.bonus,
                         pc.ci.mod_mode.dmg.mask))
   end
end

chat.RegisterCommand(CHAT_SYMBOL_GENERAL, command, action, desc)
