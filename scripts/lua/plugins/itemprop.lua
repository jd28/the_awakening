local NWNXEffects = require 'solstice.nwnx.effects'
local IP = require 'solstice.itemprop'
local fmt = string.format
local CreateItempropEffect = IP.CreateItempropEffect

-- Deleted item properties.
IP.BonusFeat = nil
IP.DamageBonus = nil
IP.DamageReduction = nil
IP.DamageResistance = nil
IP.ExtraDamageType = nil
IP.HolyAvenger = nil
IP.ImmunityMisc = nil
IP.ImprovedEvasion = nil
IP.LimitUseByClass = nil
IP.LimitUseByRace = nil
IP.OnHitCastSpell = nil

-- Additions

local function stacking_reduction(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if remove then amt = -amt end
   obj.ci.defense.soak_stack[ip.ip_subtype] = obj.ci.defense.soak_stack[ip.ip_subtype] + amt
end

NWNXEffects.RegisterItempropHandler(stacking_reduction, TA_ITEM_PROPERTY_STACKING_DMG_REDUCTION)

local function stacking_resistance(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if remove then amt = -amt end
   obj.ci.defense.resist_stack[ip.ip_subtype] = obj.ci.defense.resist_stack[ip.ip_subtype] + amt
end

NWNXEffects.RegisterItempropHandler(stacking_resistance, TA_ITEM_PROPERTY_STACKING_DMG_RESISTANCE)

--- Creates a damage range itemproperty.
function IP.DamageRange(damage_type, min, max)
   damage_type = Rules.ConvertDamageIndexToItempropConstant(damage_type)
   local eff = CreateItempropEffect()
   eff:SetValues(ITEM_PROPERTY_DAMAGE_RANGE, damage_type, 33, min, 12, max)
   return eff
end

function IP.OnHitCastSpellChance(spell, level, chance)
end

local function immunity_chance(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value

   if ip.ip_type == TA_ITEM_PROPERTY_IMMUNITY_MISC_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_IMMUNITY_MISC_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   obj.ci.defense.immunity_misc[ip.ip_subtype] = obj.ci.defense.immunity_misc[ip.ip_subtype] + amt
end

NWNXEffects.RegisterItempropHandler(immunity_chance, TA_ITEM_PROPERTY_IMMUNITY_MISC_BONUS,
                                    TA_ITEM_PROPERTY_IMMUNITY_MISC_PENALTY)

function IP.mmunityChance(immunity, perc)
end

local function xp_mod(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_XP_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_XP_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj['TA_XP_MODIFIER'] or 0
   obj['TA_XP_MODIFIER'] = cur + amt
end

NWNXEffects.RegisterItempropHandler(xp_mod, TA_ITEM_PROPERTY_XP_BONUS,
                                    TA_ITEM_PROPERTY_XP_PENALTY)

function IP.ExperienceModifier(value)
  local ip = CreateItempropEffect()
  if value < 0 then
    ip:SetValues(TA_ITEM_PROPERTY_XP_PENALTY, nil, 34, math.clamp(-value, 1, 100))
  else
    ip:SetValues(TA_ITEM_PROPERTY_XP_PENALTY, nil, 34, math.clamp(value, 1, 100))
  end
  return ip
end

local function spell_dmg_mod(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_SPELL_DAMAGE_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_SPELL_DAMAGE_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end

   local p = fmt("TA_SPELL_DMG_BONUS_%d", ip.ip_subtype)
   local cur = obj[p] or 0
   obj[p] = amt + cur
end

NWNXEffects.RegisterItempropHandler(spell_dmg_mod, TA_ITEM_PROPERTY_SPELL_DAMAGE_BONUS,
                                TA_ITEM_PROPERTY_SPELL_DAMAGE_PENALTY)

function IP.SpellDamageModifier(school, bonus)
end

local function movement(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_MOVEMENT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_MOVEMENT_PENALTY then
      if not remove then amt = -amt end
   end
   local cur = obj["TA_MOVE_SPEED"] or 0
   obj["TA_MOVE_SPEED"] = amt + cur
end

NWNXEffects.RegisterItempropHandler(movement, TA_ITEM_PROPERTY_MOVEMENT_BONUS,
                                TA_ITEM_PROPERTY_MOVEMENT_PENALTY)

function IP.MovementModifier(amt)
end

local function gold(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_GOLD_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_GOLD_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj["TA_GOLD_BONUS"] or 0
   obj["TA_GOLD_BONUS"] = amt + cur
end

NWNXEffects.RegisterItempropHandler(gold, TA_ITEM_PROPERTY_GOLD_BONUS,
                                TA_ITEM_PROPERTY_GOLD_PENALTY)

function IP.GoldFindModifier(amt)
end

local function crit_threat(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_CRIT_THREAT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_CRIT_THREAT_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj["TA_CRIT_THREAT_BONUS"] or 0
   obj["TA_CRIT_THREAT_BONUS"] = amt + cur
end

NWNXEffects.RegisterItempropHandler(crit_threat, TA_ITEM_PROPERTY_CRIT_THREAT_BONUS,
                                TA_ITEM_PROPERTY_CRIT_THREAT_PENALTY)

function IP.CritChanceModifier(amt)
end

local function crit_dmg(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_CRIT_DMG_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_CRIT_DMG_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj["TA_CRIT_DMG_BONUS"] or 0
   obj["TA_CRIT_DMG_BONUS"] = amt + cur
end

NWNXEffects.RegisterItempropHandler(crit_dmg, TA_ITEM_PROPERTY_CRIT_DMG_BONUS,
                                TA_ITEM_PROPERTY_CRIT_DMG_PENALTY)

function IP.CritDamageModifier(amt)
end

local function dmg_perc_bonus(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_DMG_PERCENT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_DMG_PERCENT_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj["TA_DMG_BONUS"] or 0
   obj["TA_DMG_BONUS"] = amt + cur
end

NWNXEffects.RegisterItempropHandler(dmg_perc_bonus, TA_ITEM_PROPERTY_DMG_PERCENT_BONUS,
                                TA_ITEM_PROPERTY_DMG_PERCENT_PENALTY)

function IP.DamageBonusModifier(amt)
end

-- TA_ITEM_PROPERTY_AC_BONUS
-- TA_ITEM_PROPERTY_TRUE_SEEING
-- TA_ITEM_PROPERTY_ON_HIT_PROPERTIES
-- TA_ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL
-- TA_ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL
