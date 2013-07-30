///////////////////////////////////
//: dno_at_duf_2
//: Create Chain of Office in Inv upon his death.
//: Failsafe script.
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

int nInt1;
nInt1=GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_JR1");


if (nInt1 == 4)
   CreateItemOnObject("dno_ammy", oPC);

DelayCommand(2.0, FloatingTextStringOnCreature("I have Dufrat's Chain of Office, time to leave before i get noticed.", oPC));

return;
}

