int StartingConditional(){
    object oPC = GetPCSpeaker();
    object oConv = GetLocalObject(oPC, "PL_CONV_WITH");
    //DeleteLocalObject(oPC, "PL_CONV_WITH");

    //SendMessageToPC(oPC, GetName(oConv));

    if(!GetIsObjectValid(oConv)) oConv = OBJECT_SELF;

    return (GetGold(oPC) > GetLocalInt(oConv, "con_gold"));
}
