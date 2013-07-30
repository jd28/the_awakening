int StartingConditional(){
    object oPC = GetPCSpeaker();
    object oMith; // = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if(GetLocalInt(OBJECT_SELF, "MithrilType")){ // Guant
        oMith = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    }
    else{
        oMith = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    }

    if(GetTag(oMith) == "pl_mithral_weap")
        return FALSE;

    return TRUE;
}
