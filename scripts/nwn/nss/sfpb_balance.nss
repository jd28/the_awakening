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
    // TODO - Fix
    int nBanked = GetLocalInt(oPC, DATABASE_GOLD);

    // Set custom token for the account balance
    SetCustomToken(1000, IntToString(nBanked));
}
