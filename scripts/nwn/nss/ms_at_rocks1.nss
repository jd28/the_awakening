void main()
{

object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

object oTarget;
location lTarget;
oTarget = GetWaypointByTag("ms_WP_CRocks1");

lTarget = GetLocation(oTarget);


AssignCommand(oPC, ClearAllActions());

AssignCommand(oPC, ActionJumpToLocation(lTarget));

}

