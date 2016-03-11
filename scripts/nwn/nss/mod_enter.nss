//::///////////////////////////////////////////////
//:: Default On Enter for Module
//:: x3_mod_def_enter
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script adds the horse menus to the PCs.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: Dec 30th, 2007
//:: Last Update: April 21th, 2008
//:://////////////////////////////////////////////

#include "fky_chat_inc"
#include "srv_funcs_inc"
#include "pc_funcs_inc"
#include "quest_func_inc"
#include "pl_pcstyle_inc"
#include "x0_i0_match"
#include "nwnx_redis"

// -----------------------------------------------------------------------------
//  PROTOTYPES - Loading
// -----------------------------------------------------------------------------
void LoadDM(object oPC);
void PCLoadPlayer(object oPC);
void PCUpdateVersion(object oPC){
}


// -----------------------------------------------------------------------------
//  PROTOTYPES - New Players
// -----------------------------------------------------------------------------
void GiveNewDMItems(object oPC);

void main(){
    object oPC = GetEnteringObject();
    // -------------------------------------------------------------------------
    // Create variables.
    // -------------------------------------------------------------------------
    SetLocalString(oPC, VAR_PC_PLAYER_NAME, GetPCPlayerName(oPC));
    SetLocalString(oPC, VAR_PC_IP_ADDRESS, GetPCIPAddress(oPC));
    SetLocalString(oPC, VAR_PC_CDKEY, GetPCPublicCDKey(oPC));
    SetLocalInt(oPC, VAR_PC_IS_PC, TRUE);


    LoadPersistentState(oPC);

    SetLocalInt(oPC, "NWNX_HELM_HIDDEN", StringToInt(GET("pc:helm:"+GetRedisID(oPC))));
// -----------------------------------------------------------------------------
// SIMTools Stuff
// -----------------------------------------------------------------------------
    string sCDKey = GetPCPublicCDKey(oPC);
    Speech_OnClientEnter(oPC);

    int nPerm = StringToInt(GET("ban:shout:"+sCDKey));
    int nPerm2 = StringToInt(GET("ban:player:"+sCDKey));

    if (nPerm) SetLocalInt(oPC, "FKY_CHT_BANSHOUT", TRUE);
    if (nPerm2 || GetLocalInt(oPC, "FKY_CHT_BANPLAYER")) BootPlayer(oPC);

    string sString = Logger(oPC, "DebugLogs", LOGLEVEL_NOTICE, "CLIENT ENTER : " +
        "Login: %s, Name: %s, CDKey: %s, IP Address: %s:%s", GetPCPlayerName(oPC),
        GetName(oPC), GetPCPublicCDKey(oPC), GetPCIPAddress(oPC), IntToString(GetPCPort(oPC)));

    SendMessageToAllDMs(sString);

// -----------------------------------------------------------------------------
// PC Section
// -----------------------------------------------------------------------------
    if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

    //DumpSpells(oPC);
	if(!GetHasEffect(EFFECT_TYPE_CUTSCENEGHOST, oPC)
	   && StringToInt(GET("block:"+GetRedisID(oPC)))) {
		ApplyEffectToObject(4, EffectCutsceneGhost(), oPC);
	}

    if(GetPCPlayerName(oPC) == "pope_leo"){
        SetLocalInt(oPC, "DebugLoot",        1);
        SetLocalInt(oPC, "DebugStyles",      1);
        SetLocalInt(oPC, "DebugEvents",      1);
        SetLocalInt(oPC, "DebugTransitions", 1);
        SetLocalInt(oPC, VAR_DEBUG_LOGS,     1);
        SetLocalInt(oPC, VAR_DEBUG_AREAS,    1);
        SetLocalInt(oPC, "DebugQuest",       1);
        SetLocalInt(oPC, "DebugSpecialAttks",1);
        SetLocalInt(oPC, "DebugSpells",      1);
    }

    if(GetHitDice(oPC) > 40 && !GetKnowsFeat(TA_FEAT_LEGENDARY_CHARACTER, oPC))
        AddKnownFeat(oPC, TA_FEAT_LEGENDARY_CHARACTER, 0);

    SetMovementRate (oPC, MOVEMENT_RATE_PC);

    //Load Players
    PCLoadPlayer(oPC);

}

