#include "pl_pclevel_inc"

const int PVC_MAX_HITPOINTS = 18;              // Max hit points allowed
const int MAX_SKILL_POINTS_TOTAL = 70;     // Max skill points in total
const int MAX_SKILL_POINTS_SINGLE = 10;    // Max skill points in any one skill
const int DEBUG_MODE = 2;                  // 0 = Off, 1 = PC & DM, 2 = DM Only

void GetIsPCValid(object oPC);

// Checks to see if the players current character file matches, the one
// stored in the database at first login.  If not, it's a Dupe Name, so
// Delete it
int GetIsBicFileValid(object oPC);

int GetIsPCNameValid(object oPC);

void SE_Debug(string sMessage);
int SE_CheckSkillPointsTotal(object oPC);
int SE_CheckSkillPointsSingle(object oPC);

void ValidateFeats(object oPC);
void ValidateAbilities(object oPC);

void GetIsPCValid(object oPC){
    string sIllegal;

    ForceRest(oPC); //in case they try to use the feat to dodge detection (unlikely, but whatever)

/*
    if(/*GetCurrentHitPoints(oPC) > PVC_MAX_HITPOINTS ||
       SE_CheckSkillPointsTotal(oPC) > MAX_SKILL_POINTS_TOTAL ||
       SE_CheckSkillPointsSingle(oPC))
    {
        SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal hp
        sIllegal = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "ILLEGAL Hit Points Detected: Name: %s, " +
                          "Account: %s, CDKey: %s, IPAddress: %s", GetName(oPC), GetPCPlayerName(oPC),
                          GetPCPublicCDKey(oPC), GetPCIPAddress(oPC));
        SendMessageToAllDMs(sIllegal);
    }
*/
    ValidateAbilities(oPC);
    ValidateFeats(oPC);
}

/*
int GetLegalHitPoints(object oPC){
    int nClass = GetClassByPosition(1, oPC);
    int nCon = GetLocalInt(oPC, "BASE_CON");
    int nClassDie;
    int nFeatBonus = 0;
    int nTotal;
    string sIllegal;
    if(GetHasFeat(FEAT_TOUGHNESS, oPC)){
        nFeatBonus = 1;
    }

    switch(nClass){
        case CLASS_TYPE_BARBARIAN:
            nClassDie = 12; break;
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_FIGHTER:
            nClassDie = 10; break;
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_CLERIC:
            nClassDie = 8; break;
        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_BARD:
            nClassDie = 6; break;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
            nClassDie = 4; break;
        default:
            SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal class
            sIllegal = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "ILLEGAL Class Detected: Name: %s, " +
                              "Account: %s, CDKey: %s, IPAddress: %s", GetName(oPC), GetPCPlayerName(oPC),
                              GetPCPublicCDKey(oPC), GetPCIPAddress(oPC));
            SendMessageToAllDMs(sIllegal);
        break;
    }
    nTotal = nClassDie + nFeatBonus + GetBaseAbilityModifier(nCon);
    return nTotal;
}
*/
int GetPointCostOfStat(int nScore){
    int nCost;
    switch(nScore){
        case 8: nCost = 0; break;
        case 9: nCost = 1; break;
        case 10: nCost = 2; break;
        case 11: nCost = 3; break;
        case 12: nCost = 4; break;
        case 13: nCost = 5; break;
        case 14: nCost = 6; break;
        case 15: nCost = 8; break;
        case 16: nCost = 10; break;
        case 17: nCost = 13; break;
        case 18: nCost = 16; break;
        default: nCost = 40; break;//any stat other than these indicates illegal edits, so we flag them illegal to start (total over 30 is illegal)
    }
    return nCost;
}

