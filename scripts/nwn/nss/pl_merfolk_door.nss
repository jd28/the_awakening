void main(){
    object oDoor = OBJECT_SELF, oPC = GetPCSpeaker();

    // Take the Letter
    object oLetter = GetItemPossessedBy(oPC, "pl_merfolk_lette");
    if(oLetter != OBJECT_INVALID)
        DestroyObject(oLetter);

    // Open the door
    SetLocked(oDoor, FALSE);
    ActionOpenDoor(oDoor);
}
