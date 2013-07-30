//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_open
//:://////////////////////////////////////////////
/*
    Written By Scarface
    Edited by pope_leo for persistend donation box
    please see pdb_config for limitations, etc*/
//////////////////////////////////////////////////

#include "pdb_config"
void main()
{
    // Vars
    object oPC = GetLastOpenedBy();
    object oChest = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    string sTag = GetTag(oChest);
    string sModName = GetName(GetModule());
    int iOpen = GetLocalInt(oChest, "OPEN") + 1;

    SendMessageToPC(oPC, "There are currently " + IntToString(iOpen) + " people using the chest.");

    // End script if any of these conditions are met
    if (!GetIsPC(oPC) ||
         GetIsDM(oPC) ||
         GetIsDMPossessed(oPC) ||
         GetIsPossessedFamiliar(oPC)) return;

    // If the chest is already in use then this must be a thief
    //if (sUserID != "" && sUserID != sID) return;

    // Set the players ID as a local string onto the chest
    // for anti theft purposes
    //SetLocalString(oChest, "USER_ID", sID);
    SetLocalInt(oChest, "OPEN", iOpen);

    if(iOpen > 1) return;

    // Get the player's storer NPC from the database
    object oStorer = RetrieveCampaignObject(sModName, DATABASE_ITEM + sTag, lLoc);
    DeleteCampaignVariable(sModName, DATABASE_ITEM + sTag);

    // loop through the NPC storers inventory and copy the items
    // into the chest.
    object oItem = GetFirstItemInInventory(oStorer);
    while (GetIsObjectValid(oItem))
    {
        // Copy the item into the chest
        CopyItem(oItem, oChest, TRUE);

        // Destroy the original
        DestroyObject(oItem);

        // Next item
        oItem = GetNextItemInInventory(oStorer);
    }

    // Destroy the NPC storer
    DestroyObject(oStorer);
}
