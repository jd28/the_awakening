local Log = System.GetLogger()
local Inst = require 'ta.instance'
local Color = require 'solstice.color'

local function check_transition(trans, pc, tar_area)
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
   Area: %s
   Key: %s
   Spawn: %s
   Despawn: %s
   Despawn Time: %d
   Environment: %s
   Level: %d]],
   tar_area:GetName(), key, tostring(spawn), tostring(despawn), despawn_time, tostring(env), level)

   if level > 0 and pc:GetHitDice() < level then
      pc:FloatingText(string.format("%sYou must be at least level %d to use this transition.%s",
                                    Color.RED, level, Color.END))
      return false
   end

--[[
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
   local pc = Game.GetClickingObject()
   if not pc:GetIsValid() then
      error("Invalid PC")
   end

   -- Don't allow plot NPC's to transition
   if not pc:GetIsPC() and pc:GetPlotFlag() then return end

   local target = trans:GetTransitionTarget()
   local tar_area = target:GetArea()
   if not check_transition(trans, pc, tar_area) then return end

   if tar_area:GetLocalInt("area_requires_haks") > 0
      and pc:GetPlayerInt("pc_enhanced") <= 1
   then
      pc:ErrorMessage "You do not have the required hak files to enter this area!"
      return
   end

   local cur_area = pc:GetArea()
   local tag = target:GetTag()

   pc:JumpSafeToObject(target)
end
