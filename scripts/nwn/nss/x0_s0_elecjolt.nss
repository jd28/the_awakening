//::///////////////////////////////////////////////
//:: Electric Jolt
//:: [x0_s0_ElecJolt.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of electrical damage to one target.
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
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 10);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make SR Check
        if(!GetSpellResisted(si, si.target)){
            int nDamage =  MetaPower(si, nDamDice, 4, 0, fb.dmg);
            effect eBad = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);

            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, si.target);
        }
    }
}






