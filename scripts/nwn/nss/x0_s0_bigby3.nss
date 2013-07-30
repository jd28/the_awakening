//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDuration = MetaDuration(si, 2);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id,  TRUE));
        if (!GetSpellResisted(si, si.target)){
            // Check caster ability vs. target's AC
            int nCasterModifier = GetCasterAbilityModifier(si.caster);
            int nCasterRoll = d20(1) + nCasterModifier + si.clevel;

            int nTargetRoll = GetAC(si.target);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier + si.clevel + 10 +4;

                nTargetRoll = d20(1)
                             + GetBaseAttackBonus(si.target)
                             + GetSizeModifier(si.target)
                             + GetAbilityModifier(ABILITY_STRENGTH, si.target);

                if (nCasterRoll >= nTargetRoll)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();

                    // creatures immune to paralzation are still prevented from moving
                    if (GetIsImmune(si.target, IMMUNITY_TYPE_PARALYSIS) ||
                        GetIsImmune(si.target, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        eKnockdown = EffectCutsceneImmobilize();
                    }

                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eHand, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
                }
                else{
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}


