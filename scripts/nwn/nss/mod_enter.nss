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
#include "sha_subr_methds"
#include "msg_func_inc"
#include "pl_pcstyle_inc"

// -----------------------------------------------------------------------------
//  PROTOTYPES - Loading
// -----------------------------------------------------------------------------
void LoadDM(object oPC);
void PCLoadPlayer(object oPC);
void PCUpdateVersion(object oPC){
    int nVersion = GetPlayerInt(oPC, "pc_version");

    switch(nVersion){
        case 0:
            SetAge(oPC, 0);
            SetPlayerInt(oPC, "pc_version", TA_CURRENT_PC_VERSION);
    }
}


// -----------------------------------------------------------------------------
//  PROTOTYPES - New Players
// -----------------------------------------------------------------------------
void GiveNewDMItems(object oPC);

void main(){

    object oPC = GetEnteringObject();

    GetPlayerInt(oPC, "NWNX_HELM_HIDDEN");
// -----------------------------------------------------------------------------
// SIMTools Stuff
// -----------------------------------------------------------------------------
    string sCDKey = GetPCPublicCDKey(oPC);
    Speech_OnClientEnter(oPC);

    int nPerm = GetDbInt(GetModule(), "FKY_CHT_BANSHOUT" + sCDKey);
    int nPerm2 = GetDbInt(GetModule(), "FKY_CHT_BANPLAYER" + sCDKey);

    if (nPerm) SetLocalInt(oPC, "FKY_CHT_BANSHOUT", TRUE);
    if (nPerm2 || GetLocalInt(oPC, "FKY_CHT_BANPLAYER")) BootPlayer(oPC);//Boot them if Valid Object
    else if (SRV_SERVERVAULT != "")
    {
        string Script = GetLocalString(oPC, "LetoScript");
        if( Script != "" ) SetLocalString(oPC, "LetoScript", "");
    }


    string sString = Logger(oPC, "DebugLogs", LOGLEVEL_NOTICE, "CLIENT ENTER : " +
        "Login: %s, Name: %s, CDKey: %s, IP Address: %s:%s", GetPCPlayerName(oPC),
        GetName(oPC), GetPCPublicCDKey(oPC), GetPCIPAddress(oPC), IntToString(GetPCPort(oPC)));

    SendMessageToAllDMs(sString);

// -----------------------------------------------------------------------------
// PC Section
// -----------------------------------------------------------------------------
    if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

    //DumpSpells(oPC);

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

    if(GetLootable(oPC) > 40 && !GetKnowsFeat(TA_FEAT_LEGENDARY_CHARACTER, oPC))
        AddKnownFeat(oPC, TA_FEAT_LEGENDARY_CHARACTER, 0);

    SetMovementRate (oPC, MOVEMENT_RATE_PC);

    //Load Players
    PCLoadPlayer(oPC);

}

// -----------------------------------------------------------------------------
//  FUNCTIONS - Loading move...
// -----------------------------------------------------------------------------
void PCLoadPlayer(object oPC){
    object oSkin, oMod = GetModule();
    string sUID = GetTag(oPC);

    // -------------------------------------------------------------------------
    // Create variables.
    // -------------------------------------------------------------------------
    SetLocalString(oPC, VAR_PC_PLAYER_NAME, GetPCPlayerName(oPC));
    SetLocalString(oPC, VAR_PC_IP_ADDRESS, GetPCIPAddress(oPC));
    SetLocalString(oPC, VAR_PC_CDKEY, GetPCPublicCDKey(oPC));
    SetLocalInt(oPC, VAR_PC_IS_PC, TRUE);

    // Load Favored Enemies.
    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
        LoadFavoredEnemies(oPC);

    // -------------------------------------------------------------------------
    // Deal with first entry.
    // -------------------------------------------------------------------------
    if(!GetLocalInt(oPC, VAR_PC_ENTERED)){
        PCUpdateVersion(oPC);

        if(GetFightingStyle(oPC) != STYLE_ASSASSIN_NINJA
            && GetPhenoType(oPC) == PHENOTYPE_NINJA
            && GetMeetsStyleRequirement(oPC, STYLE_ASSASSIN_NINJA))
        {
            SetFightingStyle(oPC, STYLE_ASSASSIN_NINJA);
        }

        // -------------------------------------------------------------------------
        // Add Journal entries with various information about the server.
        // -------------------------------------------------------------------------
        AddJournalQuestEntry("srv_info",     1, oPC, FALSE, FALSE);

        if(GetTag(oPC) != ""){
            RebuildJournalQuestEntries(oPC);
            DeliverMail(oPC);
        }

        if(!GetPlayerInt(oPC, "pc_enhanced", TRUE)){
            DelayCommand(15.0f, SendChatLogMessage(oPC, C_RED+"It is highly suggested that you go to the forums at theawakening1.freeforums.org and download " +
                "the server HAKs and TLK and use one of the !opt enhanced commands.  This is a small 3MB download.  Without it, you will see some " +
                "missing things and might have difficulty leveling your character.  However, it shouldn't " +
                "stop you from getting some sense of the server or playing for some time."+C_END, oPC, 4));
        }

        int nHP = GetDbInt(oPC, VAR_PC_HP);
        if (nHP < 0){
            DeleteDbVariable(oPC, VAR_PC_HP);
            DeleteDbVariable(oPC, VAR_PC_SAVED_LOCATION);
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


        if(!GetKnowsFeat(FEAT_PLAYER_TOOL_01, oPC))
            AddKnownFeat(oPC, FEAT_PLAYER_TOOL_01);

        int nHP = GetDbInt(oPC, VAR_PC_HP);
        if (nHP <= 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oPC);
        else
            SetCurrentHitPoints(oPC, nHP);

        //SSE
        SubraceOnClientEnter(oPC);
    }

    //XP Banked
    int nXP = GetDbInt(oPC, VAR_PC_XP_BANK, TRUE);
    SetLocalInt(oPC, VAR_PC_XP_BANK, nXP);
    Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Player: %s, Name: %s, XP Bank: %s",
        GetPCPlayerName(oPC), GetName(oPC), IntToString(nXP));
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
