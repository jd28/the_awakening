--- Attack module
--

require 'plugins.combat.ctypes'

local ffi = require 'ffi'
local C = ffi.C
local random = math.random
local floor  = math.floor
local min    = math.min
local GetObjectByID = Game.GetObjectByID

local bit    = require 'bit'
local bor    = bit.bor
local band   = bit.band
local lshift = bit.lshift

local Eff = require 'solstice.effect'
local Attack = require 'solstice.attack'
local AddCCMessage = Attack.AddCCMessage
local AddDamageToResult = Attack.AddDamageToResult
local AddEffect = Attack.AddEffect
local AddVFX = Attack.AddVFX
local ClearSpecialAttack = Attack.ClearSpecialAttack
local AddCCMessage = Attack.AddCCMessage
local AddEffect = Attack.AddEffect
local AddVFX = Attack.AddVFX
local ClearSpecialAttack = Attack.ClearSpecialAttack
local CopyDamageToNWNAttackData = Attack.CopyDamageToNWNAttackData
local GetResult = Attack.GetResult
local GetIsRangedAttack = Attack.GetIsRangedAttack
local GetIsSneakAttack = Attack.GetIsSneakAttack
local GetIsSpecialAttack = Attack.GetIsSpecialAttack
local GetSpecialAttack = Attack.GetSpecialAttack
local SetSneakAttack = Attack.SetSneakAttack
local GetType = Attack.GetType
local GetAttackRoll = Attack.GetAttackRoll
local GetIsCoupDeGrace = Attack.GetIsCoupDeGrace
local GetIsCriticalHit = Attack.GetIsCriticalHit
local GetIsDeathAttack = Attack.GetIsDeathAttack
local GetIsHit = Attack.GetIsHit
local SetAttackMod = Attack.SetAttackMod
local SetAttackRoll = Attack.SetAttackRoll
local SetConcealment = Attack.SetConcealment
local SetCriticalResult = Attack.SetCriticalResult
local SetMissedBy = Attack.SetMissedBy
local SetResult = Attack.SetResult

local Dice   = require 'solstice.dice'
local DoRoll = Dice.DoRoll
local RollValid = Dice.IsValid
local GetIsRangedWeapon = Rules.GetIsRangedWeapon

-- Used to cache some combat info.
local info, attacker, target, attacker_ci, target_ci

--- Get critical hit roll
-- @param info AttackInfo.
-- @param attacker Attacking creature.
local function GetCriticalHitRoll(info, attacker)
   return (attacker_ci.equips[info.weapon].crit_range * 5)
      + attacker_ci.offense.crit_chance_modifier
end

--- Get current weapon.
-- @param info AttackInfo
-- @param attacker Attacking object.
local function GetCurrentWeapon(info, attacker)
   local n = info.weapon
   if n >= 0 and n <= 5 then
      local id = attacker_ci.equips[n].id
      return GetObjectByID(id)
   end
   return OBJECT_INVALID
end

--- Determine if current attack is an offhand attack.
-- @param info AttackInfo.
-- @param attacker Attacker.
local function GetIsOffhandAttack(info, attacker)
   local cr = attacker.obj.cre_combat_round
   return attacker.obj.cre_combat_round.cr_current_attack + 1 >
      attacker.obj.cre_combat_round.cr_effect_atks
      + attacker.obj.cre_combat_round.cr_additional_atks
      + attacker.obj.cre_combat_round.cr_onhand_atks
end

local function GetTotalAttacks(info, attacker)
  local res = attacker.obj.cre_combat_round.cr_effect_atks
     + attacker.obj.cre_combat_round.cr_additional_atks
     + attacker.obj.cre_combat_round.cr_onhand_atks
     + attacker.obj.cre_combat_round.cr_offhand_atks;

  return res < 1 and 1 or res
end

