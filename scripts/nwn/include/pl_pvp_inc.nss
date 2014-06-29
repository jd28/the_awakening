// pl_pvp_inc

#include "mod_const_inc"
#include "pc_funcs_inc"
#include "area_inc"
#include "fky_chat_inc"

const int PVP_GAME_CTF = 1;

const int PVP_TEAM_1 = 1;//blue
const int PVP_TEAM_2 = 2;//red
const int PVP_TEAM_3 = 3;
const int PVP_TEAM_4 = 4;

const string sBlueChest = "pvp_chest_team1";
const string sRedChest = "pvp_chest_team2";
const string sBlueGoal = "pvp_goal_team1";
const string sRedGoal = "pvp_goal_team2";
const string sBlueFlag = "pl_blue_flag";
const string sRedFlag = "pl_red_flag";
const string sBlueBeam = "pvp_team1_beam";
const string sRedBeam = "pvp_team2_beam";

int PVPGetIsBattleGroundActive(object oArea);

void PVPReturnFlag(object oPC, int nTeam);

void PVPUpdateCaptures(object oPC);
void PVPUpdateDeaths(object oPC){}
void PVPUpdateKills(object oPC) {}
void PVPUpdateReturns(object oPC);
void PVPUpdateVictories(object oPC);
void PVPModRespawn(object oPC);
void PVPReturnToBattle(object oPC);

// EMPTY OUT THE ARTIFACT CHEST
void ClearChest(object oC) {
  object tO = GetFirstItemInInventory(oC);
  while (tO != OBJECT_INVALID) {
    SetPlotFlag(tO, FALSE);
    DestroyObject(tO);
    tO = GetNextItemInInventory(oC);
  }
}

int PVPGetIsOnTeam(object oPC, int nTeam);
int PVPGetIsOnTeam(object oPC, int nTeam){
    switch(nTeam){
        case PVP_TEAM_1: return GetItemPossessedBy(oPC, "pl_blue_team") != OBJECT_INVALID;
        case PVP_TEAM_2: return GetItemPossessedBy(oPC, "pl_red_team") != OBJECT_INVALID;
        //case PVP_TEAM_3: return "Gold Team";
        //case PVP_TEAM_4: return "Green Team";
    }
    return FALSE;
}

int PVPGetTeamNumber(object oPC);
int PVPGetTeamNumber(object oPC){
    if(GetItemPossessedBy(oPC, "pl_blue_team") != OBJECT_INVALID)
        return 1;
    else if(GetItemPossessedBy(oPC, "pl_red_team") != OBJECT_INVALID)
        return 2;

    return 0;
}
string PVPGetTeamName(int nTeam){
    switch(nTeam){
        case PVP_TEAM_1: return "Blue Team";
        case PVP_TEAM_2: return "Red Team";
        case PVP_TEAM_3: return "Gold Team";
        case PVP_TEAM_4: return "Green Team";
    }

    return "";
}

string PVPGetTeamColor(int nTeam){
    switch(nTeam){
        case PVP_TEAM_1: return C_BLUE;
        case PVP_TEAM_2: return C_RED;
        case PVP_TEAM_3: return C_GOLD;
        case PVP_TEAM_4: return C_GREEN;
    }
    return C_NONE;
}

void UpdatePVPStats(object oPC){
    // DB Structure : PlayerName | Kills | Deaths | Captures | Returns | Victories

}

void PVPAnnounce(string sMessage, object oPC);
void PVPAnnounce(string sMessage, object oPC){
    object oArea = GetArea(oPC);
    object oPlayer = GetFirstPC();
    while (oPlayer != OBJECT_INVALID){
        if(GetArea(oPlayer) == oArea){
            SendMessageToPC(oPlayer, C_RED+sMessage+C_END);
            SendChatLogMessage(oPlayer, C_RED+sMessage+C_END, oPC);
        }
        oPlayer = GetNextPC();
    }

    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
}

