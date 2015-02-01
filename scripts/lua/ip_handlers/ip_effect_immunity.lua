local NXItems = require 'solstice.nwnx.items'

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

NXItems.RegisterItempropHandler(immunity_chance, TA_ITEM_PROPERTY_IMMUNITY_MISC_BONUS,
                                TA_ITEM_PROPERTY_IMMUNITY_MISC_PENALTY)
