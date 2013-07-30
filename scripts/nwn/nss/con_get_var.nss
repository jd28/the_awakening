int StartingConditional(){
    string sVar = GetLocalString(OBJECT_SELF, "GetVar");
    object oPC = GetPCSpeaker();

    return GetLocalInt(oPC, sVar);
}
