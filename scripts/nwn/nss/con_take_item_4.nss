void main(){
    object oPC = GetPCSpeaker();
    string sItem = GetLocalString(OBJECT_SELF, "item_4");
    object oItem = GetItemPossessedBy(oPC, sItem);

    SetPlotFlag(oItem, FALSE);
    DestroyObject(oItem);
}

