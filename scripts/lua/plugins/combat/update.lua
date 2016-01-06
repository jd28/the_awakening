local ffi = require 'ffi'
local C = ffi.C

--- Creates debug string for combat info equips
--[=[
function Creature:DebugCombatEquips()
  local t = {}
  local fmt = sm([[ID: %x:
             |  Ability AB: %d, Ability Damage Bonus: %d, Base Damage: %dd%d + %d,
             |  Base Damage Type(s): %x, Crit Range: %d, Crit Multiplier: %d,
             |  Power: %d, Has Dev Crit: %d, Iteration: %d, AB Modifier: %d,
             |  Transient AB Modifier: %d]])

  for i = 0, 5 do
    table.insert(t, string.format(fmt,
                        self.ci.equips[i].id,
                        self.ci.equips[i].ab_ability,
                        self.ci.equips[i].dmg_ability,
                        self.ci.equips[i].base_dmg_roll.dice,
                        self.ci.equips[i].base_dmg_roll.sides,
                        self.ci.equips[i].base_dmg_roll.bonus,
                        self.ci.equips[i].base_dmg_flags,
                        self.ci.equips[i].crit_range,
                        self.ci.equips[i].crit_mult,
                        self.ci.equips[i].power,
                        self.ci.equips[i].has_dev_crit and 1 or 0,
                        self.ci.equips[i].iter,
                        self.ci.equips[i].ab_mod,
                        self.ci.equips[i].transient_ab_mod))
  end

  return table.concat(t, '\n\n')
end
]=]
----------------------------------------------------------------------
-- Combat information update functions.

---
local function UpdateDamageImmunity(self)
  for i = 0, DAMAGE_INDEX_NUM - 1 do
    self.ci.dr.immunity_base[i] = Rules.GetBaseDamageReduction(self, i)
  end
end

---
local function UpdateDamageResistance(self)
  for i = 0, DAMAGE_INDEX_NUM - 1 do
    self.ci.dr.resist[i] = Rules.GetBaseDamageResistance(self, i)
  end
end

local function UpdateDamageReduction(self)
  self.ci.dr.soak = Rules.GetBaseDamageReduction(self)
end

local function UpdateAttacks(self)
  self.ci.offense.attacks_on  = Rules.GetOnhandAttacks(self)
  self.ci.offense.attacks_off = Rules.GetOffhandAttacks(self)
end

--- Updates equipped weapon object IDs.
local function UpdateCombatEquips(self)
  -- Determine the ranged weapon type, this is used in the combat engine
  -- to check if we can load more ammunition
  local rng_type = RANGED_TYPE_INVALID
  local rh = self:GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)
  if rh:GetIsValid() and Rules.GetIsRangedWeapon(rh) then
    local base = rh:GetBaseType()
    if base == BASE_ITEM_LONGBOW or base == BASE_ITEM_SHORTBOW then
      rng_type = RANGED_TYPE_BOW
    elseif base == BASE_ITEM_HEAVYCROSSBOW or base == BASE_ITEM_LIGHTCROSSBOW then
      rng_type = RANGED_TYPE_CROSSBOW
    elseif base == BASE_ITEM_THROWINGAXE then
      rng_type = RANGED_TYPE_THROWAXE
    elseif base == BASE_ITEM_SLING then
      rng_type = RANGED_TYPE_SLING
    elseif base == BASE_ITEM_DART then
      rng_type = RANGED_TYPE_DART
    elseif base == BASE_ITEM_SHURIKEN then
      rng_type = RANGED_TYPE_SHURIKEN
    end
  end
  self.ci.offense.ranged_type = rng_type

  local is_double = Game.Get2daInt("wpnprops", "Type", Rules.BaseitemToWeapon(rh)) == 7

  self.ci.equips[0].id = rh.id
  if is_double then
    self.ci.equips[1].id = rh.id
  else
    self.ci.equips[1].id = self:GetItemInSlot(INVENTORY_SLOT_LEFTHAND).id
  end
  self.ci.equips[2].id = self:GetItemInSlot(INVENTORY_SLOT_ARMS).id
  self.ci.equips[3].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_L).id
  self.ci.equips[4].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_R).id
  self.ci.equips[5].id = self:GetItemInSlot(INVENTORY_SLOT_CWEAPON_B).id
end

local function get_equip(cre, creator)
  for i=0, EQUIP_TYPE_NUM - 1 do
    if creator == cre.ci.equips[i].id then
      return i
    end
  end
  return -1
end

local function UpdateAttackBonus(self)
  self.ci.offense.ab_base = Rules.GetBaseAttackBonus(self)
  self.ci.offense.offhand_penalty_on,
  self.ci.offense.offhand_penalty_off = Rules.GetDualWieldPenalty(self)
  --Rules.UpdateAttackBonusEffects(self)
end


