#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    string sItem = GetLocalString(OBJECT_SELF, "item_2");
    object oItem = GetItemPossessedBy(oPC, sItem);

    SetPlotFlag(oItem, FALSE);
    DestroyObject(oItem);

    GiveTakeXP(oPC, 10000, TRUE, TRUE);
    GiveTakeGold(oPC, 50000, TRUE);
}
