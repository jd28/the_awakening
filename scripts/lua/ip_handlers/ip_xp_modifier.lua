local NWNXEffects = require 'solstice.nwnx.effects'

local function xp_mod(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_XP_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_XP_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj:GetProperty("TA_XP_BONUS") or 0
   obj:SetProperty("TA_XP_BONUS", amt + cur)
end

NWNXEffects.RegisterItempropHandler(xp_mod, TA_ITEM_PROPERTY_XP_BONUS,
                                    TA_ITEM_PROPERTY_XP_PENALTY)
