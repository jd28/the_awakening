///////////////////////////////////
//: dno_at_kan_1
//: Kannovar's OnSpawn Script.
//: Jumps Boss to 1 of 4 WayPoints in his Hideout.
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
    case 0: oWP = GetWaypointByTag("dno_WP_Kan_01");break;
    case 1: oWP = GetWaypointByTag("dno_WP_Kan_02");break;
    case 2: oWP = GetWaypointByTag("dno_WP_Kan_03");break;
    case 3: oWP = GetWaypointByTag("dno_WP_Kan_04");break;

}

AssignCommand(oNPC, JumpToObject(oWP));

}
