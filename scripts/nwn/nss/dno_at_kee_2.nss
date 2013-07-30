///////////////////////////////////
//: dno_at_kee_2
//: Create Lock of Hair in Inv upon Keeva's death.
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

    if (GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_assassin") != 2){
        //SendMessageToPC(oPC, "Wrong Quest Number");
        return;
    }

    CreateObject(OBJECT_TYPE_ITEM, "dno_hair", GetLocation(OBJECT_SELF));

}
