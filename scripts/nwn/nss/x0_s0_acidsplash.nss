//::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of acid damage to one target.
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
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 10);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    if(GetIsReactionTypeFriendly(si.target))
        return;

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    //Make SR Check
    if(GetSpellResisted(si, si.target))
        return;

    //Set damage effect
    int nDamage =  MetaPower(si, nDamDice, 4, 0, fb.dmg);
    effect eBad = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    //Apply the VFX impact and damage effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, si.target);
}




