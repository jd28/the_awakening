//::///////////////////////////////////////////////
//:: Title : Artifact Chest, onOpen Event
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

#include "pl_pvp_inc"

void main() {
    object oPC   = GetLastOpenedBy();
    string sTag  = GetTag(OBJECT_SELF);

    if ((sTag == sRedChest  && PVPGetIsOnTeam(oPC, PVP_TEAM_2)) ||
        (sTag == sBlueChest && PVPGetIsOnTeam(oPC, PVP_TEAM_1)))
    {

        ErrorMessage(oPC, "You cannot use this Chest. If you have the Enemy's Flag, ring the Victory Gong.");
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, ActionMoveAwayFromObject(OBJECT_SELF, TRUE, 5.0));
    }
}

