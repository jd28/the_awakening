//::///////////////////////////////////////////////
//:: Deadly Frost Trap
//:: X2_T1_ColdEpicC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 40d4 damage. Fortitude save to avoid
    being paralyzed for 4 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
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
        nDice = 40;
        nSides = 4;
        nDC = 30;
    }
    nDamage = RollDice(nDice, nSides);

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    if(!MySavingThrow(SAVING_THROW_FORT,oTarget, nDC, SAVING_THROW_TYPE_COLD))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

