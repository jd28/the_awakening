//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect.
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
    int nHD;
    float fDelay, fDuration = MetaDuration(si, 3+d4());
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink1 = EffectLinkEffects(eSleep, eMind);

    effect eLink2 = EffectLinkEffects(eStun, eMind);
    eLink2 = EffectLinkEffects(eLink2, eDur);

    effect eLink3 = EffectLinkEffects(eBlind, eMind);

    effect eVis1 = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);
    effect eVis3 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

    //Get first object in the spell cone
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, si.loc, TRUE);
    while (GetIsObjectValid(oTarget)){
        if (GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE) && oTarget != si.caster){
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));

            fDelay = GetDistanceBetween(si.caster, oTarget) / 30;
            if(!GetSpellResisted(si, oTarget, fDelay)){
                if(!GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_MIND_SPELLS, fDelay)){
                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2){
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, fDuration));
                    }
                    else if(nHD > 2 && nHD < 5){
                         fDuration = fDuration - 1.0f;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, fDuration));
                    }
                    else{
                         fDuration = fDuration - 2.0f;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, si.loc, TRUE);
    }
}

