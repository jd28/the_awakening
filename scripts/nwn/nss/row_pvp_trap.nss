//::///////////////////////////////////////////////
//:: Title : Trap, onEnter Event
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

// This script is used on the trap trigger's onEnter event.
// It removes the following magical effects from the entering character:
//   Haste
//   Invisibility
//   Improved Invisibility
//   Movement Increases
//
// This trap is placed at the entrance(s) of the team bases to dispell/
// even the playing field between the defenders and mages/rogues.
//
// This Trap Trigger is optional and can be removed from the game to
// make it more competitive.

#include "pl_pvp_inc"

void main() {
    object oPC = GetEnteringObject();

    // CHECK TO SEE IF THE ENTERING OBJECT IS AN ENEMY
    if ((GetTag(OBJECT_SELF) == "PVP_TRAP_BLUE_DISPEL" &&
         PVPGetIsOnTeam(oPC, PVP_TEAM_2)) ||
        (GetTag(OBJECT_SELF) == "PVP_TRAP_RED_DISPEL"  &&
         PVPGetIsOnTeam(oPC, PVP_TEAM_1)))
    {

        PVPRemoveEffects(oPC);

        //Sound the Alarm
        PlaySound("as_pl_officerm4");

        //Apply a Visual Effect to the Person
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_KNOCK), oPC);
    }
}
