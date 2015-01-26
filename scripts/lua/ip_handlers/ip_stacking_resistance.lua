local NXItems = require 'solstice.nwnx.items'

local function stacking_resistance(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if remove then amt = -amt end
   obj.ci.defense.resist_stack[ip.ip_subtype] = obj.ci.defense.resist_stack[ip.ip_subtype] + amt
end

NXItems.RegisterItempropHandler(stacking_resistance, TA_ITEM_PROPERTY_STACKING_DMG_RESISTANCE)
