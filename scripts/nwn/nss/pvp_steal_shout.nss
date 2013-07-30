//::///////////////////////////////////////////////
//:: Title : Artifact Chest, onDisturb Event
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

#include "pl_pvp_inc"

void main() {
    object oPC       = GetLastDisturbed();
    object oItem     = GetInventoryDisturbItem();
    object oChest    = OBJECT_SELF;
    string sChest    = GetResRef(oChest);
    string sItem     = GetTag(oItem);
    object oSound;

    // IGNORE ADDS AND NON-PC REMOVES
    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED || !GetIsPC(oPC))
        return;

    // IGNORE INCORRECT ITEMS
    if (oItem == OBJECT_INVALID || GetName(oItem) == "" ||
        (sItem != sRedFlag && sItem != sBlueFlag))
        return;

    // IF BLUE TEAM IS STEALING FROM RED TEAM
    if (sChest == sRedChest) {
        //SpeakString("Red Chest");
        // MAKE SURE THE PLAYER IS ON THE RIGHT TEAM
        if (!PVPGetIsOnTeam(oPC, PVP_TEAM_1)) {
            FloatingTextStringOnCreature("You cannot take that Flag.", oPC, FALSE);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
            ClearChest(oChest);
            CreateItemOnObject(sItem, oChest);
            AssignCommand(oPC, ActionMoveAwayFromObject(oChest, TRUE, 5.0));
            return;
        }

        // ANNOUNCE THAT THE PLAYER HAS TAKEN THE FLAG
        PVPAnnounce(GetName(oPC)+" has taken the "+GetName(oItem)+" from the "+GetName(oChest)+".", oPC);
        oSound = GetNearestObjectByTag("blue_bell");
        SoundObjectPlay(oSound);
        return;
    }

    // IF RED TEAM IS STEALING FROM BLUE TEAM
    if (sChest == sBlueChest) {
        // MAKE SURE THE PLAYER IS ON THE RIGHT TEAM
        if (!PVPGetIsOnTeam(oPC, PVP_TEAM_2)) {
            FloatingTextStringOnCreature("You cannot take that Flag.", oPC, FALSE);
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
            ClearChest(oChest);
            CreateItemOnObject(sItem, oChest, 1);
            AssignCommand(oPC, ActionMoveAwayFromObject(oChest, TRUE, 5.0));
            return;
        }

        // ANNOUNCE THAT THE PLAYER HAS TAKEN THE FLAG
        PVPAnnounce(GetName(oPC)+" has taken the "+GetName(oItem)+" from the "+GetName(oChest)+".", oPC);
        oSound = GetNearestObjectByTag("red_bell");
        SoundObjectPlay(oSound);
        return;
    }
}

