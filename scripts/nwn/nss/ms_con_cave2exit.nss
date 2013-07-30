void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

ActionStartConversation(oPC, "ms_con_cave2exit");

}

