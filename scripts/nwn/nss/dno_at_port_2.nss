///////////////////////////////////
//: dno_at_port_1
//: JumpTo Script for port on ship.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
if (!GetIsPC(oPC)) return;

object oWP = GetObjectByTag("dno_WP_AidHi");

AssignCommand(oPC, JumpToObject(oWP));

}