local function AddDamage(self, equip_num, type, dice, sides, bonus, mask)
  local len = self.ci.offense.damage_len
  if len >= 50 then
    local Log = System.GetLogger()
    Log:error("Unable to apply damage to creature (%x), maximum reached.", self.id)
    return
  end

  self.ci.offense.damage_equip[len] = equip_num
  self.ci.offense.damage[len].type = type
  self.ci.offense.damage[len].roll.dice,
  self.ci.offense.damage[len].roll.sides,
  self.ci.offense.damage[len].roll.bonus = dice, sides, bonus
  self.ci.offense.damage[len].mask = mask
  self.ci.offense.damage_len = len + 1
end

-- Determines creature's weapon combat info.
local function UpdateCombatWeaponInfo(self)
  local weap
  for i = 0, EQUIP_TYPE_NUM - 1 do
    weap = GetObjectByID(self.ci.equips[i].id)
    if weap:GetIsValid() or i == EQUIP_TYPE_UNARMED then

      self.ci.equips[i].ab_mod         = Rules.GetWeaponAttackBonus(self, weap)
      self.ci.equips[i].ab_ability     = Rules.GetWeaponAttackAbility(self, weap)
      self.ci.equips[i].dmg_ability    = Rules.GetWeaponDamageAbility(self, weap)
      self.ci.equips[i].iter           = Rules.GetWeaponIteration(self, weap)
      self.ci.equips[i].base_dmg_flags = Rules.GetWeaponBaseDamageType(weap)
      self.ci.equips[i].power          = Rules.GetWeaponPower(self, weap)
      if i == EQUIP_TYPE_UNARMED then
        self.ci.equips[i].base_dmg_roll.dice,
        self.ci.equips[i].base_dmg_roll.sides,
        self.ci.equips[i].base_dmg_roll.bonus = Rules.GetUnarmedDamageBonus(self)
      elseif i == EQUIP_TYPE_CREATURE_1
        or i == EQUIP_TYPE_CREATURE_2
        or i == EQUIP_TYPE_CREATURE_3
      then
        self.ci.equips[i].base_dmg_roll.dice,
        self.ci.equips[i].base_dmg_roll.sides,
        self.ci.equips[i].base_dmg_roll.bonus = Rules.GetCreatureDamageBonus(self, weap)
      else
        self.ci.equips[i].base_dmg_roll.dice,
        self.ci.equips[i].base_dmg_roll.sides,
        self.ci.equips[i].base_dmg_roll.bonus = Rules.GetWeaponBaseDamage(weap, self)
      end

      self.ci.equips[i].crit_range    = Rules.GetWeaponCritRange(self, weap)
      self.ci.equips[i].crit_mult    = Rules.GetWeaponCritMultiplier(self, weap)
    else
      self.ci.equips[i].ab_mod = 0
      self.ci.equips[i].ab_ability = 0
      self.ci.equips[i].dmg_ability = 0
      self.ci.equips[i].base_dmg_roll.dice,
      self.ci.equips[i].base_dmg_roll.sides,
      self.ci.equips[i].base_dmg_roll.bonus = 0, 0, 0
      self.ci.equips[i].base_dmg_flags = 0
      self.ci.equips[i].crit_range = 0
      self.ci.equips[i].crit_mult = 0
    end
  end
end

local function UpdateAmmoDamage(self)
  local obj
  if self.ci.offense.ranged_type == RANGED_TYPE_BOW then
    obj = self:GetItemInSlot(INVENTORY_SLOT_ARROWS)
  elseif self.ci.offense.ranged_type == RANGED_TYPE_SLING then
    obj = self:GetItemInSlot(INVENTORY_SLOT_BULLETS)
  elseif self.ci.offense.ranged_type == RANGED_TYPE_CROSSBOW then
    obj = self:GetItemInSlot(INVENTORY_SLOT_BOLTS)
  else
    return
  end

  if not obj:GetIsValid() then return end

  for ip in obj:ItemProperties() do
    if ip:GetPropertyType() == ITEM_PROPERTY_DAMAGE_BONUS then
      local type = ip:GetPropertySubType()
      if type > 2 then type = type - 2 end
      local d, s, b = Rules.UnpackItempropDamageRoll(ip:GetCostTableValue())
      AddDamage(self, 0, type, d, s, b, 0)
    end
  end

end

local function UpdateCombatModifiers(self)
  for i=0, COMBAT_MOD_NUM - 1 do
    self.ci.mods.ab[i] = Rules.GetCombatModifier(i, ATTACK_MODIFIER_AB, self) or 0
  end
  for i=0, COMBAT_MOD_NUM - 1 do
    self.ci.mods.ac[i] = Rules.GetCombatModifier(i, ATTACK_MODIFIER_AC, self) or 0
  end
  for i=0, COMBAT_MOD_NUM - 1 do
    self.ci.mods.hp[i] = Rules.GetCombatModifier(i, ATTACK_MODIFIER_HP, self) or 0
  end
  for i=0, COMBAT_MOD_NUM - 1 do
    local t = Rules.GetCombatModifier(i, ATTACK_MODIFIER_DAMAGE, self)
    if t then self.ci.mods.dmg[i] = t end
  end
end

