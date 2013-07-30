//::///////////////////////////////////////////////
//:: Clarity
//:: NW_S0_Clarity.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell removes Charm, Daze, Confusion, Stunned
    and Sleep.  It also protects the user from these
    effects for 1 turn / level.  Does 1 point of
    damage for each effect removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eDam = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    int bValid;

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    //Search through effects
    effect eSearch = GetFirstEffect(si.target);
    while(GetIsEffectValid(eSearch)){
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)        bValid = TRUE;
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)  bValid = TRUE;
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)    bValid = TRUE;
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED) bValid = TRUE;
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)  bValid = TRUE;

        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE){
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
            RemoveEffect(si.target, eSearch);
        }
        eSearch = GetNextEffect(si.target);
    }
    float fDuration = 30.0  + MetaDuration(si, si.clevel);
    //After effects are removed we apply the immunity to mind spells to the target
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
}

