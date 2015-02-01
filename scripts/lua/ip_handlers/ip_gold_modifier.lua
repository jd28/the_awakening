local NXItems = require 'solstice.nwnx.items'

local function gold(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_GOLD_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_GOLD_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj:GetProperty("TA_GOLD_BONUS") or 0
   obj:SetProperty("TA_GOLD_BONUS", amt + cur)
end

NXItems.RegisterItempropHandler(gold, TA_ITEM_PROPERTY_GOLD_BONUS,
                                TA_ITEM_PROPERTY_GOLD_PENALTY)
