int GetIsAmmo(object oItem){
    int nBaseType = GetBaseItemType(oItem);

    if(nBaseType == BASE_ITEM_ARROW ||
       nBaseType == BASE_ITEM_BOLT ||
       nBaseType == BASE_ITEM_BULLET ||
       nBaseType == BASE_ITEM_DART ||
       nBaseType == BASE_ITEM_THROWINGAXE ||
       nBaseType == BASE_ITEM_SHURIKEN)
    {
        return TRUE;
    }
    return FALSE;
}

void main(){

    object oPC = GetPCSpeaker(), oItem, oBag, oStore;
    int nMaxPrice, nGold;
    float fMarkDown;

    string sStore = GetLocalString(OBJECT_SELF, "store_sell");
    oStore = GetNearestObjectByTag(sStore);
    if(oStore == OBJECT_INVALID){
        SendMessageToPC(oPC, "No store!  Please inform a DM.");
    }

    nMaxPrice = GetLocalInt(oStore, "MaxPrice");
    if(nMaxPrice == 0){
        nMaxPrice = 50000;
    }
    fMarkDown = IntToFloat(GetLocalInt(oStore, "MarkDown")) * 0.01f;
    if(fMarkDown == 0.0){
        fMarkDown = 0.35f;
    }

    //SpeakString("MaxPrice: " + IntToString(nMaxPrice) + ", MarkDown: "+ FloatToString(fMarkDown,3,2));

    oBag = GetFirstItemInInventory(oPC);
    while(oBag != OBJECT_INVALID){

        if(GetTag(oBag) == "pl_lootbag"){
            oItem = GetFirstItemInInventory(oBag);
            while(oItem != OBJECT_INVALID){
                if(!GetItemCursedFlag(oItem) && !GetPlotFlag(oItem) && !GetStolenFlag(oItem) &&
                   !GetIsAmmo(oItem)){
                    nGold = FloatToInt(GetGoldPieceValue(oItem) * fMarkDown);
                    if(nGold > nMaxPrice) nGold = nMaxPrice;
                    SendMessageToPC(oPC, GetName(oItem) + " : " + IntToString(nGold) + "gp");
                    DestroyObject(oItem);
                    GiveGoldToCreature(oPC, nGold);
                }
                oItem = GetNextItemInInventory(oBag);
            }
        }
        oBag = GetNextItemInInventory(oPC);
    }
}
