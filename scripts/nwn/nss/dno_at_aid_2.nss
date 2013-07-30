///////////////////////////////////
//: dno_at_aid_2
//: Create Aid's Finger in Inv upon his death.
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

    if (GetLocalInt(oPC, "NW_JOURNAL_ENTRYdno_assassin") != 4){
        //SendMessageToPC(oPC, "Wrong Quest Number");
        return;
    }

    CreateObject(OBJECT_TYPE_ITEM, "dno_finger", GetLocation(OBJECT_SELF));

}
