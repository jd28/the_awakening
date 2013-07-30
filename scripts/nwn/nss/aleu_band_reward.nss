#include "pc_funcs_inc"

void main(){

    int nCount;
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, GetTag(OBJECT_SELF), TRUE);
    object oItem = GetItemPossessedBy(oPC, "pl_bandit_rng");
    if(GetIsObjectValid(oItem)){
        DestroyObject(oItem);
	GiveTakeXP(oPC, 200);
        GiveGoldToCreature(oPC, 400);
    }
}
