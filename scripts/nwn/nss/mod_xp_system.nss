//:://////////////////////////////////////////////
//:: Scarface's XP/GP System V2.1
//:: SF_XP
//:://////////////////////////////////////////////
/*
     All code created and written by Scarface

     Modified by pope_leo.
*/
//////////////////////////////////////////////////

//#include "mod_const_inc"
#include "mod_funcs_inc"
#include "pc_funcs_inc"

// Declare the functions
int GetMaxXP(object oPC);
int CalculateXP(float fLevel, float fCR);
void GiveXP(object oKiller, int nXP, int nBossXP, float fKillerBonus, int nDiff, int nPlayer);
void XPDebugMessage(object oPC, float fCR, int nDiff, int nLoLevel, int nHiLevel, float fAvLevel);

////////////////////////////////////////////////////////////////////////////////
void main(){
    // Define major variables
    object oKiller = GetLastKiller();
    if (!GetIsPC(oKiller) && !GetIsPC(GetMaster(oKiller)))  return;
    object oParty = GetFirstFactionMember(oKiller, FALSE);
    float fDist;
    int nPlayer, nSummon, nTotalLevel, nHD, nXPToGive, nHiLevel, nLoLevel = 40;
    int nBossXP = GetLocalInt(OBJECT_SELF, VAR_XP_BOSS_BONUS);
    float fCRAdjustment = IntToFloat(GetLocalInt(GetArea(OBJECT_SELF), VAR_AREA_CR_ADJUST));

    float fCR = GetChallengeRating(OBJECT_SELF) + 2.0 + fCRAdjustment;

    // Calculate the amount of members oPC's Party
    while (GetIsObjectValid(oParty)){
        // Make sure the party member is NOT dead and are within the specified distance
        fDist = GetDistanceToObject(oParty);
        if (!GetIsDead(oParty) && fDist >= 0.0 && fDist <= PARTY_DIST){
                // Party member is a player
                if(GetIsPC(oParty)){
                    // Number of players
                    nPlayer++;

                    // Get total level of all PC party members
                    int nLevel = GetLevelByXP(oParty);
                    if(nLevel > 38) nLevel = 38;
                    nTotalLevel += nLevel;

                    // GetHighest/lowest party members
                    if (nLevel > nHiLevel) nHiLevel = nLevel;
                    if (nLevel < nLoLevel) nLoLevel = nLevel;
                }
                // Party member is a summon/familiar/henchman
                else{
                    nSummon++;
                }
        }
        oParty = GetNextFactionMember(oKiller, FALSE);
    }

    // This check is to stop the "DIVIDED BY ZERO" error message
    if (!nPlayer) nPlayer = 1;

    // Get average party level calculate difference between highest and lowest
    float fAvLevel = (IntToFloat(nTotalLevel) / nPlayer);
    int nDiff = abs(nHiLevel - nLoLevel);

    // Calculate XP
    int nBaseXP = CalculateXP(fAvLevel, fCR);
    //SendMessageToPC(oKiller, "Base XP: "+ IntToString(nBaseXP));
    int nXP = ((nBaseXP * XP_MODIFIER) / 10);
    //SendMessageToPC(oKiller, "Base XP: "+ IntToString(nXP));

    // Lets make sure the XP reward is within consts parameters
    //int nMaxXP = GetMaxXP(oKiller);

    // Calculate Penalties based on consts
    float fPenalty = (nXP *(nSummon * SUMMON_PENALTY)), fPartyBonus, fKillerBonus;

    if (PC_DIVIDE_XP)
    {
        nXPToGive = ((nXP - FloatToInt(fPenalty)) / nPlayer);
    }
    else
    {
        nXPToGive = (nXP - FloatToInt(fPenalty));
    }
    // If there is more than 1 player in the party then calculate
    // XP Bonuses based on consts
    if (nPlayer)
    {
        fPartyBonus = (nXP * (PARTY_XP_GP_BONUS * nPlayer));
        fKillerBonus = (nXPToGive * KILLER_XP_GP_BONUS);
        nXPToGive = FloatToInt(fPartyBonus) + nXPToGive;
    }
    Logger(oKiller, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Player: %s, XP: %s, Challange Rating: %s, " +
        "Level Difference: %s, High: %s, Low: %s, Party Members: %s, Boss XP: %s", GetName(oKiller), IntToString(nXPToGive),
        FloatToString(fCR, 4, 1), IntToString(nDiff), IntToString(nHiLevel), IntToString(nLoLevel), IntToString(nPlayer),
        IntToString(nBossXP));

    GiveXP(oKiller, nXPToGive, nBossXP, fKillerBonus, nDiff, nPlayer);
    //XPDebugMessage(oKiller, fCR, nDiff, nLoLevel, nHiLevel, fAvLevel);

}
// This is my function that calculates the XP reward
int CalculateXP(float fLevel, float fCR)
{
    float fXPModifier, fDiff = fabs(fLevel - fCR), fBonus = (((0.1 * fCR) * 10) / 2);
    if (fCR >= fLevel)
    {
        if (fDiff >= 10.0) fXPModifier = 100.0;
        else if (fDiff >= 5.0 && fDiff < 10.0) fXPModifier = 70.0;
        else if (fDiff >= 4.0 && fDiff < 5.0) fXPModifier = 50.0;
        else if (fDiff >= 3.0 && fDiff < 4.0) fXPModifier = 35.0;
        else if (fDiff >= 2.0 && fDiff < 3.0) fXPModifier = 20.0;
        else if (fDiff >= 1.0 && fDiff < 2.0) fXPModifier = 10.0;
        else fXPModifier = 10.0;
    }
    else if (fCR < fLevel)
    {
        if (fDiff >= 4.0) fXPModifier = 2.0;
        else if (fDiff >= 3.0 && fDiff < 4.0) fXPModifier = 4.0;
        else if (fDiff >= 2.0 && fDiff < 3.0) fXPModifier = 6.0;
        else if (fDiff >= 1.0 && fDiff < 2.0) fXPModifier = 8.0;
        else fXPModifier = 9.0;
    }
    return FloatToInt((fXPModifier * 10) + fBonus);
}
// This is my function to give XP to each party member within
// the distance specified by the constants
void GiveXP(object oKiller, int nXPToGive, int nBossXP, float fKillerBonus, int nDiff, int nPlayer){
    int nMaxXP, nRoll = Random(100)+1;
    float fDist;
    // Get first party members (Only PC's)
    object oParty = GetFirstFactionMember(oKiller);
    // Loops through all party members
    while (GetIsObjectValid(oParty)){
        // Make sure the party member is NOT dead and are within the specified distance
        fDist = GetDistanceToObject(oParty);
        if (GetIsPC(oParty)){
            if (!GetIsDead(oParty) && fDist >= 0.0 && fDist <= PARTY_DIST){
                // Get XP Limits
                nMaxXP = GetMaxXP(oParty);
                if (nXPToGive > nMaxXP)
                    nXPToGive = nMaxXP;
                else if (nXPToGive < MIN_XP)
                    nXPToGive = MIN_XP;

                // Reward Killer
                if (oKiller == oParty && nPlayer > 1)
                    nXPToGive += FloatToInt(fKillerBonus);

                // Give Minimum XP if party difference is too great.  Excpet in the case of boss bonuses.
                if (nDiff > MAX_PARTY_GAP && nPlayer > 1){
                    FloatingTextStringOnCreature("Party level difference is too great", oParty, FALSE);
                    nXPToGive = MIN_XP;
                }
                // Reward Boss Bonus
                if(nBossXP > 0){
                    SendMessageToPC(oParty, "Boss Creature Bonus");
                    nXPToGive += nBossXP;
                }

                if(GetIsSpawnCreature(OBJECT_SELF)){
                    if(GetLocalInt(OBJECT_SELF, "xp_set_var"))
                        SetLocalInt(oParty, GetTag(OBJECT_SELF), TRUE);
                    else if(GetLocalInt(OBJECT_SELF, "xp_set_persist_var"))
                        SetPlayerInt(oParty, GetTag(OBJECT_SELF), TRUE);

                    int nCount = 1, nChance;
                    object oItem;
                    string sResref = GetLocalString(OBJECT_SELF, "xp_item_" + IntToString(nCount));
                    while (sResref != ""){
                        nChance = GetLocalInt(OBJECT_SELF, "xp_item_" + IntToString(nCount));

                        if(nChance == 0 || nRoll <= nChance){
                            oItem = CreateItemOnObject(sResref, oParty);
                            SetIdentified(oItem, TRUE);
                        }

                        nCount++;
                        sResref = sResref = GetLocalString(OBJECT_SELF, "xp_item_" + IntToString(nCount));
                    }
                }

                if(GetLocalInt(oParty, "FKY_CHAT_XPBANK")){
                    int nBanked = GetLocalInt(oParty, VAR_PC_XP_BANK);
                    if(nBanked > 0){
                        if(nBanked < nXPToGive){
                            nXPToGive += nBanked;
                            nBanked = 0;
                        }
                        else{
                            nBanked -= nXPToGive;
                            nXPToGive *= 2;
                        }
                        SetLocalInt(oParty, VAR_PC_XP_BANK, nBanked);
                    }

                }

				if (GetLocalInt(OBJECT_SELF, "Boss")) {
					IncrementLocalInt(oParty, "kill_" + GetResRef(OBJECT_SELF));
					IncrementLocalInt(oParty, "killg_" + GetResRef(OBJECT_SELF));
				}

                GiveTakeXP(oParty, nXPToGive);
                GiveGoldToCreature(oParty, FloatToInt(((GetChallengeRating(OBJECT_SELF) / 2) +1 ) * 40));
            }
        }
        oParty = GetNextFactionMember(oKiller);
    }
}
// This is my function for returning the max XP for the PC's level based on the consts
int GetMaxXP(object oPC)
{
    int iMaxXP, nLevel = GetLevelByXP(oPC);
    //SendMessageToPC(oPC, "Level: " + IntToString(nLevel));
    switch(nLevel)
    {
        case 1: iMaxXP = LEVEL_1_MAX_XP; break;
        case 2: iMaxXP = LEVEL_2_MAX_XP; break;
        case 3: iMaxXP = LEVEL_3_MAX_XP; break;
        case 4: iMaxXP = LEVEL_4_MAX_XP; break;
        case 5: iMaxXP = LEVEL_5_MAX_XP; break;
        case 6: iMaxXP = LEVEL_6_MAX_XP; break;
        case 7: iMaxXP = LEVEL_7_MAX_XP; break;
        case 8: iMaxXP = LEVEL_8_MAX_XP; break;
        case 9: iMaxXP = LEVEL_9_MAX_XP; break;
        case 10: iMaxXP = LEVEL_10_MAX_XP; break;
        case 11: iMaxXP = LEVEL_11_MAX_XP; break;
        case 12: iMaxXP = LEVEL_12_MAX_XP; break;
        case 13: iMaxXP = LEVEL_13_MAX_XP; break;
        case 14: iMaxXP = LEVEL_14_MAX_XP; break;
        case 15: iMaxXP = LEVEL_15_MAX_XP; break;
        case 16: iMaxXP = LEVEL_16_MAX_XP; break;
        case 17: iMaxXP = LEVEL_17_MAX_XP; break;
        case 18: iMaxXP = LEVEL_18_MAX_XP; break;
        case 19: iMaxXP = LEVEL_19_MAX_XP; break;
        case 20: iMaxXP = LEVEL_20_MAX_XP; break;
        case 21: iMaxXP = LEVEL_21_MAX_XP; break;
        case 22: iMaxXP = LEVEL_22_MAX_XP; break;
        case 23: iMaxXP = LEVEL_23_MAX_XP; break;
        case 24: iMaxXP = LEVEL_24_MAX_XP; break;
        case 25: iMaxXP = LEVEL_25_MAX_XP; break;
        case 26: iMaxXP = LEVEL_26_MAX_XP; break;
        case 27: iMaxXP = LEVEL_27_MAX_XP; break;
        case 28: iMaxXP = LEVEL_28_MAX_XP; break;
        case 29: iMaxXP = LEVEL_29_MAX_XP; break;
        case 30: iMaxXP = LEVEL_30_MAX_XP; break;
        case 31: iMaxXP = LEVEL_31_MAX_XP; break;
        case 32: iMaxXP = LEVEL_32_MAX_XP; break;
        case 33: iMaxXP = LEVEL_33_MAX_XP; break;
        case 34: iMaxXP = LEVEL_34_MAX_XP; break;
        case 35: iMaxXP = LEVEL_35_MAX_XP; break;
        case 36: iMaxXP = LEVEL_36_MAX_XP; break;
        case 37: iMaxXP = LEVEL_37_MAX_XP; break;
        case 38: iMaxXP = LEVEL_38_MAX_XP; break;
        case 39: iMaxXP = LEVEL_39_MAX_XP; break;
        case 40: iMaxXP = LEVEL_40_MAX_XP; break;
        case 41: iMaxXP = LEVEL_41_MAX_XP; break;
        case 42: iMaxXP = LEVEL_42_MAX_XP; break;
        case 43: iMaxXP = LEVEL_43_MAX_XP; break;
        case 44: iMaxXP = LEVEL_44_MAX_XP; break;
        case 45: iMaxXP = LEVEL_45_MAX_XP; break;
        case 46: iMaxXP = LEVEL_46_MAX_XP; break;
        case 47: iMaxXP = LEVEL_47_MAX_XP; break;
        case 48: iMaxXP = LEVEL_48_MAX_XP; break;
        case 49: iMaxXP = LEVEL_49_MAX_XP; break;
        case 50: iMaxXP = LEVEL_50_MAX_XP; break;
        case 51: iMaxXP = LEVEL_51_MAX_XP; break;
        case 52: iMaxXP = LEVEL_52_MAX_XP; break;
        case 53: iMaxXP = LEVEL_53_MAX_XP; break;
        case 54: iMaxXP = LEVEL_54_MAX_XP; break;
        case 55: iMaxXP = LEVEL_55_MAX_XP; break;
        case 56: iMaxXP = LEVEL_56_MAX_XP; break;
        case 57: iMaxXP = LEVEL_57_MAX_XP; break;
        case 58: iMaxXP = LEVEL_58_MAX_XP; break;
        case 59: iMaxXP = LEVEL_59_MAX_XP; break;
        case 60: iMaxXP = LEVEL_60_MAX_XP; break;
        default: iMaxXP = LEVEL_1_MAX_XP; break;
    }
    return iMaxXP;
}

void XPDebugMessage(object oPC, float fCR, int nDiff, int nLoLevel, int nHiLevel, float fAvLevel)
{
    object oParty = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oParty))
    {
        SendMessageToPC(oParty, "\nDebug Info"+
                                "\nCreature CR: "+FloatToString(fCR)+
                                "\nHighest Level PC: "+IntToString(nHiLevel)+
                                "\nLowest Level PC: "+IntToString(nLoLevel)+
                                "\nLevel Difference: "+IntToString(nDiff)+
                                "\nAverage Party Level: "+FloatToString(fAvLevel));

        oParty = GetNextFactionMember(oPC);
    }
}