--- Determines the attack penalty based on attack count.
-- @param info AttackInfo.
-- @param attacker Attacking creature.
local function GetIterationPenalty(info, attacker)
   local iter_pen = 0
   local spec_att = GetSpecialAttack(info)

   -- Deterimine the iteration penalty for an attack.  Not all attack types are
   -- have it.
   if GetType(info) == ATTACK_TYPE_OFFHAND then
      iter_pen = 5 * attacker.obj.cre_combat_round.cr_offhand_taken
      attacker.obj.cre_combat_round.cr_offhand_taken = attacker.obj.cre_combat_round.cr_offhand_taken + 1
   elseif attacker.obj.cre_combat_round.cr_current_attack > attacker.obj.cre_combat_round.cr_onhand_atks then
      -- Normally this would have checked for ATTACK_TYPE_EXTRA1 or
      -- ATTACK_TYPE_EXTRA1, but those seemed superfluous.

      if spec_att ~= 867 or
         spec_att ~= 868 or
         spec_att ~= 391
      then
         iter_pen = 5 * attacker.obj.cre_combat_round.cr_extra_taken
      end
      attacker.obj.cre_combat_round.cr_extra_taken = attacker.obj.cre_combat_round.cr_extra_taken + 1
   elseif spec_att ~= 65002 and spec_att ~= 6 and spec_att ~= 391 then
      iter_pen = attacker.obj.cre_combat_round.cr_current_attack * attacker_ci.equips[info.weapon].iter
   end

   return iter_pen
end

--- Determine total damage.
-- @param info AttackInfo.
local function GetDamageTotal(info)
   local sum = 0
   for i = 0, 12 do
      sum = sum + info.dmg_result.damages[i]
   end
   return sum
end

local function ResolveCachedSpecialAttacks(attacker)
   C.nwn_ResolveCachedSpecialAttacks(attacker.obj)
end

--- Resolve pre-roll.
-- @param info AttackInfo.
-- @param attacker Attacker
-- @param target Target
local function ResolvePreRoll(info, attacker, target)
   if not GetIsCoupDeGrace(info) then
      ResolveCachedSpecialAttacks(attacker)
   end

   -- Special Attack
   -- Determine if able to use special attack (if one has been used).
   if GetIsSpecialAttack(info) then
      local sa = GetSpecialAttack(info)
      if sa < 1115 and attacker:GetRemainingFeatUses(sa) == 0 then
         ClearSpecialAttack(info)
      end
   end
end

--- Resolves Armor Class Roll
--  A large part of the AC is calculated in Creature:GetAC, only those parts
--  that are potentially determined by the target are calculated below.
-- @param info AttackInfo.
-- @param attacker Attacker
-- @param target Target
local function ResolveArmorClass(info, attacker, target)
   return Rules.GetACVersus(target, attacker, false, info, GetIsRangedAttack(info), info.target_state)
end

--- Resolves that attack bonus of the creature.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveAttackModifier(info, attacker, target)
   return Rules.GetAttackBonusVs(attacker, target, info.weapon)
end

--- Determine miss chance / concealment.

-- @param hit Is hit.
-- @param use_cached
-- @return Returns true if the attacker failed to over come miss chance
-- or concealment.
local function ResolveMissChance(info, attacker, target, hit, use_cached)
   -- Miss Chance
   local miss_chance = 0
   -- Conceal
   local conceal = target:GetConcealment(attacker, info.attack)

   -- If concealment and mis-chance are less than or equal to zero
   -- there is no chance of them affecting the outcome of an attack.
   if conceal <= 0 and miss_chance <= 0 then return false end

   local chance, attack_result

   -- Deterimine which of miss chance and concealment is higher.
   -- attack_result is a magic number for the NWN combat engine that
   -- determines which combat messages are sent to the player.
   if miss_chance < conceal then
      chance = conceal
      attack_result = 8
   else
      chance = miss_chance
      attack_result = 9
   end

   -- The attacker has two possible chances to over come miss chance / concealment
   -- if they posses the blind fight feat.  If not they only have one chance to do so.
   if random(100) >= chance
      or (attacker:GetHasFeat(FEAT_BLIND_FIGHT) and random(100) >= chance)
   then
      return false
   else
      SetResult(info, attack_result)
      -- Show the modified conceal/miss chance in the combat log.
      SetConcealment(info, floor((chance ^ 2) / 100))
      SetMissedBy(info, 1)
      return true
   end
end

--- Resolves deflect arrow.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param hit Is hit.
local function ResolveDeflectArrow(info, attacker, target, hit)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then
      return false
   end
   -- Deflect Arrow
   if hit
      and attacker.obj.cre_combat_round.cr_deflect_arrow == 1
      and info.attack.cad_ranged_attack ~= 0
      and bit.band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(FEAT_DEFLECT_ARROWS)
   then
      local on = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
      local off = target:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)

      if not on:GetIsValid()
         or (target:GetRelativeWeaponSize(on) <= 0
         and not GetIsRangedWeapon(on)
         and not off:GetIsValid())
      then
         on = attacker:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
         on = on:GetBaseType()
         local bow
         if on ~= BASE_ITEM_DART
            and on ~= BASE_ITEM_THROWINGAXE
            and on ~= BASE_ITEM_SHURIKEN
         then
            bow = 0
         else
            bow = 1
         end
         attacker.obj.cre_combat_round.cr_deflect_arrow = 0
         SetResult(info, 2)
         info.attack.cad_attack_deflected = 1
         return true
      end
   end
   return false
