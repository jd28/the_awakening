//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within the AOE gain +4 Str, Con, Dex
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eCon);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    float fDelay, fDuration = MetaDuration(si, si.clevel);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);
    si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
    while(GetIsObjectValid(si.target))
    {
        if(GetIsSpellTarget(si, si.target, TARGET_TYPE_ALLIES))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Signal the spell cast at event
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
            //Apply effects and VFX to target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
        }
        si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
    }
}
