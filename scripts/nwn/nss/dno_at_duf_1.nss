///////////////////////////////////
//: dno_at_Duf_1
//: Dufrat's OnSpawn Script.
//: Jumps Boss to 1 of 4 WayPoints in Council Building.
/////////////////////////////
//: K9-69 ;o)
/////////////
void main()
{


object oNPC = OBJECT_SELF;

 object oWP;
    int iRandom = Random(4);

switch (iRandom)
{
    case 0: oWP = GetWaypointByTag("dno_WP_Duf_01");break;
    case 1: oWP = GetWaypointByTag("dno_WP_Duf_02");break;
    case 2: oWP = GetWaypointByTag("dno_WP_Duf_03");break;
    case 3: oWP = GetWaypointByTag("dno_WP_Duf_04");break;

}

AssignCommand(oNPC, JumpToObject(oWP));

}
