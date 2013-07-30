void main(){
    object oPC = GetLastUsedBy();
    object oDoor;
    int nDoor = GetLocalInt(OBJECT_SELF, "PL_TOMBHOR_DOOR"), i;

    // * note that nActive == 1 does  not necessarily mean the placeable is active
    // * that depends on the initial state of the object
    int nActive = GetLocalInt (OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE");
    // * Play Appropriate Animation
    if (!nActive)
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    }
    else
    {
      ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
    }
    // * Store New State
    SetLocalInt(OBJECT_SELF,"X2_L_PLC_ACTIVATED_STATE",!nActive);

    for(i = 1; i <= 3; i++){
        oDoor = GetNearestObjectByTag("pl_tombhor_door_"+IntToString(i), oPC);
        if(i == nDoor){
            AssignCommand(oDoor, SetLocked(oDoor, FALSE));
            AssignCommand(oDoor, ActionOpenDoor(oDoor));
        }
        else{
            if(GetIsOpen(oDoor))
                AssignCommand(oDoor, ActionCloseDoor(oDoor));
            AssignCommand(oDoor, SetLocked(oDoor, TRUE));
        }
    }


}
