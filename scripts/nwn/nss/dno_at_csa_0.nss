void main()
{

object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

object oWP = GetWaypointByTag("dno_WP_AT_019");


AssignCommand(oPC, ClearAllActions(FALSE));

AssignCommand(oPC, ActionJumpToObject(oWP));

}
