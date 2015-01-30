local Hook = require 'solstice.hooks'
local ffi = require 'ffi'
local C = ffi.C

local result = damage_result_t()

local function Hook_DoDamageImmunity(obj, vs, amount, flags, no_feedback, from_attack)
   if from_attack ~= 0 then return amount end

   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj.obj_id)
   local idx = C.ns_BitScanFFS(flags)
   local amt, adj = cre:DoDamageImmunity(amount, idx)

   result.damages[idx] = amt
   result.immunity[idx] = adj

   if cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs.obj.obj_id)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(
                              vs_name,
                              cre:GetName(),
                              result))
      cre:SendMessage(s)
   end
   return amt
end

Hook.hook {
   func = Hook_DoDamageImmunity,
   length = 5,
   address = 0x081CDC4C,
   type = 'int32_t (*)(CNWSObject *, CNWSCreature *, int32_t, uint16_t, int32_t, int32_t)',
   flags = Hook.HOOK_DIRECT
}

local function Hook_DoDamageResistance(obj, vs, amount, flags, no_feedback, from_attack, a)
   if from_attack ~= 0 then return amount end

   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj.obj_id)
   local idx = C.ns_BitScanFFS(flags)

   local start

   if cre.type == OBJECT_TRUETYPE_CREATURE then
      start = cre.obj.cre_stats.cs_first_dmgresist_eff
   end

   local eff, start = cre:GetBestDamageResistEffect(idx, start)
   local amt, adj, removed = cre:DoDamageResistance(amount, eff, idx)
   result.damages[idx] = amt
   if adj > 0 then
      result.resist[idx] = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         result.resist_remaining[idx] = eff.eff_integers[2]
      end
   end

   if removed then
      obj:RemoveEffectById(eff.eff_id)
   end

   if cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs.obj.obj_id)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(vs_name,
                                                      cre:GetName(),
                                                      result))
      cre:SendMessage(s)
   end

   return amt
end
--[[
Hook.hook {
   func = Hook_DoDamageResistance,
   length = 5,
   address = 0x081CC7BC,
   type = 'uint32_t (*)(CNWSObject *, CNWSCreature *, int32_t, uint16_t, int32_t, int32_t, int32_t)',
   flags = Hook.HOOK_DIRECT
}
--]]
local function Hook_DoDamageReduction(obj, vs, amount, power,
                                      no_feedback, from_attack)
   if from_attack ~= 0 then return amount end

   ffi.fill(result, ffi.sizeof('DamageResult'))
   local cre = Game.GetObjectByID(obj.obj_id)
   local idx = 12

   local start

   if cre.type == OBJECT_TRUETYPE_CREATURE then
      start = cre.obj.cre_stats.cs_first_dmgred_eff
   end

   eff = cre:GetBestDamageReductionEffect(power, start)

   amt, adj, removed = cre:DoDamageReduction(amount, eff, power)
   result.damages[idx] = amt
   if adj > 0 then
      result.reduction = adj
      if not removed and eff and eff.eff_integers[2] > 0 then
         result.reduction_remaining = eff.eff_integers[2]
      end
   end

   if removed then
      obj:RemoveEffectById(eff.eff_id)
   end

   if cre:GetType() == OBJECT_TYPE_CREATURE and cre:GetIsPC() then
      local vs_name = "Unknown"
      if vs ~= nil then
         local vs_ = Game.GetObjectByID(vs.obj.obj_id)
         vs_name = vs_:GetName()
      end
      local s = ffi.string(C.ns_GetCombatDamageString(vs_name,
                                                      cre:GetName(),
                                                      result))
      cre:SendMessage(s)
   end

   return amt
end
--[[
Hook.hook {
   func = Hook_DoDamageReduction,
   length = 5,
   address = 0x081CBD74,
   type = 'uint32_t (*)(CNWSObject *, CNWSCreature *, int32_t, uint16_t, int32_t, int32_t)',
   flags = Hook.HOOK_DIRECT
}
--]]