void ValidateAbilities(object oPC){
//object oPC = GetPCSpeaker();
    //if (GetXP(oPC) != 0) return;

    string sIllegal;
    string sName = GetName(oPC);
    string sPlayername = GetPCPlayerName(oPC);

    int nStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE); //GetLocalInt(oPC, "BASE_STR");
    int nDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE); //GetLocalInt(oPC, "BASE_DEX");
    int nCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE); //GetLocalInt(oPC, "BASE_CON");
    int nInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE); //GetLocalInt(oPC, "BASE_INT");
    int nWis = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE); //GetLocalInt(oPC, "BASE_WIS");
    int nCha = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE); //GetLocalInt(oPC, "BASE_CHA");
    int nRace = GetRacialType(oPC);
    int nPointTotal;

    switch (nRace)//neutralize racial bonuses
    {
        case RACIAL_TYPE_DWARF://2con -2cha
            nCon = nCon - 2;
            nCha = nCha +2;
        break;
        case RACIAL_TYPE_ELF://2dex -2con
            nDex = nDex - 2;
            nCon = nCon +2;
        break;
        case RACIAL_TYPE_GNOME://2con -2str
            nCon = nCon - 2;
            nStr = nStr +2;
        break;
        case RACIAL_TYPE_HALFLING://2dex -2str
            nDex = nDex - 2;
            nStr = nStr +2;
        break;
        case RACIAL_TYPE_HALFORC://2str -2int -2cha
            nStr = nStr - 2;
            nInt = nInt +2;
            nCha = nCha +2;
        break;
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HALFELF:
        break;
        default:
            SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal race
            sIllegal = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "ILLEGAL Race Detected: Name: %s, " +
                              "Account: %s, CDKey: %s, IPAddress: %s", GetName(oPC), GetPCPlayerName(oPC),
                              GetPCPublicCDKey(oPC), GetPCIPAddress(oPC));
            SendMessageToAllDMs(sIllegal);
        break;
    }
    nPointTotal = GetPointCostOfStat(nStr) + GetPointCostOfStat(nDex) + GetPointCostOfStat(nCon) + GetPointCostOfStat(nInt) + GetPointCostOfStat(nWis) + GetPointCostOfStat(nCha);
    if (nPointTotal > 30){
        SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal stats
        sIllegal = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "ILLEGAL Stats Detected: Name: %s, " +
                          "Account: %s, CDKey: %s, IPAddress: %s", GetName(oPC), GetPCPlayerName(oPC),
                          GetPCPublicCDKey(oPC), GetPCIPAddress(oPC));
        SendMessageToAllDMs(sIllegal);
    }
    /*if (GetCurrentHitPoints(oPC) != GetLegalHitPoints(oPC)){
        SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal hp
        sIllegal = "Illegal Hit Points Detected - Name: " + GetName(oPC) + "; Account: " + GetPCPlayerName(oPC) + "; CDKey: " + GetPCPublicCDKey(oPC) + ".";
        WriteTimestampedLogEntry(sIllegal);
        SendMessageToAllDMs(sIllegal);
    } */
}
/*

int GetIsRacialFeat(int nFeat){
    if ((nFeat > 226) && (nFeat < 251))
        return TRUE;

    int nReturn = FALSE;
    switch(nFeat){
        case 256:
        case 258:
        case 354:
        case 375: nReturn = TRUE; break;
        default : nReturn = FALSE; break;
    }
    return nReturn;
}

int GetIsDomainFeat(int nFeat){
    if ((nFeat > 305) && (nFeat < 326))
        return TRUE;

    return FALSE;
}

void DebugIt(string sIllegal){
    string sInsert = "Reason for feat failure = ";
    sInsert = sInsert + sIllegal;
    WriteTimestampedLogEntry(sInsert);
    SendMessageToAllDMs(sInsert);
}

int GetIsMiscClassOrRaceFeat(int nFeat, object oPC){
    if (((nFeat == 1) || (nFeat == 41)) && GetClassByPosition(1, oPC) == CLASS_TYPE_RANGER)
        return TRUE;
    if (((nFeat == 6) || (nFeat == 39)) && GetClassByPosition(1, oPC) == CLASS_TYPE_MONK)
        return TRUE;
    if (nFeat == 170 && GetRacialType(oPC) == RACIAL_TYPE_GNOME)
        return TRUE;

    return FALSE;
}

int GetIsFeatLegal(int nFeat, object oPC, int nClass1){
    if (GetIsMiscClassOrRaceFeat(nFeat, oPC))
        return TRUE;//covers feats given to classes or races regardless of requisites

//    if (GetIsFeatDevCrit(nFeat)) return FALSE;
//    if (!GetAreFeatStatReqsMet(nFeat, oPC)) {DebugIt("StatReq"); return FALSE;}
//    if (!GetAreFeatSkillReqsMet(nFeat, oPC)) {DebugIt("SkillReq"); return FALSE;}
//    if (!GetAreFeatFeatReqsMet(nFeat, oPC)) {DebugIt("FeatReq"); return FALSE;}
//    if (!GetHasRequiredSpellLevelForFeat(oPC, nFeat)) {DebugIt("SpellLevReq"); return FALSE;}

    if(!GetMeetsFeatRequirements (oPC, nFeat)) return FALSE;

    if (!GetIsClassGrantedFeat(nClass1, nFeat) &&
        //!GetIsClassFeat(nFeat, nClass1, oPC) &&
        !GetIsRacialFeat(nFeat) &&
        !GetIsDomainFeat(nFeat) &&
        !GetIsGeneralFeat(nFeat))
        {
            DebugIt("Non-Class/Gen");
            return FALSE;
        }//if it's not a class feat and it's not a general feat return FALSE

    return TRUE;
}
*/
void ValidateFeats(object oPC){
    string sIllegal;
    int nClass = GetClassByPosition(1, oPC);

    int nKnownFeats = GetTotalKnownFeats(oPC), nFeat, i;
    for(i = 0; i < nKnownFeats; i++){
        nFeat = GetKnownFeat(oPC, i);
        Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Total Feats: %s, Feat: %s", IntToString(nKnownFeats), IntToString(nFeat));
        if(!(GetMeetsFeatRequirements(oPC, nFeat) || GetIsClassGrantedFeat(nClass, nFeat))){//<< Something Wrong with horse menu feat.
            if(!(GetRacialType(oPC) == RACIAL_TYPE_GNOME && nFeat == FEAT_SPELL_FOCUS_ILLUSION)){
                SetLocalInt(oPC, "Hacker", 2);//mark the character as having illegal feats
                sIllegal = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "ILLEGAL Feat Detected (%s) : Name: %s, " +
                                  "Account: %s, CDKey: %s, IPAddress: %s", GetFeatName(nFeat), GetName(oPC), GetPCPlayerName(oPC),
                                  GetPCPublicCDKey(oPC), GetPCIPAddress(oPC));
                SendMessageToAllDMs(sIllegal);
            }
        }
    }
}
/*
int SE_TotalFeatsByRaceClass(object oPC)
{
    int nFeats = 1;
    //racial feat count
    switch(GetRacialType(oPC))
    {
        case RACIAL_TYPE_DWARF:    nFeats += 8; break;
        case RACIAL_TYPE_ELF:      nFeats += 8; break;
        case RACIAL_TYPE_GNOME:    nFeats += 9; break;
        case RACIAL_TYPE_HALFELF:  nFeats += 6; break;
        case RACIAL_TYPE_HALFLING: nFeats += 6; break;
        case RACIAL_TYPE_HALFORC:  nFeats += 1; break;
        case RACIAL_TYPE_HUMAN:    nFeats += 2; break;// +1(extra feat for humans)
    }
    //class feat count
    switch(GetClassByPosition(1, oPC))
    {
        case CLASS_TYPE_BARBARIAN:nFeats += 7; break;
        case CLASS_TYPE_BARD:     nFeats += 6; break;// -1 for Scribe Scroll
        case CLASS_TYPE_CLERIC:   nFeats += 8; break;// +2 for Domain Powers
                                                     // -1 for Scribe Scroll
        case CLASS_TYPE_DRUID:    nFeats += 6; break;// -1 for Scribe Scroll
        case CLASS_TYPE_FIGHTER:  nFeats += 7; break;
        case CLASS_TYPE_MONK:     nFeats += 7; break;
        case CLASS_TYPE_PALADIN:  nFeats += 9; break;// -1 for Scribe Scroll
        case CLASS_TYPE_RANGER:   nFeats += 10; break;// +2 for Ambidexterity & Two Weapon Fighting
                                                      // -1 for Scribe Scroll
        case CLASS_TYPE_ROGUE:    nFeats += 3; break;
        case CLASS_TYPE_SORCERER: nFeats += 2; break;// -1 for Scribe Scroll
        case CLASS_TYPE_WIZARD:   nFeats += 3; break;
    }
    SE_Debug("Race + Class feats should total [" + IntToString(nFeats) + "]");
    return nFeats;
}

int SE_CheckFeatTotal(object oPC)
{
   int nFeat, i;
   for (i = 0; i < MAX_FEAT_NUM; i++)
   {
      if(GetHasFeat(i, oPC))
      {
         SE_Debug("You have feat [" + IntToString(i) + "]");
         nFeat++;
      }
   }

   SE_Debug("You have a total of [" + IntToString(nFeat) + "] feats");
   return nFeat;
}
*/
int SE_CheckSkillPointsTotal(object oPC)
{
   int nSkill, i;
   for (i = 0; i < 27; i++)
   {
      if(GetSkillRank(i, oPC) > -1)
         nSkill += GetSkillRank(i, oPC);
   }

   SE_Debug("You have a total of [" + IntToString(nSkill) + "] skill points");
   return nSkill;
}

int SE_CheckSkillPointsSingle(object oPC)
{
   int i;
   for (i = 0; i < 27; i++)
   {
      if(GetSkillRank(i, oPC) > MAX_SKILL_POINTS_SINGLE)
         return TRUE;
   }

   return FALSE;
}

void SE_Debug(string sMessage)
{
    if(DEBUG_MODE)
    {
       if(DEBUG_MODE == 1)
          SendMessageToPC(GetFirstPC(), sMessage);
       SendMessageToAllDMs(sMessage);
    }
}

int GetIsBicFileValid(object oPC){
    string sDBBic = GetDbString(oPC, VAR_PC_BIC_FILE);
    string sCurrentBic = GetPCFileName(oPC);

    if(sDBBic == "" || sDBBic == sCurrentBic){
        return TRUE;
    }
    return FALSE;
}

int GetIsPCNameValid(object oPC){
    return (GetIsStringLegal(GetName(oPC)) && GetIsStringLegal(GetPCPlayerName(oPC)));
}
