//::///////////////////////////////////////////////
//:: Title : Portal, onUse Event
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

//      Tag Format: pvp_cmd_side
//         Example: pvp_home_red  = Red Team's Home Portal (that teleports out to the PVP areas)
//                  pvp_exit_red  = Red Team's Exit Portal
//
//     Area Format: pvp_area_#
//         Example: pvp_area_1
//
// Waypoint Format: wp_respawn_side_#
//         Example: wp_respawn_RED_1
//                  wp_start_side_#
//                  wp_start_RED_1


int iRedLevels  = 0;
int iBlueLevels = 0;
int iPVParea    = GetLocalInt(GetModule(), "PVP_ACTIVE_AREA");


// CREATE A VISUAL EFFECT AROUND THE PERSON BEING TELEPORTED
void ApplyTeleportEffect(object oTarget) {
  location lLoc = GetLocation(oTarget);
  effect   eff  = EffectVisualEffect(VFX_IMP_TORNADO);

  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eff, lLoc, 0.75);
}


// EMPTY OUT THE ARTIFACT CHEST
void ClearChest(object oC) {
  object tO = GetFirstItemInInventory(oC);
  while (tO != OBJECT_INVALID) {
    SetPlotFlag(tO, FALSE);
    DestroyObject(tO);
    tO = GetNextItemInInventory(oC);
  }
}


// DETERMINE THE TOTAL NUMBER OF LEVELS ON EACH SIDE
// IF ADDING THE TELEPORTING PLAYER ONTO A SIDE OFFSETS
// THE GAME BALANCE, DO NOT ALLOW THE CHARACTER TO TELEPORT IN
int DetermineSideLevels(object oPC) {
  object oObj         = GetFirstPC();
  int    iAllow       = FALSE;
  int    iAvgLevel    = 0;
  int    iLeeway      = 1;  // Changing this allows more Leeway in allowing others to join.
  int    i            = 0;
  iRedLevels          = 0;
  iBlueLevels         = 0;


  // CALCULATE BOTH SIDE'S LEVEL (FOR PC'S THAT ARE IN THE WARZONE ONLY)
  while (oObj != OBJECT_INVALID) {
    if (!GetIsDM(oObj)) {
      iAvgLevel = iAvgLevel + GetHitDice(oObj);
      i++;
    }
    if (GetTag(GetArea(oObj)) == "pvp_area_" + IntToString(iPVParea)) {
      if (GetLocalString(oObj, "PVP_SIDE") == "red")
        iRedLevels = iRedLevels + GetHitDice(oObj);
      if (GetLocalString(oObj, "PVP_SIDE") == "blue")
        iBlueLevels = iBlueLevels + GetHitDice(oObj);
    }
    oObj = GetNextPC();
  }

  // CALCULATE THE AVERAGE LEVEL OF THE GAME
  // THIS IS USED TO MAKE SURE THAT THE JOINING PLAYER DOES NOT OFFSET SIDES
  if (i > 0)
    iAvgLevel = (iAvgLevel / i) + iLeeway;

  // CHECK TO SEE IF THE CHARACTER CAN ENTER THE FIELD - BLUE
  if (GetLocalString(oPC, "PVP_SIDE") == "blue") {
    // IF NO ONE FROM THIS TEAM IS IN FIELD, ALLOW IN
    if (iBlueLevels == 0 || iRedLevels == 0)
      return TRUE;
    // CHECK THAT THE CHARACTER ISN'T TOO HIGH A LEVEL TO OFFSET THE BALANCE
    if (iBlueLevels + GetHitDice(oPC) > iRedLevels + iAvgLevel) {
      FloatingTextStringOnCreature("You cannot enter the Warzone just yet. You are too high a level.", oPC, FALSE);
      FloatingTextStringOnCreature("Please wait for more people to join the enemy's forces.", oPC, FALSE);
      return FALSE;
    }
    // ALLOW THEM IN
    iAllow = TRUE;
  }

  // CHECK TO SEE IF THE CHARACTER CAN ENTER THE FIELD - RED
  if (GetLocalString(oPC, "PVP_SIDE") == "red") {
    // IF NO ONE FROM THIS TEAM IS IN FIELD, ALLOW IN
    if (iBlueLevels == 0 || iRedLevels == 0)
      return TRUE;
    // CHECK THAT THE CHARACTER ISN'T TOO HIGH A LEVEL TO OFFSET THE BALANCE
    if (iRedLevels + GetHitDice(oPC) > iBlueLevels + iAvgLevel) {
      FloatingTextStringOnCreature("You cannot enter the Warzone just yet. You are too high a level.", oPC, FALSE);
      FloatingTextStringOnCreature("Please wait for more people to join the enemy's forces.", oPC, FALSE);
      return FALSE;
    }
    // ALLOW THEM IN
    iAllow = TRUE;
  }

  return iAllow;
}


