///////////////////////////////////
//: dno_con_rope_1
//: Conversation Starter for Object.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

object oPC = GetLastUsedBy();
if (!GetIsPC(oPC)) return;

ActionStartConversation(oPC, "dno_con_rope_01");

}
