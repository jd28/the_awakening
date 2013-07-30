int StartingConditional(){
    object oPC = GetPCSpeaker();
    return GetLocalInt(oPC, "InvalidCDKey") != 0;
}