end

--- Resolve parry
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param hit is hit.
local function ResolveParry(info, attacker, target, hit)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return false end

   if info.attack.cad_attack_roll == 20
      or attacker.obj.cre_mode_combat ~= COMBAT_MODE_PARRY
      or attacker.obj.cre_combat_round.cr_parry_actions == 0
      or attacker.obj.cre_combat_round.cr_round_paused ~= 0
      or info.attack.cad_ranged_attack ~= 0
   then
      return false
   end

   -- Can not Parry when using a Ranged Weapon.
   local on = target:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
   if on:GetIsValid() and GetIsRangedWeapon(on) then
      return false
   end

   local roll = random(20) + target:GetSkillRank(SKILL_PARRY)
   target.obj.cre_combat_round.cr_parry_actions = target.obj.cre_combat_round.cr_parry_actions - 1

   if roll >= info.attack.cad_attack_roll + info.attack.cad_attack_mod then
      if roll - 10 >= info.attack.cad_attack_roll + info.attack.cad_attack_mod then
         target:AddParryAttack(attacker)
      end
      SetResult(info, 2)
      return true
   end

   C.nwn_AddParryIndex(target.obj.cre_combat_round)
   return false
end

--- Resolve attack roll.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveAttackRoll(info, attacker, target)
   -- Determine attack modifier
   local ab = ResolveAttackModifier(info, attacker, target) -
      GetIterationPenalty(info, attacker)

   if GetIsSpecialAttack(info) then
      ab = ab + Rules.GetSpecialAttackModifier(GetSpecialAttack(info), info, attacker, target)
   end

   SetAttackMod(info, ab)

   -- Determine AC
   local ac = ResolveArmorClass(info, attacker, target)

   -- If there is a Coup De Grace, automatic hit.  Effects are dealt with in
   -- ResolvePostMelee/RangedDamage
   if GetIsCoupDeGrace(info) then
      SetResult(info, 7)
      SetAttackRoll(info, 20)
      return
   end

   local roll = random(20)
   SetAttackRoll(info, roll)

   local hit = (roll + ab >= ac or roll == 20) and roll ~= 1

   if ResolveMissChance(info, attacker, target, hit)
      or ResolveDeflectArrow(info, attacker, target, hit)
      or ResolveParry(info, attacker, target, hit)
   then
      return
   end

   if not hit then
      SetResult(info, 4)
      if roll == 1 then
         SetMissedBy(info, 1)
      else
         SetMissedBy(info, ac - ab + roll)
      end
      return
   else
      SetResult(info, 1)
   end

   -- Determine if this is a critical hit.
   if random(100) <= GetCriticalHitRoll(info, attacker) then
      SetCriticalResult(info, roll, 1)

      if not target:GetIsImmune(IMMUNITY_TYPE_CRITICAL_HIT) then
         -- Is critical hit
         SetResult(info, 3)
      else
         -- Send target immune to crits.
         AddCCMessage(info, nil, { target.id }, { 126 })
      end
   end
end

--- Resolve damage result.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param mult crit multiplier
-- @param ki_strike Is WM Ki Strike.
local function ResolveDamageResult(info, attacker, mult, ki_strike)
   for i = 0, attacker_ci.equips[info.weapon].damage_len - 1 do
      AddDamageToResult(info, attacker_ci.equips[info.weapon].damage[i], mult)
   end

   for i = 0, attacker_ci.offense.damage_len - 1 do
      AddDamageToResult(info, attacker_ci.offense.damage[i], mult)
   end

   info.dmg_result.damages[12] = info.dmg_result.damages[12]
      + DoRoll(attacker_ci.equips[info.weapon].base_dmg_roll, mult)

   info.dmg_result.damages[12] = info.dmg_result.damages[12]
      + (attacker_ci.equips[info.weapon].dmg_ability * mult)

   AddDamageToResult(info, attacker_ci.mod_mode.dmg, mult)
end

