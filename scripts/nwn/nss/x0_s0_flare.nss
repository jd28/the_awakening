//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by ray loses 1 to attack rolls.

    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eLink = EffectAttackDecrease(1);
    float fDuration = RoundsToSeconds(10);

    GSPApplyEffectsToObject(si, TARGET_TYPE_SELECTIVE, eLink, eVis, SAVING_THROW_FORT,
                            SAVING_THROW_TYPE_NONE, fDuration, TRUE);
/*
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));

       // * Apply the hit effect so player knows something happened
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


        //Make SR Check
        if ((!MyResistSpell(OBJECT_SELF, oTarget)) &&  (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) == FALSE) )
        {
            //Set damage effect
            effect eBad = EffectAttackDecrease(1);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10));
        }
    }
*/
}
