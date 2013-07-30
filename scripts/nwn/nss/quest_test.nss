void main()
{
    object oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int iQuestStatus = GetLocalInt(oPC,"NW_JOURNAL_ENTRY"+szPlotID);

    AssignCommand(oPC, SpeakString(IntToString(iQuestStatus)));
}
