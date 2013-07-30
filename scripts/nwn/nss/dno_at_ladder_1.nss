///////////////////////////////////
//: dno_at_ladder_1
//: On Used for sewer ladder.
//: JumpTo Waypoint.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
if (!GetIsPC(oPC)) return;

object oWP = GetObjectByTag("dno_WP_SL_01");

AssignCommand(oPC, JumpToObject(oWP));

}
