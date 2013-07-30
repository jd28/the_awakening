///////////////////////////////////////////////////////////////////////////////
// file: door_conv
// event: OnFailToOpen
// description: A conversation with the same name as the door's tag will be
//      started with the PC. If you use any of conversation scripts the
//      variables can be set on the door.  e.g. con_port. The conversation will
//      be "public", that is hearable others.  Door must be locked and require a
//      key and the key tag to be empty.
///////////////////////////////////////////////////////////////////////////////
#include "mod_funcs_inc"

void OpenDoor(){
    string sOpenMsg = GetLocalString(OBJECT_SELF, "DelayOpenMsg");

    SpeakString(sOpenMsg);
    SetTrapActive(OBJECT_SELF, FALSE);
    SetLocked(OBJECT_SELF, FALSE);
}

void ResetDoor(){
    AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF));
    SetLocked(OBJECT_SELF, TRUE);
    DeleteLocalInt(OBJECT_SELF, "Delaying");
}

void main(){
    object oPC = GetClickingObject();
    object oDoor = OBJECT_SELF;

    if(GetLocalString(oDoor, "Conv") != ""){
        AssignCommand(oPC,ClearAllActions());
        ActionStartConversation(oPC, GetLocalString(oDoor, "Conv"));
    }
    else if(GetLocalInt(oDoor, "Delay")){
        float fDelay = IntToFloat(GetLocalInt(oDoor, "Delay"));
        float fReset = IntToFloat(GetLocalInt(oDoor, "DelayReset"));
        if(fReset == 0.0) fReset = 600.0f;
        string sDelayMsg = GetLocalString(oDoor, "DelayMsg");
        string sOpenMsg = GetLocalString(oDoor, "DelayOpenMsg");
        int bDelaying = GetLocalInt(oDoor, "Delaying");
        int Debug = TRUE;

        if(Debug){
            SendMessageToPC(oPC, "OpenDelay: " + FloatToString(fDelay) +
                " ResetDelay: " + FloatToString(fReset) + " DelayMsg: " + sDelayMsg +
                "OpenMsg: " + sOpenMsg);
        }

        if(!bDelaying){
            SetLocalInt(oDoor, "Delaying", TRUE);
            SpeakString(sDelayMsg);
            SetTrapActive(oDoor);
            DelayCommand(fDelay, OpenDoor());
            DelayCommand(fDelay+fReset, ResetDoor());
        }
    }
}