--- Resolve damage modifications.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveDamageModifications(info, attacker, target)
   if GetIsCriticalHit(info) and target.type == OBJECT_TRUETYPE_CREATURE then
      local parry = min(target:GetSkillRank(SKILL_PARRY, attacker, true), 50)
      if parry > 0 then
         for i=0, DAMAGE_INDEX_NUM - 1 do
            local adj = floor((info.dmg_result.damages[i] * parry) / 100)
            info.dmg_result.damages[i] = info.dmg_result.damages[i] - adj
         end
         info.dmg_result.parry = parry
      end
   end

   local eff
   local start

   if target.type == OBJECT_TRUETYPE_CREATURE then
      start = target.obj.cre_stats.cs_first_dmgresist_eff
   end

   eff, start = target:GetBestDamageResistEffect(attacker_ci.equips[info.weapon].base_dmg_flags, start)
   local amt, adj, removed = target:DoDamageResistance(info.dmg_result.damages[12], eff, 12)
   info.dmg_result.damages[12] = amt

   if adj > 0 then
      info.dmg_result.resist[12] = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         info.dmg_result.resist_remaining[12] = eff.eff_integers[2]
      end
   end

   for i=0, DAMAGE_INDEX_NUM - 1 do
      if info.dmg_result.damages[i] > 0 and i ~= 12 then
         eff, start = target:GetBestDamageResistEffect(i, start)

         amt, adj, removed = target:DoDamageResistance(info.dmg_result.damages[i], eff, i)
         info.dmg_result.damages[i] = amt
         if adj > 0 then
            info.dmg_result.resist[i] = adj
            if not removed and eff and eff.eff_integers[2] > 0 then
               info.dmg_result.resist_remaining[i] = eff.eff_integers[2]
            end
         end
      end
   end

   for i = 0, DAMAGE_INDEX_NUM - 1 do
      if info.dmg_result.damages[i] > 0 then
         local idx = i
         if i == 12 then
            idx = attacker_ci.equips[info.weapon].base_dmg_flags
         end
         local amt, adj = target:DoDamageImmunity(info.dmg_result.damages[i], idx)
         info.dmg_result.damages[i] = amt
         if adj > 0 then
            info.dmg_result.immunity[i] = adj
         end
      end
   end

   if target.type == OBJECT_TRUETYPE_CREATURE then
      start = target.obj.cre_stats.cs_first_dmgred_eff
   else
      start = nil
   end

   eff = target:GetBestDamageReductionEffect(attacker_ci.equips[info.weapon].power, start)

   amt, adj, removed = target:DoDamageReduction(info.dmg_result.damages[12],
                                                eff,
                                                attacker_ci.equips[info.weapon].power)
   info.dmg_result.damages[12] = amt
   if adj > 0 then
      info.dmg_result.reduction = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         info.dmg_result.reduction_remaining = eff.eff_integers[2]
      end
   end
end

--- Resolve item cast spell.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveItemCastSpell(info, attacker, target)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return end

   local weapon = GetCurrentWeapon(info, attacker)
   if weapon.type == OBJECT_TRUETYPE_ITEM then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          weapon.obj, false)
   end

   local shield = target:GetItemInSlot(INVENTORY_SLOT_LEFTHAND)
   local chest = target:GetItemInSlot(INVENTORY_SLOT_CHEST)

   if chest.type == OBJECT_TRUETYPE_ITEM then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          chest.obj, true)
   end
   if shield.type == OBJECT_TRUETYPE_ITEM and
      (shield.obj.it_baseitem == BASE_ITEM_SMALLSHIELD or
       shield.obj.it_baseitem == BASE_ITEM_LARGESHIELD or
       shield.obj.it_baseitem == BASE_ITEM_TOWERSHIELD)
   then
      C.ns_AddOnHitSpells(info.attack, attacker.obj, target.obj.obj,
                          shield.obj, true)
   end
end

--- Resolve on hit effects...
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveOnHitEffect(info, attacker, target)
   C.nwn_ResolveOnHitEffect(attacker.obj, target.obj.obj, info.is_offhand,
                            GetIsCriticalHit(info))
end
jit.off(ResolveOnHitEffect)

--- Resolve on hit visual effects.
--    This is not default behavior.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
local function ResolveOnHitVFX(info, attacker)
   -- No ffects on ranged attacks...
   if GetIsRangedAttack(info) then return end
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      local vfx = Rules.GetDamageVisual(i)
      if vfx > 0 and info.dmg_result.damages[i] > 0 then
         AddVFX(info, attacker, vfx)
      end
   end
end

