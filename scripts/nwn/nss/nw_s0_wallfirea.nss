//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo(GetAreaOfEffectCreator());
    if (si.id < 0) return;

    //Declare major variables
    int nDamage;
    effect eDamage;
    object oTarget = GetEnteringObject();

    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    if (!GetIsSpellTarget(si, oTarget, TARGET_TYPE_STANDARD)) {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
        if (!GetSpellResisted(si, oTarget)) {
            nDamage = MetaPower(si, 6, 8, 0, 0);
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, si.dc, SAVING_THROW_TYPE_FIRE);

            if(nDamage > 0){
                eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
        }
    }
}
/**/
