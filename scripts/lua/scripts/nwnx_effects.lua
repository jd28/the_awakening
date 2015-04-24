local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effect'

local C = require('ffi').C
local bit = require 'bit'

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
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
