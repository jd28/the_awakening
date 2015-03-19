local NXItems = require 'solstice.nwnx.items'
--[[
local function ability_bonus(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if remove then amt = -amt end
   obj.ci.ability_eff[ip.ip_subtype] = obj.ci.ability_eff[ip.ip_subtype] + amt
end

NXItems.RegisterItempropHandler(ability_bonus, TA_ITEM_PROPERTY_ABILITY_BONUS,
                                ITEM_PROPERTY_ABILITY_BONUS)

local function ability_penalty(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if not remove then amt = -amt end
   obj.ci.ability_eff[ip.ip_subtype] = obj.ci.ability_eff[ip.ip_subtype] + amt
end

NXItems.RegisterItempropHandler(ability_penalty, TA_ITEM_PROPERTY_DECREASED_ABILITY_SCORE,
                                ITEM_PROPERTY_DECREASED_ABILITY_SCORE)
   --]]
