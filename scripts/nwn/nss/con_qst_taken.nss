int StartingConditional(){
    object oMod = GetModule(), oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int iQuestStatusMod = GetLocalInt(oMod, "NW_JOURNAL_ENTRY" + szPlotID);
    int iQuestStatusPC = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);

    if ((iQuestStatusMod >= 1) && (iQuestStatusPC < 1)){
        return TRUE;
    }
    else return FALSE;
}
