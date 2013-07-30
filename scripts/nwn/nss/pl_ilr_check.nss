void main(){
    object oItem = OBJECT_SELF;
    object oPC = GetItemPossessor(oItem);
    
    SendMessageToPC(oPC, "pl_ilr_check");

}

