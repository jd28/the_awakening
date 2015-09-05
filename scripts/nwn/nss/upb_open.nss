//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_open
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "upb_config"

// TODO - Redo completely.
void main()
{
  /*
    // Vars
    object oPC = GetLastOpenedBy();
    object oChest = OBJECT_SELF;
    string sUserID = GetLocalString(oChest, "USER_ID");

    // End script if any of these conditions are met
    if (!GetIsPC(oPC) ||
         GetIsDM(oPC) ||
         GetIsDMPossessed(oPC) ||
         GetIsPossessedFamiliar(oPC)) return;

    // If the chest is already in use then this must be a thief
    if (sUserID != "" && sUserID != GetPCPlayerName(oPC)) return;

    // Set the players ID as a local string onto the chest
    // for anti theft purposes
    SetLocalString(oChest, "USER_ID", GetPCPlayerName(oPC));

    int nCount, bContinue = TRUE;
    object oCreated;
    while (bContinue){
        oCreated = GetDbObject(oPC, "Item_" + IntToString(nCount), oChest, TRUE);
        //GetPersistentObject(oChest1, "Item_" + IntToString(nCount), oChest2);
        if (!GetIsObjectValid(oCreated))
            bContinue = FALSE;
        else
            nCount++;
    }

    string sSQL = "DELETE FROM pwobjdata WHERE tag='" + SQLEncodeSpecialChars(GetLocalString(oPC, "pc_player_name")) + "'";
    SQLExecDirect(sSQL);

    // Get the player's storer NPC from the database
    object oStorer = OBJECT_INVALID; //GetPersistentObject(oPC, DATABASE_ITEM, oPC, CHARACTER_SHARING);
    DeletePersistentVariable(oPC, DATABASE_ITEM, CHARACTER_SHARING);

    // loop through the NPC storers inventory and copy the items into the chest.
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
*/
}
