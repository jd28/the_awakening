int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oCrest1 = GetItemPossessedBy(oPC, "pl_drow_h1_token");
    object oCrest2 = GetItemPossessedBy(oPC, "pl_drow_h2_token");
    object oCrest3 = GetItemPossessedBy(oPC, "pl_drow_h3_token");
    object oCrest4 = GetItemPossessedBy(oPC, "pl_drow_h4_token");

    if(oCrest1 == OBJECT_INVALID ||
       oCrest2 == OBJECT_INVALID ||
       oCrest3 == OBJECT_INVALID ||
       oCrest4 == OBJECT_INVALID)
    {
        return FALSE;
    }

    return TRUE;
}
