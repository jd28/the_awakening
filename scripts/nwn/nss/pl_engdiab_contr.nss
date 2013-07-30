void SpeakStatus(int nCount){
    object oOtherControl = GetNearestObjectByTag("pl_engdiab_control");

    // Both Controls are active.
    if(GetLocalInt(oOtherControl, "X2_L_PLC_ACTIVATED_STATE")){
        SpeakString("Activation Success: Gate Opened");
        oOtherControl = GetNearestObjectByTag("pl_engdiab_gate");
        AssignCommand(oOtherControl, SetLocked(oOtherControl,FALSE));
        AssignCommand(oOtherControl, ActionOpenDoor(oOtherControl));
        return;
    }


    if(nCount <= 0){
        SpeakString("Activation Failed");
        SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",0);
        ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
        return;
    }

    SpeakString("Deactivating in " + IntToString(nCount) + ((nCount ==1) ? "second." : " seconds."));

    DelayCommand(1.0, SpeakStatus(nCount - 1));
}

void main(){
    // * note that nActive == 1 does  not necessarily mean the placeable is active
    // * that depends on the initial state of the object
    int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
    object oOtherControl = GetNearestObjectByTag("pl_engdiab_control");

    // * Play Appropriate Animation
    if (!nActive){
        SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",1);
        if(GetLocalInt(oOtherControl, "X2_L_PLC_ACTIVATED_STATE")){
            SpeakString("Activation Success: Gate Opened");
            oOtherControl = GetNearestObjectByTag("pl_engdiab_gate");
            AssignCommand(oOtherControl, SetLocked(oOtherControl,FALSE));
            AssignCommand(oOtherControl, ActionOpenDoor(oOtherControl));
            return;
        }
        ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
        SpeakString("Begining Activation Sequence.");
        SpeakStatus(5);
        DelayCommand(30.0f, SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",0));
    }
}
