void main(){
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC)) return;

    if (GetLocalInt(oPC, GetTag(OBJECT_SELF))) return;

    SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);
    string sSpeak = GetLocalString(OBJECT_SELF, "trig_msg");

    if(sSpeak != "")
        AssignCommand(oPC, SpeakString(sSpeak));
}
