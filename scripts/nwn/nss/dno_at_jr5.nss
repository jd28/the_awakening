///////////////////////////////////
//: dno_at_jr5
//: Update Journal Entry for Rogue Task Entry 5.
//: Remove Ammy from Inv & give tomb raider boots as reward.
/////////////////////////////
//: K9-69 ;o)
/////////////
//#include "nw_i0_tool"
#include "quest_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC)) return;

    CreateItemOnObject("dno_tr_boots", oPC);
    QuestAdvance(OBJECT_SELF, oPC);
}
