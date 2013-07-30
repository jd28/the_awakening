///////////////////////////////////
//: dno_at_kan_2
//: Create Brooch in Inv upon Kannovar's death.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{
object oPC = GetLastKiller();
while (GetIsObjectValid(GetMaster(oPC)))
   {
   oPC=GetMaster(oPC);
   }

if (!GetIsPC(oPC)) return;

int nInt;
nInt=GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_JA1");

if (nInt < 1)
   return;

CreateItemOnObject("dno_brooch", oPC);

DelayCommand(2.0, FloatingTextStringOnCreature("My Target is dead and I have recovered the brooch.", oPC));


}
