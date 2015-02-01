local NXItems = require 'solstice.nwnx.items'

local function movement(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_MOVEMENT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_MOVEMENT_PENALTY then
      if not remove then amt = -amt end
   end
   local cur = obj:GetProperty("TA_MOVE_SPEED") or 0
   obj:SetProperty("TA_MOVE_SPEED", amt + cur)
end

NXItems.RegisterItempropHandler(movement, TA_ITEM_PROPERTY_MOVEMENT_BONUS,
                                TA_ITEM_PROPERTY_MOVEMENT_PENALTY)
