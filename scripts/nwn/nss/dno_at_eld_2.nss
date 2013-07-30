///////////////////////////////////
//: dno_at_eld_2
//: Create Signet Ring in Inv upon Eldicar's death.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{
    object oPC = GetLastKiller();
    while (GetIsObjectValid(GetMaster(oPC)))
        oPC = GetMaster(oPC);

    if (!GetIsPC(oPC)) return;

    if (GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_assassin") != 3){
        //SendMessageToPC(oPC, "Wrong Quest Number");
        return;
    }

    CreateObject(OBJECT_TYPE_ITEM, "dno_signet", GetLocation(OBJECT_SELF));

}
