int StartingConditional(){
    object oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int iQuestStatus = GetLocalInt(oPC,"NW_JOURNAL_ENTRY"+szPlotID);

    if (iQuestStatus == 4) return TRUE;

    return FALSE;
}
