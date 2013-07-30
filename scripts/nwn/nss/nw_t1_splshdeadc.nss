//::///////////////////////////////////////////////
//:: Deadly Acid Splash Trap
//:: NW_T1_SplshStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 8d8 damage. Reflex save to take
    1/2 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main()
{
    //Declare major variables
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
        nDice = 8;
        nSides = 8;
        nDC = 20;
    }
    nDamage = RollDice(nDice,nSides);

    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP);

    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

