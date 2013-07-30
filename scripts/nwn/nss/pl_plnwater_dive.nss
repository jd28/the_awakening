void main(){
    object oPC = GetPCSpeaker();
    object oHelm, oScale;

    if(GetGold(oPC) < 20000000){
        SpeakString("You don't have the gold!");
        return;
    }

    oHelm = GetItemPossessedBy(oPC, "pl_water_helm");
    oScale = GetItemPossessedBy(oPC, "pl_merfolk_scale");

    if(oHelm == OBJECT_INVALID ||
       oScale == OBJECT_INVALID)
    {
        SpeakString("You don't have the necessary items!");
        return;
    }

    SetPlotFlag(oHelm, FALSE);
    DestroyObject(oHelm, 0.2f);
    SetPlotFlag(oScale, FALSE);
    DestroyObject(oScale, 0.2f);
    TakeGoldFromCreature(20000000, oPC, TRUE);

    CreateItemOnObject("pl_water_helm2", oPC);
    SpeakString("There you go!");

}
