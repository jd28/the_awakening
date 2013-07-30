int StartingConditional()
{
    int iResult;

    object oWidget = GetLocalObject(OBJECT_SELF, "DM_SM_oWidget");
    int iCharsUsed = GetLocalInt(oWidget, "iCharsUsed");
    int iRemaining = (8157 - iCharsUsed) / 49;

    string sCapacity = "Approximately " + IntToString(iCharsUsed) + " of 8192 characters used.";
    sCapacity += "Approximately " + IntToString(iRemaining) + " more un-renamed/un-retagged objects may be stored.";

    SetCustomToken(11035, sCapacity);

    iResult = TRUE;
    return iResult;
}
