void main()
{
    object oPC = GetEnteringObject();
    object oControl = GetNearestObjectByTag("pl_wizorc_cage_control", oPC);

    if(!GetLocalInt(oControl, "Deactivated"))
        AssignCommand(oPC, ClearAllActions());
}
