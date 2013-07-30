//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    dazed vs strength check (+14 on strength check); Target knocked down.
    Target dazed down for 1 round per level of caster

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    if(GetIsReactionTypeFriendly(si.target))
        return;

    float fDuration = MetaDuration(si, 2);
    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 30);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    // Apply the impact effect
    effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target);

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id,  TRUE));
    if (GetSpellResisted(si, si.target))
        return;

    int nCasterRoll = d20(1) + 14;
    int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, si.target) + GetSizeModifier(si.target);

    //Apply damage
    int nDamage = MetaPower(si, nDamDice, 8, 0, fb.dmg);
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, si.target);

    // * bullrush succesful, knockdown target for duration of spell
    if (nCasterRoll >= nTargetRoll){
        effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
        effect eKnockdown = EffectDazed();
        effect eKnockdown2 = EffectKnockdown();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        //Link effects
        effect eLink = EffectLinkEffects(eKnockdown, eDur);
        eLink = EffectLinkEffects(eLink, eKnockdown2);

        //Apply the penalty
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, si.target, fDuration);
        // * Bull Rush succesful
        FloatingTextStrRefOnCreature(8966, si.caster, FALSE);
    }
    else{
        FloatingTextStrRefOnCreature(8967, si.caster, FALSE);
    }
}