--- Compact physical damages.
-- All phsyicals are applied as base weapon damage.
-- @param info Attack ctype.
local function CompactPhysicalDamage(info)
   info.dmg_result.damages[12] = info.dmg_result.damages[12] +
      info.dmg_result.damages[0] +
      info.dmg_result.damages[1] +
      info.dmg_result.damages[2]

   info.dmg_result.damages[0] = 0
   info.dmg_result.damages[1] = 0
   info.dmg_result.damages[2] = 0

  info.dmg_result.damages_unblocked[12] = info.dmg_result.damages_unblocked[12] +
      info.dmg_result.damages_unblocked[0] +
      info.dmg_result.damages_unblocked[1] +
      info.dmg_result.damages_unblocked[2]

   info.dmg_result.damages_unblocked[0] = 0
   info.dmg_result.damages_unblocked[1] = 0
   info.dmg_result.damages_unblocked[2] = 0
end

local function AddUnblockables(info)
   for i = 0, DAMAGE_INDEX_NUM - 1 do
      info.dmg_result.damages[i] = info.dmg_result.damages[i] + info.dmg_result.damages_unblocked[i]
   end
end

--- Resolves that damage of the creature.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- NOTE: This function is only ever called by the combat engine.
local function ResolveDamage(info, attacker, target)
   local ki_strike = GetSpecialAttack(info) == 882
   -- If this is a critical hit determine the multiplier.
   local mult = 1
   local modifier = 0
   if GetIsCriticalHit(info) then
      modifier = attacker_ci.equips[info.weapon].crit_mult * 100
      modifier = modifier + attacker_ci.offense.crit_dmg_modifier
   end

   ResolveDamageResult(info, attacker, mult, ki_strike)
   -- Modes
   for i = 0, COMBAT_MOD_SKILL do
      if RollValid(attacker_ci.mods.dmg[i].roll) then
         AddDamageToResult(info, attacker_ci.mods.dmg[i], mult)
      end
   end

   if attacker:GetHasTrainingVs(target)
      and RollValid(attacker_ci.mods.dmg[COMBAT_MOD_TRAINING_VS].roll)
   then
      AddDamageToResult(info, attacker_ci.mods.dmg[COMBAT_MOD_TRAINING_VS], mult)
   end

   if attacker:GetIsFavoredEnemy(target)
      and RollValid(attacker_ci.mods.dmg[COMBAT_MOD_FAVORED_ENEMY].roll)
   then
      AddDamageToResult(info, attacker_ci.mods.dmg[COMBAT_MOD_FAVORED_ENEMY], mult)
   end

   -- Special attacks
   if GetIsSpecialAttack(info) then
      local d = Rules.GetSpecialAttackDamage(GetSpecialAttack(info), info, attacker, target)
      if RollValid(d.roll) then
         AddDamageToResult(info, d, mult)
      end
   end

   if modifier > 0 then
      for i = 0, DAMAGE_INDEX_NUM - 1 do
         info.dmg_result.damages[i] = (info.dmg_result.damages[i] * modifier) / 100
      end

      for i = 0, DAMAGE_INDEX_NUM - 1 do
         info.dmg_result.damages_unblocked[i] = (info.dmg_result.damages_unblocked[i] * modifier) / 100
      end
   end

   for i = 0, SITUATION_NUM - 1 do
      if band(lshift(1, i), info.situational_flags) ~= 0 then
         -- Don't multiply situational damage.
         if RollValid(attacker_ci.mod_situ.dmg[i].roll) then
            AddDamageToResult(info, attacker_ci.mod_situ[i].dmg, 1)
         end
      end
   end

   CompactPhysicalDamage(info)
   ResolveDamageModifications(info, attacker, target)
   AddUnblockables(info)

   local total = GetDamageTotal(info)

   -- Defensive Roll
   if target.type == OBJECT_TRUETYPE_CREATURE
      and target:GetCurrentHitPoints() - total <= 0
      and band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) == 0
      and target:GetHasFeat(FEAT_DEFENSIVE_ROLL, true)
   then
      target:DecrementRemainingFeatUses(FEAT_DEFENSIVE_ROLL)

      if target:ReflexSave(total, SAVING_THROW_VS_DEATH, attacker) then
         for i=0, DAMAGE_INDEX_NUM - 1 do
            info.dmg_result.damages[i] = floor(info.dmg_result.damages[i] / 2)
         end
      end
   end

   total = GetDamageTotal(info)

   -- Add the damage result info to the CNWSCombatAttackData
   CopyDamageToNWNAttackData(info, attacker, target)

   -- Epic Dodge : Don't want to use it unless we take damage.
   if target.type == OBJECT_TRUETYPE_CREATURE
      and total > 0
      and target.obj.cre_combat_round.cr_epic_dodge_used == 0
      and target:GetHasFeat(FEAT_EPIC_DODGE)
   then
      AddCCMessage(info, 2, { target.id }, { 234 })
      SetResult(info, 4)
      target.obj.cre_combat_round.cr_epic_dodge_used = 1
   else
      if target.obj.obj.obj_is_invulnerable == 1 then
         total = 0
      else
         -- Item onhit cast spells are done regardless of whether weapon damage is
         -- greater than zero.
         ResolveItemCastSpell(info, attacker, target)
      end

      if total > 0 then
         ResolveOnHitEffect(info, attacker, target)
         ResolveOnHitVFX(info, attacker)
      end
   end
