void main(){

    object oSelf = OBJECT_SELF;
    string sDoor = GetLocalString(oSelf, "OpenDoor");
    object oDoor = GetNearestObjectByTag(sDoor);

    if(GetIsOpen(oDoor))
        return;

    AssignCommand(oSelf, ClearAllActions(TRUE));
    AssignCommand(oSelf, ActionOpenDoor(oDoor));
    AssignCommand(oSelf, ActionMoveToObject(GetWaypointByTag(GetResRef(oSelf))));
    AssignCommand(oSelf, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oSelf, SetCommandable(FALSE));
}
