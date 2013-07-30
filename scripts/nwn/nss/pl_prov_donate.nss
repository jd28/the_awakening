#include "vfx_inc"

void main(){
    object oPC = GetPCSpeaker();
    TakeGoldFromCreature(50, oPC, TRUE);
    effect eAB = EffectAttackIncrease(1);
    effect eHP = EffectTemporaryHitpoints(40);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, oPC, 600.0);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHP, oPC);
    ApplyVisualToObject(VFX_IMP_HOLY_AID, oPC);
}
