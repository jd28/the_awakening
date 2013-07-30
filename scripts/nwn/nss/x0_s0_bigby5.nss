//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "gsp_func_inc"

int nSpellID = 463;
void RunHandImpact(object oTarget, object oCaster)
{

    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nDam = MaximizeOrEmpower(6,2,GetMetaMagicFeat(), 12);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DelayCommand(6.0f,RunHandImpact(oTarget,oCaster));
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nCasterModifier;
    effect eHand;
    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID, si.target) ||  GetHasSpellEffect(462, si.target)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_012"){
        si.clevel = GetLevelIncludingLL(si.caster);
        nCasterModifier = GetAbilityModifier(ABILITY_WISDOM, si.caster);
        eHand = EffectVisualEffect(VFX_DUR_FLIES);
    }
    else{
        eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
        nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
    }

    float fDuration = MetaDuration(si, si.clevel);

    if(!GetIsReactionTypeFriendly(si.target))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, si.target))
        {

            int nCasterRoll = d20(1)
                + nCasterModifier
                + GetCasterLevel(OBJECT_SELF) + 12 + -1;
            int nTargetRoll = GetAC(si.target);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check
                // * hold target for duration of spell

                nCasterRoll = d20(1) + nCasterModifier
                    + GetCasterLevel(OBJECT_SELF) + 12 + 4;

                nTargetRoll = d20(1)
                             + GetBaseAttackBonus(si.target)
                             + GetSizeModifier(si.target)
                             + GetAbilityModifier(ABILITY_STRENGTH, si.target);

                if (nCasterRoll >= nTargetRoll)
                {
                    effect eKnockdown  = EffectCutsceneImmobilize();

                    effect eLink = EffectLinkEffects(eKnockdown, eHand);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, si.target,
                                        fDuration);

                    object oSelf = OBJECT_SELF;
                    RunHandImpact(si.target, oSelf);
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);

                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}