local function UpdateSituationModifiers(self)
  for i=0, SITUATION_NUM - 1 do
    self.ci.situ.ab[i] = Rules.GetSituationModifier(i, ATTACK_MODIFIER_AB, self) or 0
  end
  for i=0, SITUATION_NUM - 1 do
    self.ci.situ.ac[i] = Rules.GetSituationModifier(i, ATTACK_MODIFIER_AC, self) or 0
  end
  for i=0, SITUATION_NUM - 1 do
    self.ci.situ.hp[i] = Rules.GetSituationModifier(i, ATTACK_MODIFIER_HP, self) or 0
  end
  for i=0, SITUATION_NUM - 1 do
    local t = Rules.GetSituationModifier(i, ATTACK_MODIFIER_DAMAGE, self)
    if t then self.ci.situ.dmg[i] = t end
  end
end

local function UpdateDamage(self)
  self.ci.offense.damage_len = 0

  for i = self.obj.cre_stats.cs_first_damage_eff, self.obj.obj.obj_effects_len - 1 do
    if self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_DECREASE and
      self.obj.obj.obj_effects[i].eff_type ~= EFFECT_TYPE_DAMAGE_INCREASE
    then
      break
    end

    -- Check race versus is not set.
    if self.obj.obj.obj_effects[i].eff_integers[2] == 28 then
      local type     = C.ns_BitScanFFS(self.obj.obj.obj_effects[i].eff_integers[1])
      local start    = self.obj.obj.obj_effects[i].eff_integers[3]
      local stop     = self.obj.obj.obj_effects[i].eff_integers[4]
      local att_type = self.obj.obj.obj_effects[i].eff_integers[5]
      local mask     = self.obj.obj.obj_effects[i].eff_integers[6]
      local range    = self.obj.obj.obj_effects[i].eff_integers[7] == 1

      local etype = -1
      if att_type ~= ATTACK_TYPE_MISC then
        etype = Rules.AttackTypeToEquipType(att_type)
      end

      if self.obj.obj.obj_effects[i].eff_type == EFFECT_TYPE_DAMAGE_DECREASE then
        mask = mask == 0 and 1 or mask
      else
        mask = mask
      end
      local d,s,b = 0, 0, 0

      if range then
        d,s,b = 1, stop - start + 1, start - 1
      else
        d,s,b = Rules.UnpackItempropDamageRoll(self.obj.obj.obj_effects[i].eff_integers[0])
      end

      AddDamage(self, etype, type, d, s, b, mask)
    end
  end
end

local function UpdateCriticalDamage(self, equip_num, item)
  if item:GetIsValid() then
    for ip in item:ItemProperties() do
      if ip:GetPropertyType() == ITEM_PROPERTY_MASSIVE_CRITICALS then
        local d, s, b = Rules.UnpackItempropDamageRoll(ip:GetCostTableValue())
        AddDamage(self, equip_num, DAMAGE_INDEX_BASE_WEAPON, d, s, b, 2)
        break
      end
    end
  end

  local feat = Rules.GetWeaponFeat(MASTERWEAPON_FEAT_CRIT_OVERWHELMING, item)
  if feat ~= -1 and self:GetHasFeat(feat) then
    AddDamage(self, equip_num, DAMAGE_INDEX_BASE_WEAPON,
              self.ci.equips[equip_num].crit_mult,
              6,
              0,
              2)
  end
end



--- Updates a creature's combat modifiers.
-- See ConbatMod ctype.
-- @bool all Force all combat information to be updated.
local function UpdateCombatInfo(cre)
  if not cre.ci then
   cre.ci = ffi.new("CombatInfo")
  end

  cre.ci.fe_mask = cre:GetFavoredEnemenyMask()
  cre.ci.training_vs_mask = cre:GetTrainingVsMask()

  UpdateCombatEquips(cre)
  UpdateCombatWeaponInfo(cre)
  UpdateAttacks(cre)
  UpdateDamage(cre)
  if cre.ci.offense.ranged_type > 0 then
    UpdateAmmoDamage(cre)
  end
  for i = 0, EQUIP_TYPE_NUM - 1 do
    local weap = GetObjectByID(cre.ci.equips[i].id)
    UpdateCriticalDamage(cre, i, weap)
  end
  UpdateAttackBonus(cre)
  UpdateDamageReduction(cre)
  UpdateDamageResistance(cre)
  UpdateDamageImmunity(cre)
  UpdateCombatModifiers(cre)
  UpdateSituationModifiers(cre)
  cre.ci.offense.crit_chance_modifier = cre["TA_CRIT_THREAT_BONUS"] or 0
  cre.ci.offense.crit_dmg_modifier = cre["TA_CRIT_DMG_BONUS"] or 0
  cre.ci.offense.damge_bonus_modifier = cre["TA_DMG_BONUS"] or 0
end

local function UpdateEffect(cre, eff)
  if EFFECT_TYPE_DAMAGE_DECREASE == eff:GetType()
    or EFFECT_TYPE_DAMAGE_INCREASE == eff:GetType()
  then
    print(cre, eff)
  end
end

--Game.OnUpdateEffect:register(nil, UpdateEffect)

return {
  UpdateCombatInfo = UpdateCombatInfo
}
