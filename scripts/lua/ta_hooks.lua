local Hook = require 'solstice.hooks'
local ffi = require 'ffi'
local C = ffi.C

-- CNWSEffectListHandler::OnApplyAbilityIncrease(CNWSObject *,CGameEffect *,int) 0x0816F3A4
local Orig_OnApplyAbilityIncrease
local function Hook_OnApplyAbilityIncrease(handler, obj, eff, force)
   local res = Orig_OnApplyAbilityIncrease(handler, obj, eff, force)
   local cre = Game.GetObjectByID(obj.obj_id)
   if res == 0 and cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = eff.eff_integers[0]
      local amt = eff.eff_integers[1]
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
   end
   return res
end

Orig_OnApplyAbilityIncrease = Hook.hook {
   func = Hook_OnApplyAbilityIncrease,
   length = 5,
   address = 0x0816F3A4,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *, int32_t)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}


-- CNWSEffectListHandler::OnApplyAbilityDecrease(CNWSObject *,CGameEffect *,int) 0x0816F4D8
local Orig_OnApplyAbilityDecrease
local function Hook_OnApplyAbilityDecrease(handler, obj, eff, force)
   local res = Orig_OnApplyAbilityDecrease(handler, obj, eff, force)
   local cre = Game.GetObjectByID(obj.obj_id)
   if res == 0 and cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = eff.eff_integers[0]
      local amt = eff.eff_integers[1]
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] - amt
   end
   return res
end

Orig_OnApplyAbilityDecrease = Hook.hook {
   func = Hook_OnApplyAbilityDecrease,
   length = 5,
   address = 0x0816F4D8,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *, int32_t)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnRemoveAbilityIncrease(CNWSObject *,CGameEffect *) 0x0817CD04
local Orig_OnRemoveAbilityIncrease
local function Hook_OnRemoveAbilityIncrease(handler, obj, eff)
   local res = Orig_OnRemoveAbilityIncrease(handler, obj, eff)
   local cre = Game.GetObjectByID(obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = eff.eff_integers[0]
      local amt = eff.eff_integers[1]
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] - amt
   end
   return res
end

Orig_OnRemoveAbilityIncrease = Hook.hook {
   func = Hook_OnRemoveAbilityIncrease,
   length = 5,
   address = 0x0817CD04,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSEffectListHandler::OnRemoveAbilityDecrease(CNWSObject *,CGameEffect *) 0x0817CD50
local Orig_OnRemoveAbilityDecrease
local function Hook_OnRemoveAbilityDecrease(handler, obj, eff)
   local res = Orig_OnRemoveAbilityDecrease(handler, obj, eff)
   local cre = Game.GetObjectByID(obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local idx = eff.eff_integers[0]
      local amt = eff.eff_integers[1]
      cre.ci.ability_eff[idx] = cre.ci.ability_eff[idx] + amt
   end
   return res
end

Orig_OnRemoveAbilityDecrease = Hook.hook {
   func = Hook_OnRemoveAbilityDecrease,
   length = 5,
   address = 0x0817CD50,
   type = 'int32_t (*)(CNWSEffectListHandler *, CNWSObject *, CGameEffect *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}

-- CNWSCreature::GetMovementRateFactor(void) 0x08123FD8
local Orig_GetMovementRateFactor
local function Hook_GetMovementRateFactor(obj)
   local cre = Game.GetObjectByID(obj.obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local mo, ba, ta = 0, 0, 0
      if cre:GetLevelByClass(CLASS_TYPE_MONK) > 3 then
         mo = (cre:GetLevelByClass(CLASS_TYPE_MONK) / 3) * 0.1
      end
      if cre:GetLevelByClass(CLASS_TYPE_BARBARIAN) >= 1 then
         ba = 0.1
      end
      ta = (cre:GetProperty("TA_MOVE_SPEED") or 0) / 100

      return obj.cre_move_rate + math.max(mo, ba, ta)
   end
   return Orig_GetMovementRateFactor(cre)
end

Orig_GetMovementRateFactor = Hook.hook {
   func = Hook_GetMovementRateFactor,
   length = 5,
   address = 0x08123FD8,
   type = 'double (*)(CNWSCreature *)',
   flags = bit.bor(Hook.HOOK_DIRECT, Hook.HOOK_RETCODE)
}
