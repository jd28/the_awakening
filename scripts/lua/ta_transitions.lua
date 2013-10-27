local Ev = require 'solstice.event'
local Log = require('ta.logger').Log
local Inst = require 'ta.instance'

local function check_transition(trans, pc)
   -- DMs can go anyhwere...
   if pc:GetIsDM() or pc:GetIsDMPossessed() then return true end

   local jump = true
   local area = pc:GetArea()

   local key  = trans:GetLocalString("KeyTag")
   local spawn = trans:GetLocalBool("CheckSpawn")
   local despawn = trans:GetLocalBool("CheckDespawn")
   local env = trans:GetLocalBool("CheckEnv")
   local level = trans:GetLocalInt("Level")
   local despawn_time = area:GetLocalInt("DespawnTime")
   
   Log:debug([[Check Transitions:
   Key: %s
   Spawn: %s
   Despawn: %s
   Despawn Time: %d
   Environment: %s
   Level: %d]], 
   key, tostring(spawn), tostring(despawn), despawn_time, tostring(env), level)

--[[
   if level > 0 and pc:GetHitDice() < level then
      return false
   end


    int nPercent      = GetPercentEncountersSpawned(oArea, oClicker);
    int bClear        = GetIsAreaClear(oArea, oClicker);
    int bJump         = TRUE;
    int nHideTime     = GetLocalInt(oArea, "PL_LAST_STEALTH");
    int nTime         = GetLocalInt(GetModule(), "uptime") - nHideTime; 

 if (nHideTime > 0 && nTime < 300 && nPercent < 50) {
        bJump = FALSE;
        FloatingTextStringOnCreature("You cannot make this transition after hiding.", oClicker);
    } else if (nCheckSpawn && !bClear) {
        FloatingTextStringOnCreature("You cannot make this transition while enemies are about.", oClicker);
        bJump = FALSE;
    } else if (nCheckDespawn && nDespawnTime > 0) {
        FloatingTextStringOnCreature("You may not continue after despawning monsters.", oClicker, FALSE);
        bJump = FALSE;
    } else if (nCheckLevel && !GetIsDM(oClicker) && (nCheckLevel > GetLevelIncludingLL(oClicker))) {
        FloatingTextStringOnCreature("You must be at least level " + IntToString(nCheckLevel) + " to use this transition.", oClicker, FALSE);
        bJump = FALSE;
    } else if (sKey != "" && !GetLocalInt(oTransition, "Open")) {
        object oKey = GetItemPossessedBy(oClicker, sKey);
        if (GetIsObjectValid(oKey)) {
            DestroyObject(oKey);
            SetLocalInt(oTransition, "Open", 1);
            FloatingTextStringOnCreature("The key allows passage!", oClicker, FALSE);
            string sBarrier = GetLocalString(oTransition, "KeyBarrier");
            if (sBarrier != "") {
                object oBarrier = GetNearestObjectByTag(sBarrier, oTransition);
                SetPlotFlag(oBarrier, FALSE);
                DestroyObject(oBarrier);
            }
        } else{
            FloatingTextStringOnCreature("The way is blocked.", oClicker, FALSE);
            bJump = FALSE;
        }
    }

    string sMsg = "Transition - Key: %s, Check Spaws: %s, Clear: %s, Check Despawn: %s at %s, ";
    sMsg += "Hide: %s, Spawned Encounters: %s, Check Level: %s";

    Logger(oClicker, "DebugTransitions", LOGLEVEL_DEBUG, sMsg, sKey, IntToString(nCheckSpawn), IntToString(bClear), IntToString(nCheckDespawn),
            IntToString(nDespawnTime), IntToString(nTime), IntToString(nPercent), IntToString(nCheckLevel));

    return bJump;
   --]]
    return jump
end

function nw_g0_transition(trans)
   local pc = Ev.GetClickingObject()
   if not pc:GetIsValid() then 
      error("Invalid PC")
   end

   -- Don't allow plot NPC's to transition
   if not pc:GetIsPC() and pc:GetPlotFlag() then return end

   if not check_transition(trans, pc) then return end
   
   local cur_area = pc:GetArea()
   local target = trans:GetTransitionTarget()
   local tar_area = target:GetArea()
   local tag = target:GetTag()
   local instance_level = cur_area:GetLocalInt("instance_level")

   -- Set transition BMP
   if instance_level ~= 0 and tar_area:GetLocalInt("instance_level") ~= 0 then
      Inst.CreateInstance(trans, tar_area, instance_level)
      target = Inst.GetInstanceTarget(target, pc, instance_level)
   end

   pc:ActionJumpToObject(target)
end
