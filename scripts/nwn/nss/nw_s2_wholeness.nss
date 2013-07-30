//::///////////////////////////////////////////////
//:: Wholeness of Body
//:: NW_S2_Wholeness
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The monk is able to heal twice his level in HP
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    si.target = OBJECT_SELF;
    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_MONK, OBJECT_SELF);

    int nHeal = nLevel * 2;
    if(nLevel >= 20){
        nHeal = GetMaxHitPoints(OBJECT_SELF)-GetCurrentHitPoints(OBJECT_SELF);
    }
    else if(nLevel >= 30){
        nHeal = GetMaxHitPoints(OBJECT_SELF)-GetCurrentHitPoints(OBJECT_SELF);
        Restore(si, FALSE, TRUE);
    }

    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WHOLENESS_OF_BODY, FALSE));
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
}
