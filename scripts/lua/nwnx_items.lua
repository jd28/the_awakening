local NXItems = require 'solstice.nwnx.items'
local Eff = require 'solstice.effect'

local function ip_damage_range(info)
   if not info.object:GetIsValid() or
      not info.item:GetIsValid()
   then
      return
   end

   local start = info.event.ip.ip_cost_value
   local stop  = info.event.ip.ip_param_value

   if not info.event.remove then
      local dtype = Rules.ConvertItempropConstantToDamageIndex(info.event.ip.ip_subtype)
      local e = Eff.DamageRange(start, stop, dtype)

      e:SetInt(5, Rules.InventorySlotToAttackType(info.slot))

      e:SetCreator(info.item.id)
      info.object:ApplyEffect(DURATION_TYPE_EQUIPPED, e)
   else
      local dtype = bit.lshift(1, Rules.ConvertItempropConstantToDamageIndex(info.event.ip.ip_subtype))
      for i = info.object.obj.cre_stats.cs_first_damage_eff, info.object.obj.obj.obj_effects_len - 1 do
         if info.object.obj.obj.obj_effects[i].eff_creator == info.item.id
            and info.object.obj.obj.obj_effects[i].eff_integers[1] == dtype
            and info.object.obj.obj.obj_effects[i].eff_integers[3] == start
            and info.object.obj.obj.obj_effects[i].eff_integers[4] == stop
            and info.object.obj.obj.obj_effects[i].eff_integers[5] == Rules.InventorySlotToAttackType(info.slot)
            and info.object.obj.obj.obj_effects[i].eff_integers[7] == 1
         then
            info.object:RemoveEffectByID(i)
            break
         end
      end
   end
end

NXItems.RegisterItempropHandler(ITEM_PROPERTY_DAMAGE_RANGE, ip_damage_range)
