#include "quest_func_inc"
void main(){
    object oMod = GetModule(), oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");

    RemovePersistentJournalQuestEntry(szPlotID, oPC, TRUE, FALSE);
    SetLocalInt(oMod, "NW_JOURNAL_ENTRY" + szPlotID, 0);
}
