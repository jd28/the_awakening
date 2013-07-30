string sDeny;

//Put this script OnUsed
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

if (GetGold(oPC) < 1000000)
   {
   sDeny="You cannot use the wheel at this time!!";

   SendMessageToPC(oPC, sDeny);

   return;
   }

ActionStartConversation(oPC, "wheelconv1");

}
