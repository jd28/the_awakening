local NXItems = require 'solstice.nwnx.items'

local function crit_dmg(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_CRIT_DMG_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_CRIT_DMG_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj:GetProperty("TA_CRIT_DMG_BONUS") or 0
   obj:SetProperty("TA_CRIT_DMG_BONUS", amt + cur)
end

NXItems.RegisterItempropHandler(crit_dmg, TA_ITEM_PROPERTY_CRIT_DMG_BONUS,
                                TA_ITEM_PROPERTY_CRIT_DMG_PENALTY)