end

--- Resolves Coup De Grace.
-- Applies death effect if applicable.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveCoupDeGrace(info, attacker, target)
   if bit.band(info.target_state, COMBAT_TARGET_STATE_ASLEEP) == 0             or
      (target.type == OBJECT_TRUETYPE_CREATURE and target.obj.cre_is_immortal) or
      target.obj.obj.obj_is_invulnerable == 1
   then
      return
   end

   AddEffect(info, attacker, Eff.Death(false, true))
   info.is_killing = true
end

--- Resolves Devastating Critical.
-- Applies death effect if applicable, whether this used is determined by
-- settings.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveDevCrit(info, attacker, target)
   if not GetIsCriticalHit(info)
      or OPT.DEVCRIT_DISABLE_ALL
   then
      return
   end

   local dc = 10 + floor(attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(ABILITY_STRENGTH)

   if target:FortitudeSave(dc, SAVING_THROW_VS_DEATH, attacker) == 0 then
      AddEffect(info, attacker, Eff.Death(true, true))
      SetResult(info, 10)
      info.is_killing = true
   end
end

--- Resolves Crippling Strike
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveCripplingStrike(info, attacker, target)
   if band(info.situational_flags, SITUATION_FLAG_SNEAK_ATTACK) == 0 or
      not attacker:GetHasFeat(FEAT_CRIPPLING_STRIKE)
   then
      return
   end

   local e = Eff.Ability(ABILITY_STRENGTH, -2)
   e:SetDurationType(DURATION_TYPE_PERMANENT)
   AddEffect(info, attacker, e)
end

--- Resolves Death Attack
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveDeathAttack(info, attacker, target)
   if band(info.situational_flags, SITUATION_FLAG_DEATH_ATTACK) == 0
      or target.obj.cre_combat_state == 0
   then
      return
   end
   local dc = attacker:GetLevelByClass(CLASS_TYPE_ASSASSIN)
      + 10 + attacker:GetAbilityModifier(ABILITY_INTELLIGENCE)

   if target:FortitudeSave(dc, SAVING_THROW_VS_DEATH, attacker) == 0 then
      C.nwn_ApplyOnHitDeathAttack(attacker.obj, target.obj.obj, random(6) + attacker:GetHitDice())
   end
end
jit.off(ResolveDeathAttack)

--- Resolves Quivering Palm
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveQuiveringPalm(info, attacker, target)
   if GetSpecialAttack(info) ~= SPECIAL_ATTACK_QUIVERING_PALM or
      target:GetHitDice() >= attacker:GetHitDice()            or
      GetDamageTotal(info) <= 0                               or
      target:GetIsImmune(IMMUNITY_TYPE_CRITICAL_HIT)          or
      target:FortitudeSave(10 + (attacker:GetHitDice() / 2) + attacker:GetAbilityModifier(ABILITY_WISDOM),
                           0, attacker) == 0
   then
      return
   end
   local e = Eff.Death(true, true)
   e:SetDurationType(DURATION_TYPE_INSTANT)
   AddEffect(info, attacker, e)
end

--- Resolves Circle Kick.
-- Can be disabled with `DISABLE_CIRCLE_KICK` setting.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveCircleKick(info, attacker, target)
   if OPT.DISABLE_CIRCLE_KICK               or
      GetIsSpecialAttack(info)              or
      GetTotalAttacks(info, attacker) >= 49 or
      info.weapon ~= EQUIP_TYPE_UNARMED     or
      not attacker:GetHasFeat(FEAT_CIRCLE_KICK)
   then
      return
   end

   local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
   local nearest = C.nwn_GetNearestEnemy(attacker.obj, max_range, target.obj.obj.obj_id)
   if nearest == OBJECT_INVALID.id then return end

   attacker.obj.cre_combat_round.cr_new_target = nearest
   C.nwn_AddCircleKickAttack(attacker.obj, nearest)
   attacker.obj.cre_passive_attack_beh = 1
   attacker.obj.cre_combat_round.cr_num_circle_kicks = attacker.obj.cre_combat_round.cr_num_circle_kicks - 1
end

--- Resolves (Great) Cleave.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveCleave(info, attacker, target)
   if GetSpecialAttack(info) == FEAT_WHIRLWIND_ATTACK   or
      GetSpecialAttack(info) == FEAT_IMPROVED_WHIRLWIND or
      GetTotalAttacks(info, attacker) >= 49
   then
      return
   end

   if attacker:GetHasFeat(FEAT_GREAT_CLEAVE) then
      local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
      local nearest = C.nwn_GetNearestTarget(attacker.obj, max_range, target.obj.obj.obj_id)
      if nearest == OBJECT_INVALID.id then return end

      attacker.obj.cre_combat_round.cr_new_target = nearest
      C.nwn_AddCleaveAttack(attacker.obj, nearest, true)
      attacker.obj.cre_passive_attack_beh = 1

   elseif attacker.obj.cre_combat_round.cr_num_cleaves > 0 and attacker:GetHasFeat(FEAT_CLEAVE) then
      local max_range = C.nwn_GetMaxAttackRange(attacker.obj, OBJECT_INVALID.id)
      local nearest = C.nwn_GetNearestTarget(attacker.obj, max_range, target.obj.obj.obj_id)
      if nearest == OBJECT_INVALID.id then return end

      attacker.obj.cre_combat_round.cr_new_target = nearest
      C.nwn_AddCleaveAttack(attacker.obj, nearest, false)
      attacker.obj.cre_passive_attack_beh = 1
      attacker.obj.cre_combat_round.cr_num_cleaves = attacker.obj.cre_combat_round.cr_num_cleaves - 1
   end
end

--- Resolve post damage stuff.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
-- @param is_ranged
local function ResolvePostDamage(info, attacker, target, is_ranged)
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return end

   ResolveCoupDeGrace(info, attacker, target)
   ResolveDevCrit(info, attacker, target)
   if not info.is_killing then
      ResolveDeathAttack(info, attacker, target)
   end

   -- No more posts apply to ranged.
   if is_ranged then return end

   if not info.is_killing then
      ResolveCripplingStrike(info, attacker, target)
      ResolveDeathAttack(info, attacker, target)
      ResolveQuiveringPalm(info, attacker, target)
      ResolveCircleKick(info, attacker, target)
   else
      ResolveCleave(info, attacker, target)
   end
end

--- Resolve situations.
-- @param info Attack ctype.
-- @param attacker Attacking creature.
-- @param target Target object.
local function ResolveSituations(info, attacker, target)
   local flags = 0
   if target.type ~= OBJECT_TRUETYPE_CREATURE then return flags end

   local x = attacker.obj.obj.obj_position.x - target.obj.obj.obj_position.x;
   local y = attacker.obj.obj.obj_position.y - target.obj.obj.obj_position.y;
   local z = attacker.obj.obj.obj_position.z - target.obj.obj.obj_position.z;

   -- Save some time by not sqrt'ing to get magnitude
   info.target_distance = x * x + y * y + z * z;

   if info.target_distance <= 100 then
      -- Coup De Grace
      if band(info.target_state, COMBAT_TARGET_STATE_ASLEEP) ~= 0 and
         target:GetHitDice() <= 10
      then
         flags = bor(flags, SITUATION_FLAG_COUPDEGRACE)
         info.attack.cad_coupdegrace = 1
      end
   end

   -- In order for a sneak attack situation to be possiblle the attacker must
   -- be able to do some amount of sneak damage.
   local death = RollValid(attacker_ci.situ.dmg[SITUATION_DEATH_ATTACK].roll)
   local sneak = RollValid(attacker_ci.situ.dmg[SITUATION_SNEAK_ATTACK].roll)

   -- Sneak Attack & Death Attack
   if (sneak or death) and
      (band(info.target_state, COMBAT_TARGET_STATE_ATTACKER_UNSEEN) ~= 0 or
       band(info.target_state, COMBAT_TARGET_STATE_FLATFOOTED) ~= 0 or
       band(info.target_state, COMBAT_TARGET_STATE_FLANKED) ~= 0)
   then
      if not target:GetIsImmune(IMMUNITY_TYPE_SNEAK_ATTACK) then
         -- Death Attack.  If it's a Death Attack it's also a sneak attack.
         if death then
            flags = bor(flags, SITUATION_FLAG_DEATH_ATTACK)
         end
         if sneak then
            flags = bor(flags, SITUATION_FLAG_SNEAK_ATTACK)
         end
         SetSneakAttack(info, sneak, death)
      else
         AddCCMessage(info, nil, { target.id }, { 134 })
      end
   end
   return flags
end

local function ResolvePreAttack(attacker_, target_)
   info     = C.Local_GetAttack()
   attacker = attacker_
   target   = target_
   attacker_ci = attacker.ci
   info.ranged_type = attacker.ci.offense.ranged_type

   -- If the target is a creature detirmine it's state and any situational modifiers that
   -- might come into play.  This only needs to be done once per attack group because
   -- the values can't change.
   if target.type == OBJECT_TRUETYPE_CREATURE then
      info.target_state = attacker:GetTargetState(target)
      info.situational_flags = ResolveSituations(info, attacker, target)
      target_ci = target.ci
   else
      target_ci = nil
   end
end

--- Do melee attack.
local function DoMeleeAttack()
   ResolvePreRoll(info, attacker, target)
   ResolveAttackRoll(info, attacker, target)

   if not GetIsHit(info) then return end
   ResolveDamage(info, attacker, target)

   if target:GetCurrentHitPoints() <= GetDamageTotal(info) then
      info.is_killing = true
   else
      info.is_killing = false
   end

   ResolvePostDamage(info, attacker, target, false)

   -- Attempt to resolve a special attack one was
   -- a) Used
   -- b) The attack is a hit.
   if GetIsSpecialAttack(info) then
      -- Special attacks only apply when the target is a creature
      -- and damage is greater than zero.
      if target.type == OBJECT_TRUETYPE_CREATURE and GetDamageTotal(info) > 0 then
         attacker:DecrementRemainingFeatUses(GetSpecialAttack(info))

         -- The resolution of Special Attacks will return an effect to be applied
         -- or nil.
         local success, eff = Rules.GetSpecialAttackImpact(GetSpecialAttack(info), info, attacker, target)
         if success then
            -- Add any effects to the onhit effect list so that it can
            -- be applied when damage is signaled.
            if eff then
               if type(eff) == 'table' then
                  for i=1, #eff do
                     AddEffect(info, attacker, eff[i])
                  end
               else
                  AddEffect(info, attacker, eff)
               end
            end
         else
            -- If the special attack failed because it wasn't
            -- applicable or the targets skill check (for example)
            -- was success full set the attack result to 5.
            SetResult(info, 5)
         end
      else
         -- If the target is not a creature or no damage was dealt set attack result to 6.
         SetResult(info, 6)
      end
   end
