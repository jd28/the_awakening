//::///////////////////////////////////////////////
//:: Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    float fDuration = MetaDuration(si, si.clevel), fDelay;

    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);

    GSPApplyEffectsToObject(si, TARGET_TYPE_STANDARD, eLink, eVis, SAVING_THROW_FORT,
                                 SAVING_THROW_TYPE_NONE, fDuration, TRUE);
/*
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Make Fortitude save to negate
            if (! MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
            {
                //Metamagic check for duration
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply visual and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
*/
}
