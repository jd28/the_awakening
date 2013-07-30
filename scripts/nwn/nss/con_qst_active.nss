///////////////////////////////////
//: dno_ta_ja1
//: Text Appears when Condition is Met.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
int StartingConditional(){
    object oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int iQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);

    if (iQuestStatus < 1) return FALSE;

    return TRUE;
}
