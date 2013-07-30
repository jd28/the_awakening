void main(){
    object oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem)){
        AssignCommand(oItem, SetIsDestroyable(TRUE));
        DestroyObject(oItem);
        oItem = GetNextItemInInventory();
    }
}
