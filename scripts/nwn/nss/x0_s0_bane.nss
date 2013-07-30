//::///////////////////////////////////////////////
//:: Bane
//:: X0_S0_Bane.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All enemies within 30ft of the caster gain a
    -1 attack penalty and a -1 save penalty vs fear
    effects
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    float fDuration = MetaDuration(si, si.clevel), fDelay;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    effect eAttack = EffectAttackDecrease(1);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);

    GSPApplyEffectsToObject(si, TARGET_TYPE_SELECTIVE, eLink, eVis, SAVING_THROW_WILL,
                            SAVING_THROW_TYPE_MIND_SPELLS, fDuration, TRUE, TRUE, RADIUS_SIZE_COLOSSAL);

/*
    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget,SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
             //Fire spell cast at event for target
             SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 449, FALSE));
             if (!MyResistSpell(OBJECT_SELF, oTarget) )
             {

                int nWillResult = WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
                // * Bane is a mind affecting spell BUT its affects are not classified
                // * as mind affecting. To make this work I have to only apply
                // * the effects on the case of a failure, unlike most other spells.
                if (nWillResult == 0)
                {

                    fDelay = GetRandomDelay(0.4, 1.1);
                    //Apply VFX impact and bonus effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
                }
                else
                // * target will immune
                if (nWillResult == 2)
                {
                    SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
                }

            }
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    }
*/
}



