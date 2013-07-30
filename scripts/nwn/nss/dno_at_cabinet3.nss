void main()
{
    object oPC = GetLastOpenedBy();
    if (!GetIsPC(oPC)) return;

    if(GetLocalInt(OBJECT_SELF, GetName(oPC)))
        return;

    if (GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_rogue") == 2)
        CreateItemOnObject("dno_doc", OBJECT_SELF);

    SetLocalInt(OBJECT_SELF, GetName(oPC), TRUE);
}

