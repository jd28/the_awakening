//::///////////////////////////////////////////////
//:: Bigby's Interposing Hand
//:: [x0_s0_bigby1]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants -10 to hit to target for 1 round / level
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

    int nAttackDecrease = 5;

    if(si.clevel > 24) nAttackDecrease + (si.clevel - 20)/4;

    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id,  TRUE));

        if (!GetSpellResisted(si, si.target)){
            effect eAC1 = EffectAttackDecrease(nAttackDecrease);
            effect eVis = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
            effect eLink = EffectLinkEffects(eAC1, eVis);

            float fDuration = MetaDuration(si, si.clevel/2);
            //Apply the TO HIT PENALTIES bonuses and the VFX impact
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
        }
    }
}

