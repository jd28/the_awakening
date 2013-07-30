int StartingConditional()
{   object oWidget = GetLocalObject(OBJECT_SELF, "DM_SM_oWidget");
    int iCharsUsed = GetStringLength(GetDescription(oWidget, FALSE, FALSE));
    int iRemaining = (8192 - iCharsUsed) / 49;

    string sCapacity = IntToString(iCharsUsed) + " of 8192 characters used.";
    sCapacity += "Approximately " + IntToString(iRemaining) + " more un-renamed/un-retagged objects may be stored.";

    SetCustomToken(11035, sCapacity);
    SetLocalString(OBJECT_SELF, "sConvScript", "dm_sm_append");

    return TRUE;
}
