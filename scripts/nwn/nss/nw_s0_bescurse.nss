//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Afflicted creature must save or suffer a -2 penalty
to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(4, 4, 4, 4, 4, 4);

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);
    if(!GetIsReactionTypeFriendly(si.target)){
        //Signal spell cast at event
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make SR Check
        if (!GetSpellResisted(si, si.target)){
            //Make Will Save
            if (!GetSpellSaved(si, SAVING_THROW_FORT, si.target)){
                //Apply Effect and VFX
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, si.target);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
            }
        }
    }
}
