local NWNXEffects = require 'solstice.nwnx.effects'
local fmt = string.format

local function spell_dmg_mod(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if ip.ip_type == TA_ITEM_PROPERTY_SPELL_DAMAGE_BONUS then
      if remove then amt = -amt end
   elseif ip.ip_type == TA_ITEM_PROPERTY_SPELL_DAMAGE_PENALTY then
      if not remove then amt = -amt end
   else
      assert(false)
   end

   local p = fmt("TA_SPELL_DMG_BONUS_%d", ip.ip_subtype)
   local cur = obj:GetProperty(p) or 0
   obj:SetProperty(p, amt + cur)
end

NWNXEffects.RegisterItempropHandler(spell_dmg_mod, TA_ITEM_PROPERTY_SPELL_DAMAGE_BONUS,
                                TA_ITEM_PROPERTY_SPELL_DAMAGE_PENALTY)
