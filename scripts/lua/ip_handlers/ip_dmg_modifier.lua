local NWNXEffects = require 'solstice.nwnx.effects'

local function dmg_perc_bonus(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_DMG_PERCENT_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_DMG_PERCENT_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local cur = obj:GetProperty("TA_DMG_BONUS") or 0
   obj:SetProperty("TA_DMG_BONUS", amt + cur)
end

NWNXEffects.RegisterItempropHandler(dmg_perc_bonus, TA_ITEM_PROPERTY_DMG_PERCENT_BONUS,
                                TA_ITEM_PROPERTY_DMG_PERCENT_PENALTY)