void PVPModDeath(object oPC, object oKiller);
void PVPModDeath(object oPC, object oKiller){
    object oFlag;
    int bDelete;

    if((oFlag = GetItemPossessedBy(oPC, sBlueFlag)) != OBJECT_INVALID){
        bDelete = TRUE;
    }
    else if((oFlag = GetItemPossessedBy(oPC, sRedFlag)) != OBJECT_INVALID)
        bDelete = TRUE;

    if(bDelete){
        CreateObject(OBJECT_TYPE_ITEM, GetResRef(oFlag), GetLocation(oPC));
        DestroyObject(oFlag, 0.5);
    }

    // Players must wait 30 seconds before returning to battle.
    SetLocalInt(oPC, "CTF_DELAY", GetLocalInt(GetModule(), "uptime") + 30);

    // Update Kills
    PVPUpdateKills(oKiller);
    // Update Deaths
    PVPUpdateDeaths(oPC);
    // Announce
    PVPAnnounce(GetName(oKiller)+" has slain "+GetName(oPC)+".", oPC);
    DelayCommand(0.5f, PVPModRespawn(oPC));

}

void PVPReturnToBattle(object oPC){
    int nTime = GetLocalInt(oPC, "CTF_DELAY") - GetLocalInt(GetModule(), "uptime");
    int nTeam = PVPGetTeamNumber(oPC);
    string sWay;
    if(nTime <= 0){
        switch(nTeam){
            case PVP_TEAM_1: sWay = "wp_" + GetTag(GetArea(oPC)) + "_start_1"; break;
            case PVP_TEAM_2: sWay = "wp_" + GetTag(GetArea(oPC)) + "_start_2"; break;
            default:
                ErrorMessage(oPC, "You don't have a team!");
                return;
        }
    }
    else{
        ErrorMessage(oPC, "You must wait " + IntToString(nTime) + " second(s) before returning to battle!");
        return;
    }

    Logger(oPC, "DepugPVP", LOGLEVEL_DEBUG, "nTime; %s, Team: %s, Waypoint: %s",
        IntToString(nTime), IntToString(nTeam), sWay);

    JumpSafeToWaypoint(sWay, oPC);
}

void PVPModLeave(object oPC);
void PVPModLeave(object oPC){
    int nSide = PVPGetTeamNumber(oPC);
    int nArea = GetLocalInt(GetModule(), "PVP_ACTIVE_AREA");

    // If no match active return;
    if(nArea == 0) return;

    // Not playing in the match.
    if(nSide == 0) return;

    // DECREASE SIDE'S COUNT
    int iCnt = GetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(nSide) );
    SetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(nSide), iCnt - 1);

    //Player logged out with flag.
    if(GetItemPossessedBy(oPC, "pvp_team1_flag") != OBJECT_INVALID){
        SetLocalInt(oPC, "PVP_LOGGED_WITH_FLAG", TRUE);
        // Announce it
        PVPAnnounce(GetName(oPC)+" has logged with the Red Flag.  Returning flag to Red Team.", oPC);
        //Return Flag
        PVPReturnFlag(oPC, 1);
    }
    else if(GetItemPossessedBy(oPC, "pvp_team2_flag") != OBJECT_INVALID){
        SetLocalInt(oPC, "PVP_LOGGED_WITH_FLAG", TRUE);
        // Announce it.
        PVPAnnounce(GetName(oPC)+" has logged with the Red Flag.  Returning flag to Red Team.", oPC);
        // Return it.
        PVPReturnFlag(oPC, 2);
    }

}

void PVPModRespawn(object oPC);
void PVPModRespawn(object oPC){

    // -------------------------------------------------------------------------
    // Resurrect & Heal The Player.
    // -------------------------------------------------------------------------
    Raise(oPC);

    // -------------------------------------------------------------------------
    // Port them to whatever respawn location they should go to.
    // -------------------------------------------------------------------------
    string sWaypoint;
    int nTeam = PVPGetTeamNumber(oPC);
    if(nTeam == 0) sWaypoint = "wp_blackwell_academy";
    else sWaypoint = "wp_"+GetTag(GetArea(oPC))+"_"+IntToString(nTeam);

    JumpSafeToWaypoint(sWaypoint, oPC);
}

