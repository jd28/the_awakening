void CloseDoor(object oDoor){
    AssignCommand(oDoor, ActionCloseDoor(oDoor));
    AssignCommand(oDoor, SetLocked(oDoor, FALSE));
}

void main(){

    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC)) return;

    string sVar = GetLocalString(OBJECT_SELF, "trig_var");
    if(!GetLocalInt(oPC, sVar)) return;

    string sDoor = GetLocalString(OBJECT_SELF, "trig_door");
    object oDoor = GetNearestObjectByTag(sDoor);

    if(!GetIsOpen(oDoor)){
        AssignCommand(oDoor, SetLocked(oDoor, FALSE));
        AssignCommand(oDoor, ActionOpenDoor(oDoor));
    }

    DelayCommand(600.0, AssignCommand(oDoor, CloseDoor(oDoor)));
}
