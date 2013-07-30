int StartingConditional(){
    object oForge = GetNearestObjectByTag("Forge");
    return GetIsObjectValid(GetFirstItemInInventory(oForge));
}