void PVPPortToBattle();
void PVPPortToBattle(){
    object oModule = GetModule();
    int nGameType = GetLocalInt(oModule, "PVP_ACTIVE");
    int nMap = GetLocalInt(oModule, "PVP_ACTIVE_AREA");
    string sWaypoint;
    SetLocalInt(oModule, "PVP_ROUND_START", TRUE);

    if(nGameType == PVP_GAME_CTF){
        // Create Flags
        object oChest = GetObjectByTag("pvp_team1_chest_"+ IntToString(nMap));
        ClearChest(oChest);
        CreateItemOnObject("pvp_team1_flag", oChest, 1);
        oChest = GetObjectByTag("pvp_team2_chest_"+ IntToString(nMap));
        ClearChest(oChest);
        CreateItemOnObject("pvp_team2_flag", oChest, 1);
    }
    sWaypoint = "wp_arena_" + IntToString(nGameType)+"_" + IntToString(nMap)+"_"; // wp_arena_<Type>_<Map>_<Team>
    object oPC = GetFirstPC();
    while(oPC != OBJECT_INVALID){
        if(GetLocalInt(oPC, "PVP_SIDE")){
            JumpSafeToWaypoint(sWaypoint+IntToString(GetLocalInt(oPC, "PVP_SIDE")), oPC);
        }
    }
}

void PVPRemoveEffects(object oPC) {
    effect eff;

    // REMOVE INVISIBILITY AND HASTE EFFECTS
    SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
    eff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eff)) {
    if (GetEffectType(eff) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
        GetEffectType(eff) == EFFECT_TYPE_INVISIBILITY)
        RemoveEffect(oPC, eff);

    eff = GetNextEffect(oPC);
    }
}

void PVPReturnFlag(object oPC, int nTeam){
    string sFlagTag = "pvp_team"+IntToString(nTeam)+"_flag";
    object tObj = GetItemPossessedBy(oPC, sFlagTag);
    if (tObj == OBJECT_INVALID) return;

    string sChestTag = "pvp_chest_team"+IntToString(nTeam);

    SetPlotFlag(tObj, FALSE);
    DestroyObject(tObj);
    object oChest = GetNearestObjectByTag(sChestTag, oPC);
    if (GetIsObjectValid(oChest)) {
        ClearChest(oChest);
        CreateItemOnObject(sFlagTag, oChest, 1);
    }
}

void PVPEndRound(object oPC);
void PVPEndRound(object oPC){
    // RESET THE GAME VARIABLES
    SetLocalInt(GetModule(), "PVP_ROUND_START", FALSE);

    int iPVParea = GetLocalInt(GetModule(), "PVP_ACTIVE_AREA");
    string sTeam1Chest = "pvp_chest_team1";
    string sTeam2Chest = "pvp_chest_team2";
    object tObj, oObj;

    ClearChest(GetNearestObjectByTag(sTeam1Chest, oPC));
    ClearChest(GetNearestObjectByTag(sTeam2Chest, oPC));

    tObj = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(tObj)) {
        if (GetTag(GetArea(tObj)) == GetTag(GetArea(oPC))) {
            SendMessageToPC(tObj, "Your army is Victorious!");
            PVPUpdateVictories(oPC);
        }
        tObj = GetNextFactionMember(oPC, TRUE);
    }

    //Set Up Teleport Locations
    string sTeam1HomeWay = "wp_home_team1";
    string sTeam2HomeWay = "wp_home_team2";

    //Transport Everyone Out
    string sArea = "pvp_area_"+IntToString(iPVParea);
    tObj = GetFirstPC();
    while (tObj != OBJECT_INVALID) {
        if (GetTag(GetArea(tObj)) == sArea && !GetIsDM(tObj)) {
            AssignCommand(tObj, ClearAllActions(TRUE));
            //If Player is Dead, Ressurrect
            if (GetIsDead(tObj)) {
                ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),tObj);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(tObj)), tObj);
                PVPRemoveEffects(tObj);
            }

            //Destroy Artifacts
            oObj = GetItemPossessedBy(tObj, "pvp_team2_flag");
            if (GetIsObjectValid(oObj)) {
                SetPlotFlag(oObj, FALSE);
                DestroyObject(oObj);
            }
            oObj = GetItemPossessedBy(tObj, "pvp_team1_flag");
            if (GetIsObjectValid(oObj)) {
                SetPlotFlag(oObj, FALSE);
                DestroyObject(oObj);
            }

            if(GetLocalInt(tObj, "PVP_SIDE") == PVP_TEAM_1){
                JumpSafeToWaypoint(sTeam1HomeWay);
            }
            else if(GetLocalInt(tObj, "PVP_SIDE") == PVP_TEAM_2){
                JumpSafeToWaypoint(sTeam2HomeWay);
            }
            else{ // if no team send them to the academy.
                JumpSafeToWaypoint("wp_blackwell_academy");
            }
        }
        tObj = GetNextPC();
    }
}

