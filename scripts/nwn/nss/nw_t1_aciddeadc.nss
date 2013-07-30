//::///////////////////////////////////////////////
//:: Deadly Acid Blob
//:: NW_T1_AcidDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is hit with a blob of acid that does
    18d6 Damage and holds the target for 5 rounds.
    Can make a Reflex save to avoid the hold effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main()
{
    //Declare major variables
    int nDuration = 5;
    object oTarget = GetEnteringObject();
    int nDamage, nDice, nSides, nDC;

    nDice = GetLocalInt(OBJECT_SELF, "trap_dice");
    nSides = GetLocalInt(OBJECT_SELF, "trap_sides");
    nDC = GetLocalInt(OBJECT_SELF, "trap_dc");

    if(nDice == 0){
        nDice = GetLocalInt(GetArea(OBJECT_SELF), "trap_dice");
        nSides = GetLocalInt(GetArea(OBJECT_SELF), "trap_sides");
        nDC = GetLocalInt(GetArea(OBJECT_SELF), "trap_dc");
    }
    if(nDice == 0){
        nDice = 18;
        nSides = 6;
        nDC = 25;
    }
    nDamage = RollDice(nDice,nSides);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    effect eHold = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eHold, eDur);

    //Make Reflex Save
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_TRAP))
    {
        //Apply Hold and Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
    else
    {
        //Apply Hold
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
