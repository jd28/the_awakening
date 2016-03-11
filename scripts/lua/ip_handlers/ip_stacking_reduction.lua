local NWNXEffects = require 'solstice.nwnx.effects'

local function stacking_reduction(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if remove then amt = -amt end
   obj.ci.defense.soak_stack[ip.ip_subtype] = obj.ci.defense.soak_stack[ip.ip_subtype] + amt
end

NWNXEffects.RegisterItempropHandler(stacking_reduction, TA_ITEM_PROPERTY_STACKING_DMG_REDUCTION)
