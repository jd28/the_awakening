//:://////////////////////////////////////////////
//:: Created By: Knat
//:: Created On: 19.06.2003
//:://////////////////////////////////////////////

#include "nw_i0_plot"
#include "pc_funcs_inc"

void QuestAcquire(object oPC, object oItem);
int QuestHasReqs(object oQuestGiver, object oPC);
void QuestLevelUp(object oPC) {}
void QuestTakeReqs(object oQuestGiver, object oPC);
void QuestGiveRewards(object oQuestGiver, object oPC, int bParty = FALSE);
void QuestAdvance(object oQuestGiver, object oPC, int nStatus = -1);

void SpawnDeltaKey();


// transparent wrapper to AddJournalQuestEntry
// use this function instead of the original one to store quest/journal data
// persistently using the bio DB. all function parameters work similar to the original function
//
// Add a journal quest entry to oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - nState: the state of the plot as seen in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will show up in the journal of
//   everyone in the party
// - bAllPlayers: If this is TRUE, the entry will show up in the journal of
//   everyone in the world
// - bAllowOverrideHigher: If this is TRUE, you can set the state to a lower
//   number than the one it is currently on
void AddPersistentJournalQuestEntry(string szPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE);

// transparent wrapper to RemoveJournalQuestEntry()
// use this function instead of the original one to remove quest/journal data
// persistently using the bio DB. all function parameters work similar to the original function
//
// Remove a journal quest entry from oCreature.
// - szPlotID: the plot identifier used in the toolset's Journal Editor
// - oCreature
// - bAllPartyMembers: If this is TRUE, the entry will be removed from the
//   journal of everyone in the party
// - bAllPlayers: If this is TRUE, the entry will be removed from the journal of
//   everyone in the world
void RemovePersistentJournalQuestEntry(string szPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE);

// use this function to rebuild the journal on oCreature using the bio DB
// a good place is the Module OnClientEnter() event
void RebuildJournalQuestEntries(object oCreature);

// retrieve persistent quest state from the DB
// - szPlotID: the plot identifier used in the toolset's Journal Editor
int RetrieveQuestState(string szPlotID, object oCreature);

// -----------------------------------------------------------------------------

void RebuildJournalQuestEntries(object oCreature){
    string sQuest, sMessage = "Attempting to rebuild quests:\n";
    int nStatus;
    if(GetIsPC(oCreature)){
        string sSQLName = GetTag(oCreature);
        string sSQLDB = "SELECT name, val FROM qsstatus WHERE tag = '"+sSQLName+"'";
        SQLExecDirect(sSQLDB);
        while(SQLFetch() != SQL_ERROR){
            sQuest = SQLDecodeSpecialChars(SQLGetData(1));
            nStatus = StringToInt(SQLDecodeSpecialChars(SQLGetData(2)));
            sMessage += "Quest: " + sQuest + ", Status: " + IntToString(nStatus) + "\n";

            AddJournalQuestEntry(sQuest, nStatus, oCreature, FALSE, FALSE, TRUE);

            //SetLocalInt(oPC, SQLDecodeSpecialChars(SQLGetData(1)), StringToInt(SQLDecodeSpecialChars(SQLGetData(2))));
        }

        Logger(oCreature, "DebugQuest", LOGLEVEL_NONE, C_WHITE+sMessage+C_END);

    /*
    string sEntries = GetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,oCreature);
    int i, nCount = GetStringLength(sEntries) / 44;

    string sQuest;
    for(i=0;i < nCount;i++)
    {
      // get quest
      sQuest = GetSubString(sEntries,(i*44),32);
      // remove padding
      sQuest = GetStringLeft(sQuest, FindSubString(sQuest, " "));
      // add journal entry
      AddJournalQuestEntry(sQuest, StringToInt(GetSubString(sEntries,(i*44) + 33,8)), oCreature, FALSE, FALSE, TRUE);
    }
    */
  }
}

int RetrieveQuestState(string szPlotID, object oCreature){

    return GetDbInt(oCreature, szPlotID, FALSE, "qsstatus");
/*
  // retrieve all quest entries
  string sEntries = GetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,oCreature);
  // get quest we search for and add padding
  string sQuest = (GetStringLength(szPlotID) < 32) ? szPlotID + GetStringLeft("                              ",32 - GetStringLength(szPlotID)) : GetStringLeft(szPlotID,32);

  // find target quest
  int nPos = FindSubString(sEntries, sQuest + ">");

  if( nPos != -1) // success ?? get & return value
    return StringToInt(GetStringLeft(GetStringRight(sEntries,GetStringLength(sEntries)-nPos-GetStringLength(sQuest)-1),10));

  // quest not started yet
  return 0;
*/
}

