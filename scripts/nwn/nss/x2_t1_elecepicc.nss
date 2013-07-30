//::///////////////////////////////////////////////
//:: Electrical Trap
//:: X2_T1_ElecEpicC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 60d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: andrew Nobbs
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
        nDice = 60;
        nSides = 6;
        nDC = 35;
    }

    nDamage = RollDice(nDice, nSides);

    TrapDoElectricalDamage(nDamage,nDC,6);
}

