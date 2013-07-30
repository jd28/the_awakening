int StartingConditional(){
    object oPC = GetPCSpeaker();
    object oMith = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);

    if(GetTag(oMith) == "pl_mithral_weap")
        return FALSE;

    return TRUE;
}
