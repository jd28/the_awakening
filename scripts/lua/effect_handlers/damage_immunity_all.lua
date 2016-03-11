local NWNXEffects = require 'solstice.nwnx.effects'

NWNXEffects.RegisterEffectHandler(
   function (eff, target, is_remove)
      local amt = eff:GetInt(0)
      if eff:GetType() == CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL then
         if is_remove then amt = -amt end
      elseif eff:GetType() == CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL then
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
