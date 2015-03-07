local Eff = require 'solstice.effect'

local function determine_type_amount(inctype, dectype, amount)
   if amount < 0 then
      return dectype, -amount
   end
   return inctype, amount
end

function Eff.SpellDC(school, amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE,
                                           CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE,
                                           amount)
   return Eff.CreateSimpleCustom(type, school, amt)
end

function Eff.DamageImmunityAll(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL,
                                           CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.StackingDamageReduction(amount, power)
   return Eff.CreateSimpleCustom(CUSTOM_EFFECT_TYPE_STACKING_DMG_REDUCTION, amount, power)
end

function Eff.StackingDamageResistance(damage_type, amount)
   return Eff.CreateSimpleCustom(CUSTOM_EFFECT_TYPE_STACKING_DMG_RESISTANCE, damage_type, amount)
end

function Eff.ExperienceGain(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_XP_BONUS,
                                           CUSTOM_EFFECT_TYPE_XP_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.SpellDamageBonus(school, amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_SPELL_DAMAGE_BONUS,
                                           CUSTOM_EFFECT_TYPE_SPELL_DAMAGE_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, school, amt)
end

function Eff.MovementSpeedBonus(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_MOVEMENT_BONUS,
                                           CUSTOM_EFFECT_TYPE_MOVEMENT_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.GoldGain(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_GOLD_BONUS,
                                           CUSTOM_EFFECT_TYPE_GOLD_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.CritChance(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_CRIT_THREAT_BONUS,
                                           CUSTOM_EFFECT_TYPE_CRIT_THREAT_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.CritDamage(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_CRIT_DMG_BONUS,
                                           CUSTOM_EFFECT_TYPE_CRIT_DMG_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end

function Eff.DamagePercent(amount)
   local type, amt = determine_type_amount(CUSTOM_EFFECT_TYPE_DMG_PERCENT_BONUS,
                                           CUSTOM_EFFECT_TYPE_DMG_PERCENT_PENALTY,
                                           amount)
   return Eff.CreateSimpleCustom(type, amt)
end
