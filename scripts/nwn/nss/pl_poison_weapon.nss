#include "pc_funcs_inc"

void main(){
    object oPC = OBJECT_SELF;
    object oWeapon = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    effect ePoison;
    float fDuration;

    int nPoison = GetLocalInt(oWeapon, "PL_POISON_TYPE");

    switch(nPoison) {
        default:
            ErrorMessage(oPC, "Invalid Poison Type!");
            break;
    }

}