void PVPRingGong(){

    object   oPC = GetLastUsedBy();
    object   tPC, tObj, oObj, oChest;
    int      iPVParea = GetLocalInt(GetModule(), "PVP_ACTIVE_AREA");
    string   sGongTag     = GetTag(OBJECT_SELF);
    int nRoundStarted = GetLocalInt(GetModule(), "PVP_ROUND_START");
    int      iPoints, i;

    if(!PVPGetIsBattleGroundActive(GetArea(oPC))){
        FloatingTextStringOnCreature("This Battleground is not Active. Please make your way to your Army's Exit Portal and leave.", oPC, FALSE);
        return;
    }

    int nEnemyTeam = GetLocalInt(OBJECT_SELF, "PVP_SIDE"); // gong
    int nMyTeam = PVPGetTeamNumber(oPC); // ringer

    if (nMyTeam == 0){
        FloatingTextStringOnCreature("You are not a member of the "+PVPGetTeamName((nEnemyTeam==1) ? 2 : 1 ), oPC, FALSE);
        // RETURN FLAG IF THE PC IS ON THE WRONG TEAM/NO TEAM
        PVPReturnFlag(oPC, nEnemyTeam);
        return;
    }

    // Make sure ringer isn't on gong's team.
    if(nMyTeam == nEnemyTeam){
        FloatingTextStringOnCreature("You are not able to ring your own gong.", oPC, FALSE);
        return;
    }

    string sEnemyFlagTag = "pvp_team"+IntToString(nEnemyTeam)+"_flag";
    string sMyFlagTag = "pvp_team"+IntToString(nMyTeam)+"_flag";
    string sEnemyChest = "pvp_chest_team"+IntToString(nEnemyTeam)+"_"  + IntToString(iPVParea);
    string sMyChest = "pvp_chest_team"+IntToString(nMyTeam)+"_"  + IntToString(iPVParea);


    AssignCommand(oPC, ClearAllActions(TRUE));

    if(sGongTag == "pvp_goal_team"+IntToString(nEnemyTeam)){
        if(!nRoundStarted) return;
        // CHECK IF THE PLAYER ACTUALLY HAS THE ENEMY'S FLAG
        if (GetItemPossessedBy(oPC, sEnemyFlagTag) == OBJECT_INVALID) {
            FloatingTextStringOnCreature("You do not have the Enemy's Artifact.", oPC, FALSE);
            return;
        }

        // CHECK IF THE my TEAM'S FLAG IS STILL IN THEIR CHEST
        oChest = GetObjectByTag(sMyChest);
        if (GetItemPossessedBy(oChest, sMyFlagTag) == OBJECT_INVALID) {
            FloatingTextStringOnCreature("Your army's Artifact MUST be in your army's Chest in order to turn in the Enemy's Artifact.", oPC, TRUE);
            return;
        }

        // TAKE FLAG - SCORE A POINT
        tObj = GetItemPossessedBy(oPC, sEnemyFlagTag);
        if (GetIsObjectValid(tObj)) {
            // DESTROY THE CARRIED FLAG
            SetPlotFlag(tObj, FALSE);
            DestroyObject(tObj);

            // Only one capture per Round...
            PVPAnnounce("The "+PVPGetTeamName(nMyTeam)+" Wins!", oPC);
            PVPUpdateCaptures(oPC);
            PVPEndRound(oPC);
        }
    }
}

void PVPUpdateCaptures(object oPC){
}

// Update PVP Table
void PVPUpdateReturns(object oPC){
}

void PVPUpdateVictories(object oPC){
}

//void main(){}


void PVPReturnFlag2(string steam1Chest, string sBlueFlag, object tObj = OBJECT_INVALID);
void PVPReturnFlag2(string steam1Chest, string sBlueFlag, object tObj = OBJECT_INVALID){
    if(tObj != OBJECT_INVALID){
        SetPlotFlag(tObj, FALSE);
        DestroyObject(tObj);
    }
    object oChest = GetNearestObjectByTag(steam1Chest);
    if (GetIsObjectValid(oChest)) {
        ClearChest(oChest);
        DelayCommand(1.0, ObjectToVoid(CreateItemOnObject(sBlueFlag, oChest, 1)));
    }
    else{
        SendMessageToAllDMs("Error Team Chest: " + steam1Chest + " is invalid.");
    }
}
