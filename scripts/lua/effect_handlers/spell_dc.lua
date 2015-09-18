local NWNXEffects = require 'solstice.nwnx.effects'
local Eff = require 'solstice.effect'

local C = require('ffi').C
local bit = require 'bit'

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      if not is_remove then
         if target:GetIsDead() then return true end
      end
      local dc = target:GetLocalInt("gsp_mod_dc")
      local amt = eff:GetInt(0)
      if eff:GetType() == CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE then
         amt = is_remove and -amt or amt
      elseif eff:GetType() == CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE then
         amt = is_remove and amt or -amt
      end

      target:SetLocalInt("gsp_mod_dc", dc + amt)
   end,
   CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE,
   CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE)
