//Resref and tag must be identical.

void main(){
    object oPC = GetPCSpeaker();
    string sResref = GetLocalString(OBJECT_SELF, "item_2");
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, sResref))){
        CreateItemOnObject(sResref, oPC);
    }
}
