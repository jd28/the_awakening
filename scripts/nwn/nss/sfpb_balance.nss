//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_balance
//:://////////////////////////////////////////////
/*
    Written By Scarface
*/
//////////////////////////////////////////////////

#include "upb_config"
void main()
{
    // Vars
    object oPC = GetLastSpeaker();
    //string sID = SF_GetPlayerID(oPC);
    //int nBanked = GetCampaignInt(GetName(GetModule()), DATABASE_GOLD + sID);
    int nBanked = GetDbInt(oPC, DATABASE_GOLD, TRUE);

    // Set custom token for the account balance
    SetCustomToken(1000, IntToString(nBanked));
}