// -----------------------------------------------------------------------------
//  FUNCTIONS - Loading move...
// -----------------------------------------------------------------------------
void PCLoadPlayer(object oPC){
    object oMod = GetModule();

    // Load Favored Enemies.
    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
        LoadFavoredEnemies(oPC);

    // -------------------------------------------------------------------------
    // Deal with first entry.
    // -------------------------------------------------------------------------
    if(!GetLocalInt(oPC, VAR_PC_ENTERED)){
        // -------------------------------------------------------------------------
        // Add Journal entries with various information about the server.
        // -------------------------------------------------------------------------
        AddJournalQuestEntry("srv_info",     1, oPC, FALSE, FALSE);

        PCUpdateVersion(oPC);

        if(GetFightingStyle(oPC) != STYLE_ASSASSIN_NINJA
            && GetPhenoType(oPC) == PHENOTYPE_NINJA
            && GetMeetsStyleRequirement(oPC, STYLE_ASSASSIN_NINJA))
        {
            SetFightingStyle(oPC, STYLE_ASSASSIN_NINJA);
        }


        if(GetTag(oPC) != ""){
            RebuildJournalQuestEntries(oPC);
        }

        int enhanced = GetPersistantInt(oPC, "pc:enhanced", TRUE);
        if(enhanced == 0){
            DelayCommand(15.0f, SendChatLogMessage(oPC, C_RED+"It is highly suggested that you go to the forums at theawakening1.freeforums.org and download " +
                "the server HAKs and TLK and use one of the !opt enhanced commands.  This is a small 3MB download.  You can play for awhile without it, " +
				"but leveling without it will likely negatively impact your character!  Please be aware!"+C_END, oPC, 4));
        }

        int hak_version = GetPersistantInt(oPC, "pc:hak_version");
		if ( hak_version < GetLocalInt(GetModule(), "HAK_VERSION") ) {
			DelayCommand(15.0f, SendChatLogMessage(oPC,
												   C_RED +
												   "Your HAK files are out of date!  Please run the updater to be sure you have access to all custom content!\n" +
												   "Then use !opt enhanced full.  If you have already done so you will not have to relog, but this will flag your account " +
												   "with the lasted HAK version!"
												   +C_END, oPC, 4));
		}


        int nHP = GetPersistantInt(oPC, "hp");
        if (nHP < 0){
            DeletePersistantVariable(oPC, "hp");
            DeletePersistantVariable(oPC, "loc");
            ErrorMessage(oPC, "Respawn Penalty: Logged dead.");
            ApplyRespawnPenalty(oPC);
        }

    }
    else{ // << Player has entered at least once since last reset.
        if(GetLocalInt(oPC, VAR_PC_DELETED)){
            SendMessageToPC(oPC, "You must wait one reset before using a character with the same name as one you've deleted!");
            DelayCommand(4.0, BootPlayer(oPC));
            return;
        }
        /* verify CD keys and double logins to stop hackers */
        if (VerifyPlayernameAgainstCDKey(oPC)) {
            SendMessageToPC(oPC, "Your CDKEY does not match the one(s) used to secure this account!  If there has been a mistake please go to theawakening1.freeforums.org and send us a message.");
            DelayCommand(5.0, BootPlayer(oPC));
            return;
        }

		NWNXSolstice_UpdateCombatInfo(oPC);

        if(!GetKnowsFeat(FEAT_PLAYER_TOOL_01, oPC))
            AddKnownFeat(oPC, FEAT_PLAYER_TOOL_01);

        int nHP = StringToInt(GET("hp:"+GetRedisID(oPC)));
        if (nHP <= 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oPC);
        else
            SetCurrentHitPoints(oPC, nHP);

    }

    Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Player: %s, Name: %s, XP Bank: %s",
        GetPCPlayerName(oPC), GetName(oPC), IntToString(GetLocalInt(oPC, VAR_PC_XP_BANK)));

	ExecuteScript("ta_load_kills", oPC);
}

void LoadDM(object oPC){

    if(!GetIsObjectValid(GetItemPossessedBy(oPC, "dmpcwand"))){
        GiveNewDMItems(oPC);
    }
    // -------------------------------------------------------------------------
    // Add journal entry with some DM info.
    // -------------------------------------------------------------------------
    //AddJournalQuestEntry("dmrules", 1, oPC, FALSE, FALSE);

}

// -----------------------------------------------------------------------------
//  Functions - New Players
// -----------------------------------------------------------------------------

void GiveNewDMItems(object oPC){
    CreateItemOnObject("dmpcwand", oPC, 1);
    //CreateItemOnObject("dmtoolz", oPC, 1);
    //CreateItemOnObject("dmtoolz", oPC, 1);
    //CreateItemOnObject("dmtoolz", oPC, 1);
    //CreateItemOnObject("dmtoolz", oPC, 1);

    ExportSingleCharacter(oPC);
    //This message is here for a reason!
    DelayCommand(10.0, SendMessageToPC(oPC,
    "<cттт>You have been given DM Items and your DM Character was saved," +
    "<cттт> please login with the updated version of your DM Character and" +
    "<cттт> delete the original, thank you."));
}
