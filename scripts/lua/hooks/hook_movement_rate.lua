local Hook = require 'solstice.hooks'
local ffi = require 'ffi'
local C = ffi.C
local max = math.max

-- CNWSCreature::GetMovementRateFactor(void) 0x08123FD8
local Orig_GetMovementRateFactor
local function Hook_GetMovementRateFactor(obj)
   local cre = Game.GetObjectByID(obj.obj.obj_id)
   if cre:GetType() == OBJECT_TYPE_CREATURE then
      local mo, ba, ta = 0, 0, 0
      local can, level = Rules.CanUseClassAbilities(cre, CLASS_TYPE_MONK)
      if can and level > 3 then
         mo = (cre:GetLevelByClass(CLASS_TYPE_MONK) / 3) * 0.1
      end
      if cre:GetLevelByClass(CLASS_TYPE_BARBARIAN) >= 1 then
         ba = 0.1
      end
      if mo == 0 then
         ta = (cre.ta_move_speed or 0) / 100
      end
      local mr = obj.cre_move_rate
      if mo == 0 and mr > 1.5 then
         mr = 1.5
      end
      return mr + max(mo, ba, ta)
   end
   return Orig_GetMovementRateFactor(cre)
end

Orig_GetMovementRateFactor = Hook.hook {
   name = "GetMovementRateFactor",
   func = Hook_GetMovementRateFactor,
   length = 5,
   address = 0x08123FD8,
   type = 'double (*)(CNWSCreature *)',
}