void StoreQuestEntry(string szPlotID, int nState, object oCreature, int bAllowOverrideHigher=FALSE){

    int nCurrentState = GetDbInt(oCreature, szPlotID, FALSE, "qsstatus");

    if(!bAllowOverrideHigher && (nCurrentState > nState))
        return;

    SetDbInt(oCreature, szPlotID, nState, 0, FALSE, "qsstatus");
/*
  // retrieve all quest entries
  string sEntries = GetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,oCreature);

  // pad quest
  string sQuest = (GetStringLength(szPlotID) < 32) ? szPlotID + GetStringLeft("                              ",32 - GetStringLength(szPlotID)) : GetStringLeft(szPlotID,32);
  // pad state
  string sState = IntToString(nState);
  sState = (GetStringLength(sState) < 10) ? sState + GetStringLeft("          ",10 - GetStringLength(sState)) : GetStringLeft(sState,10);

  // find target quest
  int nPos = FindSubString(sEntries, sQuest + ">");

  if( nPos != -1) // success ?
  {

    // check for override flag
    if(!bAllowOverrideHigher) // new state < old state ? return
      if(nState < StringToInt(GetStringRight(sEntries,GetStringLength(sEntries)-nPos-GetStringLength(sQuest)-1)))
        return;

    // replace old quest state with new one
    string sL = GetStringLeft(sEntries, nPos + GetStringLength(sQuest) + 1);
    sEntries = sL + sState + GetStringRight(sEntries, GetStringLength(sEntries) - GetStringLength(sL) - 10);
  }
  else // add quest
    sEntries += sQuest + ">" + sState + "|";

  // store quest entries
  SetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,sEntries,oCreature);
*/
}

void DeleteQuestEntry(string szPlotID, object oCreature){

    DeleteDbVariable(oCreature, szPlotID, FALSE, "qsstatus");
/*
  // retrieve all quest entries
  string sEntries = GetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,oCreature);
  // pad quest
  string sQuest = (GetStringLength(szPlotID) < 32) ? szPlotID + GetStringLeft("                              ",32 - GetStringLength(szPlotID)) : GetStringLeft(szPlotID,32);
  // find target quest
  int nPos = FindSubString(sEntries, sQuest + ">");

  if( nPos != -1) // success ?
  {

    // replace old quest state with new one
    string sL = GetStringLeft(sEntries, nPos);
    sEntries = sL + GetStringRight(sEntries, GetStringLength(sEntries) - GetStringLength(sL) - 44);

    // store quest entries
    SetCampaignString(PQJ_DATABASE,PQJ_PLAYER_VARNAME,sEntries,oCreature);
  }
*/
}

void RemovePersistentJournalQuestEntry(string szPlotID, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE){

    RemoveJournalQuestEntry(szPlotID, oCreature, bAllPartyMembers, bAllPlayers);

    object oHolder;

    if(bAllPlayers){
        oHolder = GetFirstPC();
        while(GetIsObjectValid(oHolder)){
            if(GetIsPC(oHolder))
                DeleteQuestEntry(szPlotID, oHolder);

            oHolder = GetNextPC();
        }
    }
    else if(bAllPartyMembers){
        oHolder = GetFirstFactionMember(oCreature, TRUE);
        while (GetIsObjectValid(oHolder)){
            DeleteQuestEntry(szPlotID, oHolder);
            oHolder = GetNextFactionMember(oCreature, TRUE);
        }
    }else{
        DeleteQuestEntry(szPlotID, oCreature);
    }
}

void AddPersistentJournalQuestEntry(string szPlotID, int nState, object oCreature, int bAllPartyMembers=TRUE, int bAllPlayers=FALSE, int bAllowOverrideHigher=FALSE){
    AddJournalQuestEntry(szPlotID, nState, oCreature, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher);
    object oHolder;

    if(bAllPlayers){
        oHolder = GetFirstPC();
        while(GetIsObjectValid(oHolder)){
            if(GetIsPC(oHolder))
                StoreQuestEntry(szPlotID, nState, oHolder, bAllowOverrideHigher);

            oHolder = GetNextPC();
        }
    }
    else if(bAllPartyMembers){
        oHolder = GetFirstFactionMember(oCreature, TRUE);
        while (GetIsObjectValid(oHolder)){
            StoreQuestEntry(szPlotID, nState, oHolder, bAllowOverrideHigher);
            oHolder = GetNextFactionMember(oCreature, TRUE);
        }
    }else{
        StoreQuestEntry(szPlotID, nState, oCreature, bAllowOverrideHigher);
    }
}

