////////////////////////////////////////////////////////////////////////////////
// gsp_protalign
//
// Spells:
//
// TODO: Fix area impact
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nShape = SHAPE_SPHERE, nAlign;
    int bSingleTarget = TRUE;
    float fDuration, fRadius = RADIUS_SIZE_MEDIUM, fDelay;

    switch(si.id){
        // Spells
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:
            bSingleTarget = FALSE;
        case SPELL_PROTECTION_FROM_EVIL:
            nAlign = ALIGNMENT_EVIL;
        break;
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:
            bSingleTarget = FALSE;
        case SPELL_PROTECTION_FROM_GOOD:
            nAlign = ALIGNMENT_GOOD;
        break;
    }

    fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);

    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    eAC = VersusAlignmentEffect(eAC, ALIGNMENT_ALL, nAlign);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlign);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eImmune, eSave);

    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply the bonus effect and VFX impact
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, si.loc);
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                //Fire spell cast at event for target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
                //Apply VFX impact and bonus effects
                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, si.loc);
        }
    }
}
