int StartingConditional(){
    object oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest2");
    int iQuestStatus = GetLocalInt(oPC,"NW_JOURNAL_ENTRY"+szPlotID);

    if (iQuestStatus == 2) return TRUE;

    return FALSE;
}
