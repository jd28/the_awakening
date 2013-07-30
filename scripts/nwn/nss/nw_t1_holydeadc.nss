//::///////////////////////////////////////////////
//:: Deadly Holy Trap
//:: NW_T1_HolyDeadC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering undead with a dose of holy
    water for 12d10 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
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
        nDice = 6;
        nSides = 10;
        nDC = 0;
    }
    nDamage = RollDice(nDice,nSides);

    if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD){
        nDamage *= 2;
    }

    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

