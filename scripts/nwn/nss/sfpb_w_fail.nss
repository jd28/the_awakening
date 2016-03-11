//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_w_fail
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "upb_config"
int StartingConditional()
{
    // Vars
    object oPC = GetLastSpeaker();
    //string sID = SF_GetPlayerID(oPC);
    int nGold = StringToInt(GetLocalString(OBJECT_SELF, "GOLD"));
    int nBanked = GetLocalInt(oPC, DATABASE_GOLD);
    //int nBanked = GetCampaignInt(GetName(GetModule()), "SFPB_GOLD_" + sID);

    // Check if the player has enough to withdraw
    return(nBanked < nGold);
}