void main() {
  object oPC          = GetLastUsedBy();
  string sPCside      = GetLocalString(oPC, "PVP_SIDE");
  string sTag         = GetTag(OBJECT_SELF);
  string sSide        = GetStringRight(sTag, GetStringLength(sTag)-9);
  string sCmd         = GetStringLeft(sTag, GetStringLength(sTag) - (GetStringLength(sSide) + 1));
         sCmd         = GetStringRight(sCmd, GetStringLength(sCmd) - 4);
  object oAnnounce    = GetObjectByTag("WP_ANNOUNCE_" + IntToString(iPVParea));
  int    iGameStarted = GetLocalInt(oAnnounce, "GAME_START");
  object oTarget;
  string sTarget;

  if (oAnnounce == OBJECT_INVALID)
    oAnnounce = GetModule();


  // MAKE SURE THE PC IS AFFILIATED WITH A SIDE
  // IF NOT, TELEPORT THEM TO THE START SO THEY CAN CHOOSE A SIDE
  if (sPCside != "red" && sPCside != "blue") {
    location lLoc = GetStartingLocation();
    ApplyTeleportEffect(oPC);
    AssignCommand(oPC, ActionJumpToLocation(lLoc));
    DelayCommand(5.0, ApplyTeleportEffect(oPC));
    return;
  }

  // MAKE SURE THAT THE AREA IS AVAILABLE
  if (GetObjectByTag("pvp_area_"+IntToString(iPVParea)) == OBJECT_INVALID)
    iPVParea = 1;

  // HOME PORTAL - TELEPORT PC OUT TO THE ACTIVE PVP AREA
  if (sCmd == "home" && DetermineSideLevels(oPC)) {
    if (iGameStarted) {
      sTarget = "wp_start_" + sSide + "_" + IntToString(iPVParea);
      oTarget = GetObjectByTag(sTarget);
      if (oTarget != OBJECT_INVALID) {
        ApplyTeleportEffect(oPC);
        AssignCommand(oPC, ActionJumpToObject(oTarget));
        DelayCommand(5.0, ApplyTeleportEffect(oTarget));
      } else
        FloatingTextStringOnCreature("Error: Could not find " + sTarget, oPC, FALSE);
    } else {
      FloatingTextStringOnCreature("Both Armies are not ready to being yet. When both Armies signal that they are ready, you may enter.", oPC, FALSE);
    }
    return;
  }

  // PVP EXIT AREA PORTAL - TELEPORT PC BACK TO HOME AREA
  if (sCmd == "exit") {
    if (sSide == sPCside) {

      // REMOVE ANY FLAGS PC IS CARRYING
      oTarget = GetItemPossessedBy(oPC, "pvp_blue_flag");
      if (oTarget != OBJECT_INVALID) {
        SetPlotFlag(oTarget, FALSE);
        DestroyObject(oTarget);
        oTarget = GetObjectByTag("pvp_chest_blue_" + IntToString(iPVParea));
        if (GetIsObjectValid(oTarget)) {
          ClearChest(oTarget);
          CreateItemOnObject("pvp_blue_flag", oTarget, 1);
        }
        AssignCommand(oAnnounce, ActionSpeakString(GetName(oPC) + " has left the area.  Artifact returned.", TALKVOLUME_SHOUT));
      }
      oTarget = GetItemPossessedBy(oPC, "pvp_red_flag");
      if (oTarget != OBJECT_INVALID) {
        SetPlotFlag(oTarget, FALSE);
        DestroyObject(oTarget);
        oTarget = GetObjectByTag("pvp_chest_red_" + IntToString(iPVParea));
        if (GetIsObjectValid(oTarget)) {
          ClearChest(oTarget);
          CreateItemOnObject("pvp_red_flag", oTarget, 1);
        }
        AssignCommand(oAnnounce, ActionSpeakString(GetName(oPC) + " has left the area.  Artifact returned.", TALKVOLUME_SHOUT));
      }

      // ASSIGN HOME LOCATION
      sTarget = "wp_home_" + sPCside;
      oTarget = GetObjectByTag(sTarget);
      if (oTarget != OBJECT_INVALID) {
        ApplyTeleportEffect(oPC);
        AssignCommand(oPC, ActionJumpToObject(oTarget));
        DelayCommand(5.0, ApplyTeleportEffect(oTarget));
      } else
        FloatingTextStringOnCreature("Error: Could not find " + sTarget, oPC, FALSE);
      return;
    } else {
      FloatingTextStringOnCreature("You cannot use this Portal.", oPC, FALSE);
    }
  }




}

