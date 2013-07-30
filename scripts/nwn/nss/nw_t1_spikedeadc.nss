//::///////////////////////////////////////////////
//:: Deadly Spike Trap
//:: NW_T1_SpikeStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a spike for
    25d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
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
        nDice = 6;
        nSides = 25;
        nDC = 0;
    }
    nDamage = RollDice(nDice,nSides);

    DoTrapSpike(nDamage);
}

