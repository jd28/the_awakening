//Make the caller face oTarget
void SetFacingObject(object oTarget){
    vector vFace = GetPosition(oTarget);
    SetFacingPoint(vFace);
}

void main(){
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC)) return;

    string sTag = GetLocalString(OBJECT_SELF, "trig_npc_tag");
    string sSpeak = GetLocalString(OBJECT_SELF, "trig_msg");
    int nOnce = GetLocalInt(OBJECT_SELF, "trig_once");

    if(nOnce){
        if (GetLocalInt(oPC, GetTag(OBJECT_SELF)) != 0) return;

        SetLocalInt(oPC, GetTag(OBJECT_SELF), 1);
    }

    if(sTag == "" || sSpeak == "") return;

    object oObject = GetNearestObjectByTag(sTag, oPC);
    if(oObject == OBJECT_INVALID) return;

    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE){
        AssignCommand(oObject, SetFacingObject(oPC));
    }

    DelayCommand(0.2, AssignCommand(oObject, SpeakString(sSpeak)));
}
