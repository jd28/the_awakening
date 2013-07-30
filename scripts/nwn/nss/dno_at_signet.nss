///////////////////////////////////
//: dno_at_signet
//: Conversation starter for Ship Portal.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

object oPC = GetPCSpeaker();
if (!GetIsPC(oPC)) return;

ActionStartConversation(oPC, "dno_con_at_005");

}

