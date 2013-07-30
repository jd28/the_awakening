#include "quest_func_inc"
void main(){

    object oMod = GetModule(), oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);

    //AddPersistentJournalQuestEntry(szPlotID, nQuestStatus+1, oPC, TRUE, FALSE, FALSE);
    AddPersistentJournalQuestEntry(szPlotID, 1, oPC, FALSE, FALSE, FALSE);
    SetLocalInt(oMod, "NW_JOURNAL_ENTRY" + szPlotID, 1);
}
