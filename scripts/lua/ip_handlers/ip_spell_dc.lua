local NXItems = require 'solstice.nwnx.items'

local function spell_dc(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_SPELL_DC_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_SPELL_DC_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end
   local p = fmt("TA_SPELL_DC_BONUS_%d", ip.ip_subtype)
   local cur = obj:GetProperty(p) or 0
   obj:SetProperty(p, amt + cur)
end

NXItems.RegisterItempropHandler(spell_dc, TA_ITEM_PROPERTY_SPELL_DC_BONUS,
                                TA_ITEM_PROPERTY_SPELL_DC_PENALTY)