int QuestHasReqs(object oQuestGiver, object oPC){

    string szPlotID = GetLocalString(oQuestGiver, "quest");  // Quest Identifier
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);
    string sItem, sItemVar;
    int nGold = GetLocalInt(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_gp");
    int nCount = 1;

    //AssignCommand(oPC, SpeakString(IntToString(nQuestStatus)));

    if(GetGold(oPC) < nGold) return FALSE;

    sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_" + IntToString(nCount));

    while(sItem != ""){
        //AssignCommand(oPC, SpeakString(sItem));

        if(!HasItem(oPC, sItem)) return FALSE;
        nCount++;
        sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_" + IntToString(nCount));
    }

    return TRUE;
}

void QuestTakeReqs(object oQuestGiver, object oPC){
    string szPlotID = GetLocalString(oQuestGiver, "quest");  // Quest Identifier
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);
    string sItem, sItemVar;
    int nGold = GetLocalInt(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_gp");
    int nCount = 1;

    //AssignCommand(oPC, SpeakString(IntToString(nQuestStatus)));

    if(nGold > 0) TakeGoldFromCreature(nGold, oPC, TRUE);

    sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_" + IntToString(nCount));

    while(sItem != ""){
        //AssignCommand(oPC, SpeakString(sItem));

        DestroyObject(GetItemPossessedBy(oPC, sItem), 0.1f);
        nCount++;
        sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_req_" + IntToString(nCount));
    }
}

void QuestGiveRewards(object oQuestGiver, object oPC, int bParty = FALSE){
    string szPlotID = GetLocalString(oQuestGiver, "quest");  // Quest Identifier
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);
    int nGold = GetLocalInt(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_reward_gp");
    int nXP = GetLocalInt(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_reward_xp");
    string sItem, sItemVar;
    int nItemNum, nCount = 1;

    //AssignCommand(oPC, SpeakString(IntToString(nQuestStatus)));

    if(nGold > 0) GiveTakeGold(oPC, nGold, bParty);
    if(nXP > 0) GiveTakeXP(oPC, nXP, TRUE, bParty);

    sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_reward_" + IntToString(nCount));

    while(sItem != ""){
        //AssignCommand(oPC, SpeakString(sItem));

        nItemNum = GetLocalInt(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_reward_" + IntToString(nCount));
        if(nItemNum <= 0) nItemNum = 1;

        //AssignCommand(oPC, SpeakString(sItem));

        CreateItemOnObject(sItem, oPC, nItemNum);
        nCount++;
        sItem = GetLocalString(oQuestGiver, "quest_" + IntToString(nQuestStatus) + "_reward_" + IntToString(nCount));
    }
}

void SpawnDeltaKey(){
    object oStones, oWaypoint;
    location lWaypoint;
    string sWaypoint = "WP_";

    // Check to see if key stones already exist, if so just return.
    if(GetLocalInt(GetModule(), "pl_delta_key")) return;
    // Set quest active so it can't be Spammed
    SetLocalInt(GetModule(), "pl_delta_key", 1);

    // Get which map where the key will be placed.
    switch(d4()){
        case 1: sWaypoint += "TDNE_OLKEY_"; break;
        case 2: sWaypoint += "TDW_OLKEY_"; break;
        case 3: sWaypoint += "TDC_OLKEY_"; break;
        case 4: sWaypoint += "TDE_OLKEY_"; break;
    }

    // Get which waypoint.
    sWaypoint += IntToString(d6());

    //sWaypoint = "WP_TDE_OLKEY_1";

    WriteTimestampedLogEntry("QUEST : Old Man's Key spawned at " + sWaypoint);

    oWaypoint = GetWaypointByTag(sWaypoint);
    lWaypoint = GetLocation(oWaypoint);

    oStones = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_delta_stones", lWaypoint);
    SetLocalInt(oStones, "Right", 1);


}

//void QuestAdvance(object oQuestGiver, object oPC, int nStatus = -1);
void QuestAdvance(object oQuestGiver, object oPC, int nStatus = -1){
    object oMod = GetModule();
    string szPlotID = GetLocalString(oQuestGiver, "quest");
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);
    if(nStatus == -1) nStatus = nQuestStatus + 1;

    //AddPersistentJournalQuestEntry(szPlotID, nQuestStatus+1, oPC, TRUE, FALSE, FALSE);
    AddPersistentJournalQuestEntry(szPlotID, nStatus, oPC, FALSE, FALSE, FALSE);
    SetLocalInt(oMod, "NW_JOURNAL_ENTRY" + szPlotID, nStatus);
}

int QuestDestroyItem(object oPC, string sTag);
int QuestDestroyItem(object oPC, string sTag){
    object oItem = GetItemPossessedBy(oPC, sTag);
    if(oItem == OBJECT_INVALID)
        return FALSE;

    DestroyObject(oItem);
    return TRUE;
}
