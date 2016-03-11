local NWNXEffects = require 'solstice.nwnx.effects'

local function dmg_imm(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value - 50
   if remove then amt = -amt end
   obj.ci.defense.immunity[ip.ip_subtype] = obj.ci.defense.immunity[ip.ip_subtype] + amt
end
--NWNXEffects.RegisterItempropHandler(dmg_imm, TA_ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)

local lookup = {
   [1] = 5,
   [2] = 10,
   [3] = 25,
   [4] = 50,
   [5] = 75,
   [6] = 90,
   [7] = 100,
}

local function dmg_imm2(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if amt > 50 then
      amt = amt - 50
   else
      amt = lookup[amt]
      if not amt then return end
   end
   if remove then amt = -amt end
   local idx = Rules.ConvertItempropConstantToDamageIndex(ip.ip_subtype)
   obj.ci.defense.immunity[idx] = obj.ci.defense.immunity[idx] + amt
end
--NWNXEffects.RegisterItempropHandler(dmg_imm2, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)


local function dmg_vuln(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value - 50
   if not remove then amt = -amt end
   obj.ci.defense.immunity[ip.ip_subtype] = obj.ci.defense.immunity[ip.ip_subtype] + amt
end
--NWNXEffects.RegisterItempropHandler(dmg_vuln, TA_ITEM_PROPERTY_DAMAGE_VULNERABILITY)

local function dmg_vuln2(item, obj, ip, slot, remove)
   local amt = ip.ip_cost_value
   if amt > 50 then
      amt = amt - 50
   else
      amt = lookup[amt]
      if not amt then return end
   end
   if not remove then amt = -amt end
   local idx = Rules.ConvertItempropConstantToDamageIndex(ip.ip_subtype)
   obj.ci.defense.immunity[idx] = obj.ci.defense.immunity[idx] + amt
end
--NWNXEffects.RegisterItempropHandler(dmg_vuln2, ITEM_PROPERTY_DAMAGE_VULNERABILITY)