end

--- Do ranged attack.
local function DoRangedAttack()
   ResolvePreRoll(info, attacker, target)
   ResolveAttackRoll(info, attacker, target)

   if not GetIsHit(info) then return end

   ResolveDamage(info, attacker, target)

   if target:GetCurrentHitPoints() <= GetDamageTotal(info) then
      info.is_killing = true
   else
      info.is_killing = false
   end

   ResolvePostDamage(info, attacker, target, true)

   -- Attempt to resolve a special attack one was
   -- a) Used
   -- b) The attack is a hit.
   if GetIsSpecialAttack(info) then
      -- Special attacks only apply when the target is a creature
      -- and damage is greater than zero.
      if target.type == OBJECT_TRUETYPE_CREATURE
         and GetDamageTotal(info) > 0
      then
         attacker:DecrementRemainingFeatUses(GetSpecialAttack(info))

         -- The resolution of Special Attacks will return an effect to be applied
         -- or nil.
         local success, eff = Rules.GetSpecialAttackImpact(GetSpecialAttack(info), info, attacker, target)
         if success then
            -- Add any effects to the onhit effect list so that it can
            -- be applied when damage is signaled.
            if eff then
               if type(eff) == 'table' then
                  for i=1, #eff do
                     AddEffect(info, attacker, eff[i])
                  end
               else
                  AddEffect(info, attacker, eff)
               end
            end
         else
            -- If the special attack failed because it wasn't
            -- applicable or the targets skill check (for example)
            -- was success full set the attack result to 5.
            SetResult(info, 5)
         end
      else
         -- If the target is not a creature or no damage was dealt set attack result to 6.
         SetResult(info, 6)
      end
   end
end

return {
   DoRangedAttack = DoRangedAttack,
   DoMeleeAttack = DoMeleeAttack,
   ResolvePreAttack = ResolvePreAttack,
}