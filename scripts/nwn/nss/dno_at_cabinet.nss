void main(){
    object oPC = GetLastOpenedBy();
    if (!GetIsPC(oPC)) return;

    int nInt1 = GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_assassin");
    if (nInt1 == 2)
        CreateItemOnObject("dno_key_012", OBJECT_SELF);
    else if (nInt1 == 4)
       CreateItemOnObject("dno_key_016", OBJECT_SELF);
    else {
        nInt1 = GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_rogue");

        if (nInt1 == 2)
            CreateItemOnObject("dno_key_011", OBJECT_SELF);
        else if (nInt1 == 3)
           CreateItemOnObject("dno_key_016", OBJECT_SELF);
    }
}
