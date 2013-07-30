void main(){
    object oPC = GetLastUsedBy();
    if(!GetIsPC(oPC)) return;

    if (GetLocalInt(oPC, GetTag(OBJECT_SELF))) return;
    SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);

    string sMsg = GetLocalString(OBJECT_SELF, "place_msg");

    SendMessageToPC(oPC, sMsg);

}
