//#include "nw_i0_tool"

void main(){

    object oSpeaker = GetObjectByTag("pl_prov_hostess");
    object oPC = GetEnteringObject();

    if(!GetIsPC(oPC)) return;

    if (GetLocalInt(oPC, GetTag(OBJECT_SELF)) != 0) return;
    SetLocalInt(oPC, GetTag(OBJECT_SELF), 1);

    DelayCommand(1.5, AssignCommand(oSpeaker, SpeakString("Hi there, " + GetName(oPC) + ".  Can I have a word with you?")));
}
