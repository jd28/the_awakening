local NWNXEffects = require 'solstice.nwnx.effects'

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      if not is_remove then
         if target:GetIsDead() or target.type ~= OBJECT_TRUETYPE_CREATURE then
            return true
         end
         target:SetMovementRate(eff:GetInt(0))
      else
         target:SetMovementRate(0)
      end
      return false
   end,
   CUSTOM_EFFECT_TYPE_MOVEMENT_RATE)
