//::///////////////////////////////////////////////
//:: Energy Drain
//:: NW_S0_EneDrain.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target loses 2d4 levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    int nDrain = MetaPower(si, 4, 4, 0, 0);

    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);
    if(!GetIsReactionTypeFriendly(si.target)){
        //Signal spell cast at event
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make SR Check
        if (!GetSpellResisted(si, si.target)){
            if (!GetSpellSaved(si, SAVING_THROW_FORT, si.target, SAVING_THROW_TYPE_NEGATIVE)){
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, si.target);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
            }
        }
    }
}

