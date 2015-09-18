local NWNXEffects = require 'solstice.nwnx.effects'

local function crit_threat(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_CRIT_THREAT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_CRIT_THREAT_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj:GetProperty("TA_CRIT_THREAT_BONUS") or 0
   obj:SetProperty("TA_CRIT_THREAT_BONUS", amt + cur)
end

NWNXEffects.RegisterItempropHandler(crit_threat, TA_ITEM_PROPERTY_CRIT_THREAT_BONUS,
                                TA_ITEM_PROPERTY_CRIT_THREAT_PENALTY)
