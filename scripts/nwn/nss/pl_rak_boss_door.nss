void main()
{
    object oDoor1 = GetNearestObjectByTag("rak_boss_door", OBJECT_SELF, 1);
    object oDoor2 = GetNearestObjectByTag("rak_boss_door", OBJECT_SELF, 2);
    object oDoor3 = GetNearestObjectByTag("rak_boss_door", OBJECT_SELF, 3);

    if(!GetIsOpen(oDoor1))
        AssignCommand(oDoor1, ActionOpenDoor(oDoor1));
    if(!GetIsOpen(oDoor2))
        AssignCommand(oDoor2, ActionOpenDoor(oDoor2));
    if(!GetIsOpen(oDoor3))
        AssignCommand(oDoor3, ActionOpenDoor(oDoor3));
}
