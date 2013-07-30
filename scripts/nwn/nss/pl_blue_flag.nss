#include "pl_pvp_inc"

void main(){
    object oItem  = GetModuleItemAcquired();      // The Item that was Acquired
    object oPC    = GetItemPossessor(oItem);      // Who Acquired the Item
    object oArea = GetArea(oPC);
    object oGiver = GetModuleItemAcquiredFrom();  // Who Gave the Item to the PC

    if(GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACQUIRE)
        return;

    // If a player logged with flag destroy it on reentry...  Also destry it if no active game
    if ((PVPGetIsOnTeam(oPC, PVP_TEAM_2) && GetLocalInt(oPC, "PVP_LOGGED_WITH_FLAG"))
        || !GetLocalInt(oArea, "GAME_START"))
    {
        DestroyObject(oItem);
        DeleteLocalInt(oPC, "PVP_LOGGED_WITH_FLAG");
    }
    else if (PVPGetIsOnTeam(oPC, PVP_TEAM_1)){
        // BLUE IS RETURNING THEIR FLAG TO BASE
        PVPReturnFlag2(sBlueChest, sBlueFlag, oItem);
        // INCREASE RETURNS FOR PC
        PVPUpdateReturns(oPC);

        PVPAnnounce(GetName(oPC) + " has returned the " + GetName(oItem) + " to safety!", oPC);

    }
    else if (GetObjectType(oGiver) != OBJECT_TYPE_PLACEABLE) {
        // RED IS RECAPTURING THE FLAG - Flag stealing is handled elsewhere
        PVPAnnounce(GetName(oPC) + " has picked up the " + GetName(oItem) + "!", oPC);
        PVPRemoveEffects(oPC);
        FloatingTextStringOnCreature("You must now ring the Victory Gong located in your fort.", oPC, FALSE);
    }
}
