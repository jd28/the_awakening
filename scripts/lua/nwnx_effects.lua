local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effect'

local C = require('ffi').C
local bit = require 'bit'

-- This is an additional effect type that's built in already.  It applies
-- permenant hitpoints as an effect.  I.e. unlike temporary hitpoints they are
-- fully healable. Since it's kind of annoying to have the effect applied but
-- not to have those HP usable this will heal the target amount for the
-- additional hitpoints that it receives.
NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local amount = eff:GetInt(1)
      if not is_remove then
         if target:GetIsDead() then return true end
         target.ci.defense.hp_eff = target.ci.defense.hp_eff + amount
         target:ApplyEffect(DURATION_TYPE_INSTANT, Eff.Heal(amount))
      else
         target.ci.defense.hp_eff = target.ci.defense.hp_eff - amount
      end
   end,
   CUSTOM_EFFECT_TYPE_HITPOINTS)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      if not is_remove and target:GetIsDead() then
         return true
      end
      return false
   end,
   CUSTOM_EFFECT_TYPE_RECURRING)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      local immunity = effect:GetInt(1)
      local amount   = effect:GetInt(2)
      local new      = target.ci.defense.immunity_misc[immunity]

      if not is_remove then
         if target:GetIsDead() then return true end
         new = new - amount
      else
         new = new + amount
      end

      target.ci.defense.immunity_misc[immunity] = new
      return false
   end,
   CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE)

NWNXEffects.RegisterEffectHandler(
   function (effect, target, is_remove)
      if not is_remove then
         if target:GetIsDead() or target.type ~= OBJECT_TRUETYPE_CREATURE then
            return true
         end
         target:SetMovementRate(eff:GetInt(1))
      else
         target:SetMovementRate(0)
      end
      return false
   end,
   CUSTOM_EFFECT_TYPE_MOVEMENT_RATE)

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      if not is_remove then
         if target:GetIsDead() then return true end
      end
      local dc = target:GetLocalInt("gsp_mod_dc")
      local amt = eff:GetInt(1)
      if eff:GetInt(0) == CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE then
         amt = is_remove and -amt or amt
      elseif eff:GetInt(0) == CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE then
         amt = is_remove and amt or -amt
      end

      target:SetLocalInt("gsp_mod_dc", dc + amt)
   end,
   CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE,
   CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE)

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local new = 0
      local old = target.obj.cre_combat_round.cr_effect_atks
      if not is_remove then
         if target:GetIsDead() or target:GetType() ~= OBJECT_TYPE_CREATURE then
            return true
         end
         new = math.clamp(old + eff:GetInt(1), 0, 5)
      else
         local att = -eff:GetInt(1)
         for eff in target:Effects(true) do
            if eff:GetType() > 44 then break end
            if eff:GetType() == 44
               and eff:GetInt(0) == CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS
            then
               att = att + eff:GetInt(2)
            end
         end
         new = math.clamp(att, 0, 5)
      end
      target.obj.cre_combat_round.cr_effect_atks = new
   end,
   CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS)

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local amt = eff:GetInt(1)
      if eff:GetInt(0) == CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL then
         if is_remove then amt = -amt end
      elseif eff:GetInt(0) == CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL then
         if not is_remove then amt = -amt end
      else
         return
      end

      for i=0, DAMAGE_INDEX_NUM - 1 do
         target.ci.defense.immunity[i] = target.ci.defense.immunity[i] + amt
      end
   end,
   CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL,
   CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL)
