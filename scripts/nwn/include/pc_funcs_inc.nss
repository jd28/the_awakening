// pc_funcs_inc
#include "pc_hide_inc"
#include "zep_inc_phenos2"
#include "info_inc"
#include "pl_effects_inc"
#include "ws_inc_shifter"

// Apply Respawn Penalty to PC
void ApplyRespawnPenalty(object oPC);

//ApplyFeatSuperNaturalEffects
void ApplyFeatSuperNaturalEffects(object oPC);

// Boots oPC
void BootPlayer(object oPC);

// Returns how many items with Tag sTag that oPC possess.
int CountItemByTag(object oPC, string sTag);

//Delete all equipped itmes except for Creature items and inventory.
void DeleteAllItems(object oPC);

//Delete all equipped itmes except for Creature items.
void DeleteAllEquippedItems(object oPC);

//Delete all inventory.
void DeleteAllInventory(object oPC);

//Deletes oPC bic file.
void DeleteBic(object oPC);

// Forces player to unequip an item.
void ForceUnequipItem(object oPC, object oItem, int bClearComabt = TRUE);

// This function determines what class controls the character's advancement during legendary
// levels. First it checks the character's It returns the class type with the most levels.
// If the character has two classes that tie for most number of levels, it will return the
// class the character took first. It returns -1 on an error.
// FunkySwerve: HGLL
int GetControlClass(object oPC);

// This function determines whether a PC has enough experience to take the next legendary
// level.  Possible return values: 1 for having enough, 0 for not, -1 for having too few
// levels to gain Legendary levels, and -2 for already having the maximum amount of LL.
int GetHasXPForNextLevel(object oPC);

// Returns the highest class, the earlier if equal
int GetHighestClass(object oCreature);

// Checks to see if player is wearing an item with the specified Tag
int GetIsEquippedByTag(object oPC, string sTag);

// Check if player has "[HCR]" in their name
int GetIsHardcoreCharacter(object oPC);

// Check if player has "[TEST]" in their name
int GetIsTestCharacter(object oPC);

// Converts ILR class numbers to CLASS_TYPE_* constants
int GetILRClass(int nClass);

// Returns true if oPC has any Polymorph effect applied to them.
int GetIsPCShifted(object oPC);

// Returns false if player has LLs, PM, or RDD levels
int GetIsRelevelable(object oPC);

//Returns the PC's Level including Legendary Levels.
int GetLevelIncludingLL(object oPC);

int GetLevelByClassIncludingLL(int nClassType, object oPC);

// Returns level based on total experience
int GetLevelByXP(object oPC);

// Returns Experience min for level given it.
int GetXPByLevel(int iLevel);

// This function returns the amount of XP the PC is missing to reach their next LL. It will
// return the amount needed to reach level 41 if they are under level 40. If they already
// have enough, it returns 0. If they are level 60, it returns -1.
int GetXPNeededForNextLevel(object oPC);

//XXX
void GiveTakeGold(object oPC, int nAmount, int bEntireParty = FALSE, object oSource = OBJECT_INVALID);

//XXX
void GiveTakeXP(object oPC, int nAmount, int feedback = TRUE, int bEntireParty = FALSE, object oSource = OBJECT_INVALID);

// NOT IMPLEMENTED YET
int GiveTakeLevels(object oPC, int nAmount, int bEntireParty = FALSE, object oSource = OBJECT_INVALID);

//ID all items in a players inventory
void IDAllItems(object oPC);

// Sets oPC uncommandable to ensure jump success
void JumpSafeToLocation(location lLoc, object oPC = OBJECT_SELF);

// Sets oPC uncommandable to ensure jump success
void JumpSafeToObject(object oObj, object oPC = OBJECT_SELF);

// Sets oPC uncommandable to ensure jump success
void JumpSafeToWaypoint(string sWaypoint, object oPC = OBJECT_SELF);

//Exports oPC
void PCOnAcquireSave(object oPC);

// Respawn PC and sends them to respawn location if valid.
void PCRespawn(object oPC);

// Changes oFlyer to flying phenotype
void pl_Fly(object oFlyer);

// Changes oFlyer back from flying phenotype
void pl_Fly_Land(object oFlyer);

// Determine the levels that oCreature holds in nClassType.
// Modified to support CLASS_TYPE_*_GROUP
// - nClassType: CLASS_TYPE_*
// - oCreature
int PLGetLevelByClass(int nClassType, object oCreature=OBJECT_SELF);

// Resurrect player, remove negative effects.
void Raise(object oPC);

// Saves player location to database
void SavePersistentLocation(object oPC);

void SendChatLogMessage(object oRecipient, string sMessage, object oSender = OBJECT_INVALID, int nChannel = 4);

//Send All players on the server sMessage
void SendAllMessage(string sMessage, float fDelay = 0.0);

//Send All players in oArea sMessage
void SendAreaMessage(object oArea, string sMessage, float fDelay = 0.0);

//Send sMessage all players in oRecipients party.
void SendPartyMessage(object oRecipient, string sMessage, float fDelay = 0.0);

//Send sMessage to oRecipient on channel according to "pc_msg_filter" variable.
void SendPCMessage(object oRecipient, string sMessage, float fDelay = 0.0);

//Send sMessage on "Server" channel to all players on server.
void SendServerMessage(object oSender, string sMessage);

//Send sMessage on "Server" channel to oRecipient.
void SendSystemMessage(object oRecipient, string sMessage, object oSender = OBJECT_INVALID);

// Take Item from oPC with the Tag sTag.  If nAmount = 0, all items with sTag
// will be taken, if nAmount > 0 that number of items will be taken.
int TakeItemByTag(object oPC, string sTag, int nAmount = 0);

void SavePersistentState(object pc);
void LoadPersistentState(object pc);

////////////////////////////////////////////////////////////////////////////////

void ApplyRespawnPenalty(object oPC){
    int nXP = GetXP(oPC);
    int nHD = GetLevelIncludingLL(oPC);
    // * You can not lose a level with this respawning
    int nMin = GetXPByLevel(nHD);
    int nPenalty;

    // No respawn penalty for 4th and below.
    if(nHD <= 4) return;
    else if(nHD <= 36) nPenalty = 50;
    else nPenalty = 75;

    nPenalty *= nHD;
    GiveTakeXP(oPC, -nPenalty);

    int nGoldToTake = FloatToInt(0.1 * GetGold(oPC));
    // * a cap of 10 000gp taken from you
    if (nGoldToTake > 10000) nGoldToTake = 10000;

    AssignCommand(oPC, TakeGoldFromCreature(nGoldToTake, oPC, TRUE));
}

void ApplyFeatSuperNaturalEffects(object oPC){
/*
    effect eEff;

    if(GetHasFeat(TA_FEAT_CIRCLE_KICK, oPC)
        && !GetHasSpellEffect(TASPELL_CIRCLE_KICK, oPC)
        && GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == OBJECT_INVALID)
    {
        //SetBaseAttackBonus(GetBaseAttackBonus(oPC) + 1, oPC);
        //SetLocalInt(oPC, "TA_CIRCLE_KICK", TRUE);
        eEff = EffectAdditionalAttacks(1);
        eEff = SupernaturalEffect(eEff);
        SetEffectSpellId(eEff, TASPELL_CIRCLE_KICK);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
        SendMessageToPC(oPC, C_GREEN+"Circle Kick: Bonus attack applied!"+C_END);
    }
*/
}

void BootPlayer(object oPC){
    if(GetIsObjectValid(oPC))
        BootPC(oPC);
}

int CountItemByTag(object oPC, string sTag){
    // Count how many items are in the inventory

    int nCount = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        if(GetTag(oItem) == sTag){
            nCount++;
        }

        oItem = GetNextItemInInventory(oPC);
    }
    return nCount;
}

void DeleteAllInventory(object oPC){
    object oItem = GetFirstItemInInventory(oPC);

    while (GetIsObjectValid(oItem)){
        DestroyObject(oItem, 0.1);
        oItem = GetNextItemInInventory(oPC);
    }
}

void DeleteAllItems(object oPC){
    DeleteAllEquippedItems(oPC);
    DeleteAllInventory(oPC);
}

void DeleteAllEquippedItems(object oPC){
    object oItem;
    int nSlot;

    for (nSlot = 0; nSlot < 14; nSlot++){
        oItem = GetItemInSlot(nSlot, oPC);
        DestroyObject(oItem, 0.1);
    }
}

void DoDeleteBic(string sFile){
    string sLog = Logger(GetModule(), VAR_DEBUG_LOGS, LOGLEVEL_MINIMUM, "Attempting to delete file: %s.", sFile);
    //Leto("FileDelete q<" + sFile + ">");
    FileDelete (sFile);
}
void DeleteBic(object oPC){
    string sFile = SRV_SERVERVAULT + "/" + GetPCPlayerName(oPC) + "/" + GetPCFileName(oPC) + ".bic";
    DelayCommand(3.0, BootPlayer(oPC));
    DelayCommand(4.0, DoDeleteBic(sFile));
}

void ForceUnequipItem(object oPC, object oItem, int bClearComabt = TRUE){
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 0.1);
    AssignCommand(oPC, ClearAllActions(bClearComabt));
    AssignCommand(oPC, ActionUnequipItem(oItem));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

int GetControlClass(object oPC){
    int nL1 = GetLevelByPosition(1, oPC);
    int nL2 = GetLevelByPosition(2, oPC);
    int nL3 = GetLevelByPosition(3, oPC);
    //class 1 highest
    if ((nL1 > nL2) && (nL1 > nL3)) return GetClassByPosition(1, oPC);
    //class 2 highest
    else if ((nL2 > nL1) && (nL2 > nL3)) return GetClassByPosition(2, oPC);
    //class 3 highest
    else if ((nL3 > nL1) && (nL3 > nL2)) return GetClassByPosition(3, oPC);
    //class 1 and 2 tied for highest
    else if (nL1 == nL2) return GetClassByPosition(1, oPC);
    //class 1 and 3 tied for highest
    else if (nL1 == nL3) return GetClassByPosition(1, oPC);
    //class 2 and 3 tied for highest
    else if (nL2 == nL3) return GetClassByPosition(2, oPC);
    //return -1 on error
    else return -1;
}

int GetLevelIncludingLL(object oPC){
    int nLevel = GetLootable(oPC);

    if (nLevel < 41) return GetHitDice(oPC);
    else return nLevel;
}

int GetLevelByClassIncludingLL(int nClassType, object oPC){
    int nLL = GetLootable(oPC), nLevel;

    if (nLL > 40 && GetControlClass(oPC) == nClassType)
        nLevel = nLL - 40;

    return GetLevelByClass(nClassType, oPC) + nLevel;
}

int GetNumberOfLegendaryLevels(object oChar = OBJECT_SELF){
    int nLoot = GetLootable(oChar) - 40;
    if (nLoot < 0) nLoot = 0;
    return nLoot;
}

int GetHasXPForNextLevel(object oPC){
    int nLevel = GetLevelIncludingLL(oPC);
    int nXP = GetXP(oPC);

    if(nLevel == 60) return -2; //Max Levels

    return ((GetXPByLevel(nLevel + 1) - nXP) <= 0);
}


int GetHighestClass(object oCreature){
    int nClass1 = GetLevelByPosition(1, oCreature);
    int nClass2 = GetLevelByPosition(2, oCreature);
    int nClass3 = GetLevelByPosition(3, oCreature);
    int nHighest = 1;
    if (nClass2 > nClass1 && nClass2 > nClass3) nHighest = 2;
    else if (nClass3 > nClass2 && nClass3 > nClass1) nHighest = 3;
    return GetClassByPosition(nHighest, oCreature);
}

int GetIsHardcoreCharacter(object oPC){
    return (FindSubString(GetName(oPC), "[HCR]") >= 0);
}

int GetIsTestCharacter(object oPC){
    return (FindSubString(GetName(oPC), "[TEST]") >= 0);
}

int GetILRClass(int nClass){
    switch (nClass){
        case 1: return CLASS_TYPE_BARBARIAN;
        case 2: return CLASS_TYPE_BARD;
        case 3: return CLASS_TYPE_CLERIC;
        case 4: return CLASS_TYPE_DRUID;
        case 5: return CLASS_TYPE_FIGHTER;
        case 6: return CLASS_TYPE_MONK;
        case 7: return CLASS_TYPE_PALADIN;
        case 8: return CLASS_TYPE_RANGER;
        case 9: return CLASS_TYPE_ROGUE;
        case 10: return CLASS_TYPE_SORCERER;
        case 11: return CLASS_TYPE_WIZARD;
        case 12: return CLASS_TYPE_SHADOWDANCER;
        case 13: return CLASS_TYPE_HARPER;
        case 14: return CLASS_TYPE_ARCANE_ARCHER;
        case 15: return CLASS_TYPE_ASSASSIN;
        case 16: return CLASS_TYPE_BLACKGUARD;
        case 17: return CLASS_TYPE_DIVINECHAMPION;
        case 18: return CLASS_TYPE_WEAPON_MASTER;
        case 19: return CLASS_TYPE_PALEMASTER;
        case 20: return CLASS_TYPE_SHIFTER;
        case 21: return CLASS_TYPE_DWARVENDEFENDER;
        case 22: return CLASS_TYPE_DRAGON_DISCIPLE;
        case 23: return CLASS_TYPE_PURPLE_DRAGON_KNIGHT;
        case 24: return CLASS_TYPE_BARD_GROUP;
        case 25: return CLASS_TYPE_DRUID_GROUP;
        case 26: return CLASS_TYPE_FIGHTER_GROUP;
        case 27: return CLASS_TYPE_MAGE_GROUP;
        case 28: return CLASS_TYPE_ROGUE_GROUP;
    }
    return CLASS_TYPE_INVALID;
}

int GetIsEquippedByTag(object oPC, string sTag){
    int i;
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++){
        if(GetTag(GetItemInSlot(i, oPC)) == sTag)
            return TRUE;
    }
    return FALSE;
}

int GetIsPCShifted(object oPC){
    effect eEffect = GetFirstEffect(oPC);

    while( GetEffectType(eEffect) != EFFECT_TYPE_INVALIDEFFECT){
        if ( GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
            return TRUE;
        eEffect = GetNextEffect(oPC);
    }
    return FALSE;
}

int GetIsRelevelable(object oPC){
    if(GetLocalInt(oPC, VAR_PC_NO_RELEVEL))
        return FALSE;

    if(!GetIsTestCharacter(oPC)
       && (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) >= 1
           || GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC) >= 1))
    {
        return FALSE;
    }
    return TRUE;
}

int GetLevelByXP(object oPC){

    int iXP = GetXP(oPC), nLevel;

    if (iXP >= XP_REQ_LVL60) nLevel = 60;
    else if (iXP >= XP_REQ_LVL59) nLevel = 59;
    else if (iXP >= XP_REQ_LVL58) nLevel = 58;
    else if (iXP >= XP_REQ_LVL57) nLevel = 57;
    else if (iXP >= XP_REQ_LVL56) nLevel = 56;
    else if (iXP >= XP_REQ_LVL55) nLevel = 55;
    else if (iXP >= XP_REQ_LVL54) nLevel = 54;
    else if (iXP >= XP_REQ_LVL53) nLevel = 53;
    else if (iXP >= XP_REQ_LVL52) nLevel = 52;
    else if (iXP >= XP_REQ_LVL51) nLevel = 51;
    else if (iXP >= XP_REQ_LVL50) nLevel = 50;
    else if (iXP >= XP_REQ_LVL49) nLevel = 49;
    else if (iXP >= XP_REQ_LVL48) nLevel = 48;
    else if (iXP >= XP_REQ_LVL47) nLevel = 47;
    else if (iXP >= XP_REQ_LVL46) nLevel = 46;
    else if (iXP >= XP_REQ_LVL45) nLevel = 45;
    else if (iXP >= XP_REQ_LVL44) nLevel = 44;
    else if (iXP >= XP_REQ_LVL43) nLevel = 43;
    else if (iXP >= XP_REQ_LVL42) nLevel = 42;
    else if (iXP >= XP_REQ_LVL41) nLevel = 41;
    else{
         nLevel = FloatToInt(0.5 + sqrt(0.25 + ( IntToFloat(GetXP(oPC)) / 500 )));
    }
    if(nLevel == 0) nLevel = 1;

    return nLevel;
}

int GetXPByLevel(int nLevel){

    if(nLevel <= 40)
        return (((nLevel - 1) * nLevel) / 2) * 1000;

    switch (nLevel){
        case 41: return XP_REQ_LVL41; break; //<< The following values are effectively
        case 42: return XP_REQ_LVL42; break; //<< the settings for Legendary Levels
        case 43: return XP_REQ_LVL43; break;
        case 44: return XP_REQ_LVL44; break;
        case 45: return XP_REQ_LVL45; break;
        case 46: return XP_REQ_LVL46; break;
        case 47: return XP_REQ_LVL47; break;
        case 48: return XP_REQ_LVL48; break;
        case 49: return XP_REQ_LVL49; break;
        case 50: return XP_REQ_LVL50; break;
        case 51: return XP_REQ_LVL51; break;
        case 52: return XP_REQ_LVL52; break;
        case 53: return XP_REQ_LVL53; break;
        case 54: return XP_REQ_LVL54; break;
        case 55: return XP_REQ_LVL55; break;
        case 56: return XP_REQ_LVL56; break;
        case 57: return XP_REQ_LVL57; break;
        case 58: return XP_REQ_LVL58; break;
        case 59: return XP_REQ_LVL59; break;
        case 60: return XP_REQ_LVL60; break;
    }
    return -1;
}

int GetXPNeededForNextLevel(object oPC){
    int nLevel = GetLevelIncludingLL(oPC);
    int nXP = GetXP(oPC);
    if(nLevel == 60) return -1; //Max Levels

    nXP = GetXPByLevel(nLevel + 1) - nXP;

    if(nXP <= 0) nXP = 0;

    return nXP;
}

void GiveTakeGold(object oPC, int nAmount, int bEntireParty = FALSE, object oSource = OBJECT_INVALID){
    if(bEntireParty){
        oPC = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oPC)){
            if(nAmount >= 0){
                GiveGoldToCreature(oPC, nAmount);
                if(GetIsObjectValid(oSource))
                    SendMessageToPC(oSource, GetName(oPC) + " has been given " + IntToString(nAmount) + "gold piece(s).");
            }
            else{
                TakeGoldFromCreature(-nAmount, oPC, TRUE); // Must pass a positive number.
                if(GetIsObjectValid(oSource))
                    SendMessageToPC(oSource, GetName(oPC) + " has lost " + IntToString(nAmount) + "gold piece(s).");
           }
           oPC = GetNextFactionMember(oPC);
        }
    }
    else{
        if(nAmount >= 0){
            GiveGoldToCreature(oPC, nAmount);
            if(GetIsObjectValid(oSource))
                SendMessageToPC(oSource, GetName(oPC) + " has been given " + IntToString(nAmount) + "gold piece(s).");
        }
        else{
            TakeGoldFromCreature(-nAmount, oPC, TRUE); // Must pass a positive number.
            if(GetIsObjectValid(oSource))
                SendMessageToPC(oSource, GetName(oPC) + " has lost " + IntToString(nAmount) + "gold piece(s).");
       }
    }
}

void GiveTakeXP(object oPC, int nAmount, int feedback = TRUE, int bEntireParty = FALSE, object oSource = OBJECT_INVALID){
    if(bEntireParty){
        oPC = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oPC)){
            ModifyXPDirect(oPC, nAmount);
            if ( GetIsObjectValid(oSource) ) {
	            if(nAmount >= 0) SendMessageToPC(oSource, GetName(oPC) + " has been given " + IntToString(nAmount) + " experience point(s).");
                else SendMessageToPC(oSource, GetName(oPC) + " has lost " + IntToString(nAmount) + " experience point(s).");
            }
    	    if ( feedback ) {
                if(nAmount > 0) {
    	            SendMessageToPC(oPC, "Experience Points Gained: " + IntToString(nAmount));
        	    }
                else if (nAmount < 0) {
	                SendMessageToPC(oPC, "Experience Points Lost: " + IntToString(nAmount));
                }
            }
            oPC = GetNextFactionMember(oPC);
        }
    }
    else{
        ModifyXPDirect(oPC, nAmount);
        if(GetIsObjectValid(oSource)){
            if(nAmount >= 0) SendMessageToPC(oSource, GetName(oPC) + " has been given " + IntToString(nAmount) + " experience point(s).");
            else SendMessageToPC(oSource, GetName(oPC) + " has lost " + IntToString(nAmount) + " experience point(s).");
        }
    	if ( feedback ) {
            if(nAmount > 0) {
	            SendMessageToPC(oPC, "Experience Points Gained: " + IntToString(nAmount));
        	}
            else if (nAmount < 0) {
	            SendMessageToPC(oPC, "Experience Points Lost: " + IntToString(nAmount));
            }
        }
    }
}

int GiveTakeLevels(object oPC, int nAmount, int bEntireParty = FALSE, object oSource = OBJECT_INVALID){
    int bGive = TRUE;
    int nHD = GetHitDice(oPC);

    if(nAmount < 0) bGive = FALSE;
    /*
    if (nHD < 40){
    int nTargetLevel = nHD + nAmount;
    if (nTargetLevel > 40) nTargetLevel = 40;
    int nTargetXP = (( nTargetLevel * ( nTargetLevel - 1 )) / 2 * 1000 );
    SetXP(oReceiver, nTargetXP);
    string sLevel = XP4;
    if (nLevels == 1) sLevel = XP5;
    if (nMessage) SendMessageToPC(oDM, C_RED+XP6+IntToString(nLevels)+sLevel+XP7+GetName(oReceiver) + "."+C_END);
    }
    else if (nMessage) SendMessageToPC(oDM, C_RED+GetName(oReceiver)+XP3+C_END);
    */
    return FALSE;
}


void IDAllItems(object oPC){
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem)){
        SetIdentified(oItem, TRUE);
        oItem = GetNextItemInInventory(oPC);
    }
}

void JumpSafeToLocation(location lLoc, object oPC = OBJECT_SELF){
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 0.1);
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, JumpToLocation(lLoc));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

void JumpSafeToObject(object oObj, object oPC = OBJECT_SELF){
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 0.1);
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, JumpToObject(oObj));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

void JumpSafeToWaypoint(string sWaypoint, object oPC = OBJECT_SELF){
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 0.1);
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, JumpToObject(GetWaypointByTag(sWaypoint)));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}

void RePoly(object oPC) {
	int is_poly = ScanForPolymorphEffect(oPC) != -2;
	if (is_poly) {
		DelayCommand(0.5, ApplyPolymorph(oPC,
										 GetLocalInt(oPC, "GW_PolyID"),
										 GetLocalInt(oPC, "GW_WeaponType"),
										 TRUE));
	}
}

void PCOnAcquireSave(object oPC){
    DeleteLocalInt(oPC, VAR_PC_ACQUIRE_SAVE);
	RePoly(oPC);
    ExportSingleCharacter(oPC);
    SavePersistentState(oPC);
	ExecuteScript("ta_update_kills", oPC);
    SendPCMessage(oPC, C_GREEN+"Your character has been saved."+C_END);
}

void PCRespawn(object oPC){

    // -------------------------------------------------------------------------
    // Resurrect & Heal The Player.
    // -------------------------------------------------------------------------
    Raise(oPC);

    // -------------------------------------------------------------------------
    // Port them to whatever respawn location they should go to.
    // -------------------------------------------------------------------------
    string sWay;
    if(GetIsTestCharacter(oPC)){
        sWay = "wp_test_spawn";
    }
    else{
        sWay = "wp_prov_spawn";
        ApplyRespawnPenalty(oPC);
    }

    JumpSafeToWaypoint(sWay, oPC);
}

void pl_Fly(object oFlyer){
    if (GetIsObjectValid(oFlyer)==FALSE) {return;}
    if (GetObjectType(oFlyer)!=OBJECT_TYPE_CREATURE){return;}

    int nAppearance = GetAppearanceType(oFlyer);
    if (nAppearance == APPEARANCE_TYPE_INVALID){return;}

    int nNewPhenotype, nBool = FALSE, nAppearance2;

    int nPhenotype_C = GetPhenoType(oFlyer);
    if (nPhenotype_C >nMAX_PHENOTYPE_ALLOWED){return;} //prevents horseriders from flying.

    //Handle Switching (speed, wings afterwards)
    switch (nAppearance){
        case APPEARANCE_TYPE_DWARF:
        case APPEARANCE_TYPE_ELF:
        case APPEARANCE_TYPE_GNOME:
        case APPEARANCE_TYPE_HALF_ELF:
        case APPEARANCE_TYPE_HALF_ORC:
        case APPEARANCE_TYPE_HALFLING:
        case APPEARANCE_TYPE_HUMAN:
            if (nPhenotype_C == 0){
                nNewPhenotype = n1st_Get_2DARow("phenotype",nCEP_PH_FLY,sCEP_PH_FLY);
                if (nNewPhenotype!=-1){
                    SetPhenoType(nNewPhenotype,oFlyer);
                    nBool=TRUE;
                }
            }
            else{
                nNewPhenotype = n1st_Get_2DARow("phenotype",nCEP_PH_FLY_L,sCEP_PH_FLY_L);
                if (nNewPhenotype!=-1){
                    SetPhenoType(nNewPhenotype,oFlyer);
                    nBool=TRUE;
                }
            }
        break;
    }  // end Switch

    if (nBool == FALSE) {return;}     // no changes made as oFlyer failed to meet requirements

    SetHideInt(oFlyer, "nCEP_Phenotype_C", nPhenotype_C); // how we'll get the PC back
}

void pl_Fly_Land(object oFlyer){
    if (GetObjectType(oFlyer)!=OBJECT_TYPE_CREATURE){return;}
    if (GetIsObjectValid(oFlyer)==FALSE) {return;}

    int nAppearance = GetAppearanceType(oFlyer), nBool = FALSE, nAppearance2, nPhenotype = GetPhenoType(oFlyer);
    object oItem;

    if (nAppearance == APPEARANCE_TYPE_INVALID){return;}

    if (nPhenotype > nMAX_PHENOTYPE_ALLOWED){
        if (nPhenotype > nMAX_PHENOTYPE_STANDARD){SetPhenoType(2,oFlyer);}
        else {SetPhenoType(0, oFlyer);}
    }

    DeleteHideInt(oFlyer,"nCEP_Phenotype_C");
}

int PLGetLevelByClass(int nClassType, object oCreature=OBJECT_SELF){
    if(nClassType < 255)
        return GetLevelByClassIncludingLL(nClassType, oCreature);

    switch(nClassType){
        case CLASS_TYPE_BARD_GROUP:
            return GetLevelByClass(CLASS_TYPE_BARD, oCreature) +
                   GetLevelByClass(CLASS_TYPE_HARPER, oCreature);
        case CLASS_TYPE_DRUID_GROUP:
            return GetLevelByClass(CLASS_TYPE_DRUID, oCreature) +
                   GetLevelByClass(CLASS_TYPE_SHIFTER, oCreature);
        case CLASS_TYPE_FIGHTER_GROUP:
            return GetLevelByClass(CLASS_TYPE_FIGHTER, oCreature) +
                   GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oCreature) +
                   GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oCreature) +
                   GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER, oCreature) +
                   GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oCreature) +
                   GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oCreature) +
                   GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCreature);
        case CLASS_TYPE_MAGE_GROUP:
            return GetLevelByClass(CLASS_TYPE_WIZARD, oCreature) +
                   GetLevelByClass(CLASS_TYPE_PALEMASTER, oCreature) +
                   GetLevelByClass(CLASS_TYPE_SORCERER, oCreature);
        case CLASS_TYPE_ROGUE_GROUP:
            return GetLevelByClass(CLASS_TYPE_ROGUE, oCreature) +
                   GetLevelByClass(CLASS_TYPE_ASSASSIN, oCreature) +
                   GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oCreature);
    }
    return 0;
}

void Raise(object oPlayer){

    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);

    effect eBad = GetFirstEffect(oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(), oPlayer);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPlayer)), oPlayer);

    //Search for negative effects
    while(GetIsEffectValid(eBad)){
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
        GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
        GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
        GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
        GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL){
            //Remove effect if it is negative.
            RemoveEffect(oPlayer, eBad);
        }
        eBad = GetNextEffect(oPlayer);
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oPlayer, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oPlayer);
}

string GetPlayerId(object oPC) {
    return GetLocalString(oPC, "pc_player_id");
}

string GetCharacterId(object oPC) {
    return GetLocalString(oPC, "pc_character_id");
}

void SendAllMessage(string sMessage, float fDelay = 0.0){
    object oStorage = GetFirstPC();
    while(oStorage != OBJECT_INVALID){
        SendPCMessage(oStorage, sMessage, fDelay);
        oStorage = GetNextPC();
    }
}

void SendAreaMessage(object oArea, string sMessage, float fDelay = 0.0){

    object oFirst = GetFirstObjectInArea(oArea), oStorage;
    int i = 1;

    if(GetIsPC(oFirst))
        SendPCMessage(oFirst, sMessage, fDelay);

    oStorage = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,oFirst, i);
    while(oStorage != OBJECT_INVALID){
        SendPCMessage(oStorage, sMessage, fDelay);
        i++;
        oStorage = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,oFirst, i);
    }
}

void SendChatLogMessage(object oRecipient, string sMessage, object oSender = OBJECT_INVALID, int nChannel = 4){
    if (!GetIsObjectValid(oSender)) return;
    if (FindSubString(sMessage, "¬")!=-1) return;
    if (nChannel == 4 && !GetIsObjectValid(oRecipient)) return;
    SetLocalString(oSender, "NWNX!CHAT!SPEAK", ObjectToString(oSender)+"¬"+ObjectToString(oRecipient)+"¬"+IntToString(nChannel)+"¬"+sMessage);
}

void SendPartyMessage(object oRecipient, string sMessage, float fDelay = 0.0){
    object oStorage = GetFirstFactionMember(oRecipient, TRUE);
    while(oStorage != OBJECT_INVALID){
        SendPCMessage(oRecipient, sMessage, fDelay);
        oStorage = GetNextFactionMember(oRecipient, TRUE);
    }
}

void SendPCMessage(object oRecipient, string sMessage, float fDelay = 0.0){
    DelayCommand(fDelay, SendSystemMessage(oRecipient, sMessage));
}

void SendServerMessage(object oSender, string sMessage){
    if (!GetIsObjectValid(oSender)) return;
    if (FindSubString(sMessage, "¬")!=-1) return;

    object oRecipient = GetFirstPC();
    while(oRecipient != OBJECT_INVALID){
        SetLocalString(oSender, "NWNX!CHAT!SPEAK", ObjectToString(oSender)+"¬"+ObjectToString(oRecipient)+"¬5¬"+sMessage);
        oRecipient = GetNextPC();
    }
}
void SendSystemMessage(object oRecipient, string sMessage, object oSender = OBJECT_INVALID){
    if (!GetIsObjectValid(oSender)) oSender = oRecipient;
    if (FindSubString(sMessage, "¬")!=-1) return;

    SetLocalString(oSender, "NWNX!CHAT!SPEAK", ObjectToString(oSender)+"¬"+ObjectToString(oRecipient)+"¬5¬"+sMessage);
}

int TakeItemByTag(object oPC, string sTag, int nAmount = 0){
    int nCount, nStackSize;

    object oItem = GetFirstItemInInventory(oPC);

    if(nAmount == 0){ // Delete all.
        while(GetIsObjectValid(oItem)){
            if(GetTag(oItem) == sTag){
                nCount += GetNumStackedItems(oItem);
                DestroyObject(oItem, 0.2f);
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }
    else{
        while(GetIsObjectValid(oItem) && nAmount > 0){
            if(GetTag(oItem) == sTag){
                nStackSize = GetNumStackedItems(oItem);
                if(nStackSize > nAmount){
                    SetItemStackSize(oItem, nStackSize - nAmount);
                    nCount += nAmount;
                    nAmount = 0;
                    break;
                }
                else {
                    nCount += nStackSize;
                    nAmount -= nStackSize;
                    DestroyObject(oItem, 0.2f);
                }
            }
            oItem = GetNextItemInInventory(oPC);
        }
    }
    return nCount;
}

int GetSaveCheckResult (int nSave, object oUser, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, int bFeedback=TRUE, int bAuto=TRUE, object oVersus=OBJECT_SELF, float fDelay=0.0);

int GetSaveCheckResult (int nSave, object oUser, int nDC,
                        int nSaveType=SAVING_THROW_TYPE_NONE, int bFeedback=TRUE,
                        int bAuto=TRUE, object oVersus=OBJECT_SELF, float fDelay=0.0) {
    int nReturn, nBonus;
    int nRoll = d20();
    string sSign, sSave;
    if (GetObjectType(oUser) == OBJECT_TYPE_CREATURE && bAuto) {
        switch (nSave) {
            case SAVING_THROW_FORT:   return FortitudeSave(oUser, nDC, nSaveType, oVersus);
            case SAVING_THROW_REFLEX: return ReflexSave(oUser, nDC, nSaveType, oVersus);
            case SAVING_THROW_WILL:   return WillSave(oUser, nDC, nSaveType, oVersus);
        }
        return 1;
    }
    switch (nSave) {
        case SAVING_THROW_FORT:
            sSave  = "Fortitude Save";
            nBonus = GetFortitudeSavingThrow(oUser);
            break;
        case SAVING_THROW_REFLEX:
            sSave  = "Reflex Save";
            nBonus = GetReflexSavingThrow(oUser);
            break;
        case SAVING_THROW_WILL:
            sSave  = "Will Save";
            nBonus = GetWillSavingThrow(oUser);
            break;
        default:
            return 1;
    }
    if (nBonus >= 0)
        sSign = " + ";
    else
        sSign = " - ";
    string sSuccess;
    if ((nBonus + 20) < nDC && bAuto <= 0) {
        sSuccess = "*success not possible*";
        nReturn = 0;
    } else if (bAuto > 0 && nRoll == 20) {
        sSuccess = "*automatic success*";
        nReturn = 2;
    } else if (bAuto > 0 && nRoll == 1) {
        sSuccess = "*automatic failure*";
        nReturn = -1;
    } else if ((nBonus + nRoll) < nDC) {
        sSuccess = "*failure*";
        nReturn = 0;
    } else {
        sSuccess = "*success*";
        nReturn = 1;
    }

    if (bAuto < 0 && nReturn > 0)
        nReturn = 1 + ((nBonus + nRoll) - nDC);
    if (bFeedback) {
        int bUserBrief = FALSE;
        string sVersus, sMessage;
        if (GetIsObjectValid(oVersus) && GetIsPC(oVersus) && oVersus != oUser) {
            int bVersusBrief = FALSE;
            sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
                " : " + sSave + " : " + sSuccess + " : (" + IntToString(nRoll) + sSign +
                IntToString(abs(nBonus)) + " = " + IntToString(nRoll + nBonus) +
                (bVersusBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
            DelayCommand(fDelay, SendPCMessage(oVersus, sMessage));
        }
        sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
            " : " + sSave + " : " + sSuccess + " : (" + IntToString(nRoll) + sSign +
            IntToString(abs(nBonus)) + " = " + IntToString(nRoll + nBonus) +
            (bUserBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
        DelayCommand(fDelay, SendPCMessage(oUser, sMessage));
    }
    if (GetLocalInt(oUser, "DebugChecks"))
        SendMessageToPC(oUser, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Save: " + sSave +
            ", Bonus: " + IntToString(nBonus) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    if (oVersus != oUser && GetLocalInt(oVersus, "DebugChecks"))
        SendMessageToPC(oVersus, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Save: " + sSave +
            ", Bonus: " + IntToString(nBonus) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    return nReturn;
}


int GetAbilityCheckResult (int nAbility, object oUser, int nDC, int bFeedback=TRUE,
                           int bAuto=FALSE, object oVersus=OBJECT_SELF, float fDelay=0.0, int nBonus=0) {
    int i, nReturn, nFeat;
    int nScore = GetAbilityScore(oUser, nAbility) + nBonus;
    int nRoll = d20();
    string sSuccess;
    switch (nAbility) {
        case ABILITY_STRENGTH:     nFeat = 3010; break;
        case ABILITY_DEXTERITY:    nFeat = 3015; break;
        case ABILITY_CONSTITUTION: nFeat = 3020; break;
        case ABILITY_INTELLIGENCE: nFeat = 3025; break;
        case ABILITY_WISDOM:       nFeat = 3030; break;
        case ABILITY_CHARISMA:     nFeat = 3035; break;
        default:                   nFeat = -5;
    }
    for (i = 4; i >= 0; i--) {
        if (GetHasFeat(nFeat + i, oUser)) {
            nScore += (i + 1) * 2;
            break;
        }
    }
    if ((nScore + 20) < nDC && !bAuto) {
        sSuccess = "*success not possible*";
        nReturn = 0;
    } else if (bAuto == 1 && nRoll == 20) {
        sSuccess = "*automatic success*";
        nReturn = 2;
    } else if (bAuto == 2 && nRoll == 1 && nScore - nBonus < nDC - 1) {
        sSuccess = "*automatic failure";
        nReturn = 0;
    } else if (bAuto == 1 && nRoll == 1) {
        sSuccess = "*critical failure*";
        nReturn = -1;
    } else if ((nScore + nRoll) < nDC) {
        sSuccess = "*failure*";
        nReturn = 0;
    } else {
        sSuccess = "*success*";
        nReturn = 1;
    }
    if (bFeedback) {
        int bUserBrief = FALSE;
        string sVersus, sMessage;
        if (GetIsObjectValid(oVersus) && oVersus != oUser) {
            if (GetIsPC(oVersus)) {
                int bVersusBrief = FALSE;
                sVersus = GetAbilityName(nAbility, bVersusBrief) + " vs. " + GetName(oVersus);
                sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
                    " : " + sVersus + " : " + sSuccess + " : (" + IntToString(nRoll) +
                    " + " + IntToString(nScore) + " = " + IntToString(nRoll + nScore) +
                    (bVersusBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
                DelayCommand(fDelay, SendPCMessage(oVersus, sMessage));
            }
            sVersus = GetAbilityName(nAbility, bUserBrief) + " vs. " + GetName(oVersus);
        } else
            sVersus = GetAbilityName(nAbility, bUserBrief);
        sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
            " : " + sVersus + " : " + sSuccess + " : (" + IntToString(nRoll) +
            " + " + IntToString(nScore) + " = " + IntToString(nRoll + nScore) +
            (bUserBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
        DelayCommand(fDelay, SendPCMessage(oUser, sMessage));
    }
    if (GetLocalInt(oUser, "DebugChecks"))
        SendMessageToPC(oUser, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Ability: " + GetAbilityName(nAbility) +
            ", Score: " + IntToString(nScore) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    if (oVersus != oUser && GetLocalInt(oVersus, "DebugChecks"))
        SendMessageToPC(oVersus, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Ability: " + GetAbilityName(nAbility) +
            ", Score: " + IntToString(nScore) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    return nReturn;
}

int GetSkillCheckResult (int nSkill, object oUser, int nDC, int bFeedback=TRUE,
                         int bAuto=FALSE, object oVersus=OBJECT_SELF, float fDelay=0.0,
                         int nTake=0, int nBonus=0) {
    int nReturn;
    int nRank = GetSkillRank(nSkill, oUser) + nBonus;
    int nRoll = (nTake > 0 ? nTake : d20());
    string sSign;
    if (nRank >= 0)
        sSign = " + ";
    else
        sSign = " - ";
    string sSuccess;
    if ((nRank + 20) < nDC && bAuto <= 0) {
        sSuccess = "*success not possible*";
        nReturn = 0;
    } else if (bAuto == 1 && nRoll == 20) {
        sSuccess = "*automatic success*";
        nReturn = 2;
    } else if (bAuto == 2 && nRoll == 1 && nRank - nBonus < nDC - 1) {
        sSuccess = "*automatic failure";
        nReturn = 0;
    } else if (bAuto == 1 && nRoll == 1) {
        sSuccess = "*critical failure*";
        nReturn = -1;
    } else if ((nRank + nRoll) < nDC) {
        sSuccess = "*failure*";
        nReturn = 0;
    } else {
        sSuccess = "*success*";
        nReturn = 1;
    }
    if (bAuto < 0 && nReturn > 0)
        nReturn = 1 + ((nRank + nRoll) - nDC);
    if (bFeedback) {
        int bUserBrief = FALSE;
        string sVersus, sMessage;
        if (GetIsObjectValid(oVersus) && oVersus != oUser) {
            if (GetIsPC(oVersus)) {
                int bVersusBrief = FALSE;
                sVersus = GetSkillName(nSkill, bVersusBrief) + " vs. " + GetName(oVersus);
                sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
                    " : " + sVersus + " : " + sSuccess + " : (" + IntToString(nRoll) +
                    sSign + IntToString(abs(nRank)) + " = " + IntToString(nRoll + nRank) +
                    (bVersusBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
                DelayCommand(fDelay, SendPCMessage(oVersus, sMessage));
            }
            sVersus = GetSkillName(nSkill, bUserBrief) + " vs. " + GetName(oVersus);
        } else
            sVersus = GetSkillName(nSkill, bUserBrief);
        sMessage = C_LT_PURPLE + GetName(oUser) + C_PURPLE +
            " : " + sVersus + " : " + sSuccess + " : (" + IntToString(nRoll) +
            sSign + IntToString(abs(nRank)) + " = " + IntToString(nRoll + nRank) +
            (bUserBrief ? " / " : " vs. DC: ") + IntToString(nDC) + ")</c>";
        DelayCommand(fDelay, SendPCMessage(oUser, sMessage));
    }
    if (GetLocalInt(oUser, "DebugChecks"))
        SendMessageToPC(oUser, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Skill: " + GetSkillName(nSkill) +
            ", Rank: " + IntToString(nRank) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    if (oVersus != oUser && GetLocalInt(oVersus, "DebugChecks"))
        SendMessageToPC(oVersus, "<cþþþ>User: " + GetName(oUser) +
            ", Versus: " + GetName(oVersus) +
            ", Skill: " + GetSkillName(nSkill) +
            ", Rank: " + IntToString(nRank) +
            ", Roll: " + IntToString(nRoll) +
            ", DC: " + IntToString(nDC) +
            ", Auto: " + IntToString(bAuto) +
            "</c>");
    return nReturn;
}


int GetRaceFromFavoredEnemyFeat(int nFeat);
int GetRaceFromFavoredEnemyFeat(int nFeat){
    switch(nFeat)
    {
        case FEAT_FAVORED_ENEMY_DWARF:          return RACIAL_TYPE_DWARF;
        case FEAT_FAVORED_ENEMY_ELF:            return RACIAL_TYPE_ELF;
        case FEAT_FAVORED_ENEMY_GNOME:          return RACIAL_TYPE_GNOME;
        case FEAT_FAVORED_ENEMY_HALFLING:       return RACIAL_TYPE_HALFLING;
        case FEAT_FAVORED_ENEMY_HALFELF:        return RACIAL_TYPE_HALFELF;
        case FEAT_FAVORED_ENEMY_HALFORC:        return RACIAL_TYPE_HALFORC;
        case FEAT_FAVORED_ENEMY_HUMAN:          return RACIAL_TYPE_HUMAN;
        case FEAT_FAVORED_ENEMY_ABERRATION:     return RACIAL_TYPE_ABERRATION;
        case FEAT_FAVORED_ENEMY_ANIMAL:         return RACIAL_TYPE_ANIMAL;
        case FEAT_FAVORED_ENEMY_BEAST:          return RACIAL_TYPE_BEAST;
        case FEAT_FAVORED_ENEMY_CONSTRUCT:      return RACIAL_TYPE_CONSTRUCT;
        case FEAT_FAVORED_ENEMY_DRAGON:         return RACIAL_TYPE_DRAGON;
        case FEAT_FAVORED_ENEMY_GOBLINOID:      return RACIAL_TYPE_HUMANOID_GOBLINOID;
        case FEAT_FAVORED_ENEMY_MONSTROUS:      return RACIAL_TYPE_HUMANOID_MONSTROUS;
        case FEAT_FAVORED_ENEMY_ORC:            return RACIAL_TYPE_HUMANOID_ORC;
        case FEAT_FAVORED_ENEMY_REPTILIAN:      return RACIAL_TYPE_HUMANOID_REPTILIAN;
        case FEAT_FAVORED_ENEMY_ELEMENTAL:      return RACIAL_TYPE_ELEMENTAL;
        case FEAT_FAVORED_ENEMY_FEY:            return RACIAL_TYPE_FEY;
        case FEAT_FAVORED_ENEMY_GIANT:          return RACIAL_TYPE_GIANT;
        case FEAT_FAVORED_ENEMY_MAGICAL_BEAST:  return RACIAL_TYPE_MAGICAL_BEAST;
        case FEAT_FAVORED_ENEMY_OUTSIDER:       return RACIAL_TYPE_OUTSIDER;
        case FEAT_FAVORED_ENEMY_SHAPECHANGER:   return RACIAL_TYPE_SHAPECHANGER;
        case FEAT_FAVORED_ENEMY_UNDEAD:         return RACIAL_TYPE_UNDEAD;
        case FEAT_FAVORED_ENEMY_VERMIN:         return RACIAL_TYPE_VERMIN;
    }

    return -1;
}
void LoadFavoredEnemies(object oPC);

void LoadFavoredEnemies(object oPC){
    int i;
    int nEnemy;
    for(i = 261; i <= 286; i++){
        if(GetHasFeat(i, oPC)){
            nEnemy = GetRaceFromFavoredEnemyFeat(i);
            if(nEnemy != -1)
                SetLocalInt(oPC, "FE_" + IntToString(nEnemy), TRUE);
        }
    }
}



int GetNextUnknownFeat(int nFeat, object oPC){
    int last;
    switch(nFeat){
        case FEAT_EPIC_GREAT_SMITING_1:
            last = FEAT_EPIC_GREAT_SMITING_10;
        break;
        case FEAT_EPIC_ENERGY_RESISTANCE_COLD_1:
            last = FEAT_EPIC_ENERGY_RESISTANCE_COLD_10;
        break;
        case FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1:
            last = FEAT_EPIC_ENERGY_RESISTANCE_FIRE_10;
        break;
        case FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1:
            last = FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_10;
        break;
        case FEAT_EPIC_ENERGY_RESISTANCE_ACID_1:
            last = FEAT_EPIC_ENERGY_RESISTANCE_ACID_10;
        break;
        case FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1:
            last = FEAT_EPIC_ENERGY_RESISTANCE_SONIC_10;
        break;
        case FEAT_EPIC_AUTOMATIC_STILL_SPELL_1:
            last = FEAT_EPIC_AUTOMATIC_STILL_SPELL_3;
        break;
    }

    for(; nFeat <= last; nFeat++)
        if(!GetKnowsFeat(nFeat, oPC))
            return nFeat;

    return -1;
}

void ErrorMessage(object oPC, string sMsg);
void ErrorMessage(object oPC, string sMsg){
    SendChatLogMessage(oPC, C_RED+sMsg+C_RED, oPC, 5);
}

void SuccessMessage(object oPC, string sMsg);
void SuccessMessage(object oPC, string sMsg){
    SendChatLogMessage(oPC, C_GREEN+sMsg+C_RED, oPC, 5);
}

int Delevel(object oPC, int nLevels){
    if(!GetIsRelevelable(oPC)){
        ErrorMessage(oPC, "If you have Legendary Levels, Pale Master, or RDD levels you are unable to relevel." +
        " You must delete your character and use the xp bank.  The chat commands are !delete and !xpbank.");
        return GetHitDice(oPC);
    }

	ForceRest(oPC);

    int nHD = GetHitDice(oPC), i;

    if( nHD - nLevels < 1)
        nLevels = nHD - 1;

    for (i = 0; i < nLevels; i++){
        ExecuteScript("pl_leveldown", oPC);
        LevelDown(oPC);
    }

    return GetHitDice(oPC);
}

void SavePersistentState(object pc) {
    string pid = GetLocalString(pc, "pc_player_id");
    string cid = GetLocalString(pc, "pc_character_id");

    if (GetStringLength(pid) == 0 || GetStringLength(cid) == 0 ) {
        return;
    }

    string sql;
    string gold = GetLocalString(pc, "pc_gold");
    if (GetStringLength(gold) == 0) { gold = "0"; }
    sql = "UPDATE nwn.players SET "
        + "gold = " +  gold + ", "
        + "xp = " + IntToString(GetLocalInt(pc, VAR_PC_XP_BANK)) + ", "
        + "bosskills = " + IntToString(GetLocalInt(pc, "pc_boss_kills_g")) + ", "
        + "guild = " + IntToString(GetLocalInt(pc, VAR_PC_GUILD)) + ", "
        + "enhanced = " + IntToString(GetLocalInt(pc, "pc_enhanced")) + ", "
        + "hak = " + IntToString(GetLocalInt(pc, VAR_PC_GUILD)) + ", "
        + "kills = " + IntToString(GetLocalInt(pc, "pc_kills_g")) + " "
        + "WHERE id="+pid;
    SQLExecDirect(sql);

    sql = "UPDATE nwn.characters SET "
        + "version = " + IntToString(GetLocalInt(pc, "pc_version")) + ", "
        + "bosskills = " + IntToString(GetLocalInt(pc, "pc_boss_kills")) + ", "
        + "fighting_style = " + IntToString(GetLocalInt(pc, "pc_style")) + ", "
        + "kills = " + IntToString(GetLocalInt(pc, "pc_kills")) + ", "
        + "no_relevel = '" + IntToString(GetLocalInt(pc, VAR_PC_NO_RELEVEL)) + "' "
        + "WHERE id="+cid;
    SQLExecDirect(sql);

}

void LoadPersistentState(object pc) {
    string tag = GetTag(pc);
    int len = GetStringLength(tag);
    if (len == 0) {
        SetLocalInt(pc, "NewChar", TRUE);
        ExecuteScript("pl_setup_pc", pc);
        tag = GetTag(pc);
        len = GetStringLength(tag);
    }
    int us = FindSubString(tag, "_");
    if (us == -1) { return; }

    string pid = GetSubString(tag, 0, us);
    string cid = GetSubString(tag, us+1, len);

    SetLocalString(pc, "pc_player_id", pid);
    SetLocalString(pc, "pc_character_id", cid);
    SetLocalInt(pc, "pc_is_pc", GetIsPC(pc));
    SetLocalInt(pc, "pc_is_dm", GetIsDM(pc));

    string sql;

    sql = "SELECT bic, version, bosskills, fighting_style, kills, no_relevel FROM nwn.characters WHERE id = " + cid;
    SQLExecDirect(sql);
    if(SQLFetch() == SQL_SUCCESS) {
        SetLocalString(pc, VAR_PC_BIC_FILE, SQLGetData(1));
        SetLocalInt(pc, "pc_version", StringToInt(SQLGetData(2)));
        SetLocalInt(pc, "pc_boss_kills", StringToInt(SQLGetData(3)));
        SetLocalInt(pc, "pc_style", StringToInt(SQLGetData(4)));
        SetLocalInt(pc, "pc_kills", StringToInt(SQLGetData(5)));
        SetLocalInt(pc, VAR_PC_NO_RELEVEL, StringToInt(SQLGetData(6)));
    }

    sql = "SELECT gold, xp, bosskills, kills, guild, enhanced, hak FROM nwn.players WHERE id = " + pid;
    SQLExecDirect(sql);
    if(SQLFetch() == SQL_SUCCESS) {
        SetLocalString(pc, "pc_gold", SQLGetData(1));
        SetLocalInt(pc, VAR_PC_XP_BANK, StringToInt(SQLGetData(2)));
        SetLocalInt(pc, "pc_boss_kills_g", StringToInt(SQLGetData(3)));
        SetLocalInt(pc, "pc_kills_g", StringToInt(SQLGetData(4)));
        SetLocalInt(pc, VAR_PC_GUILD, StringToInt(SQLGetData(5)));
        SetLocalInt(pc, "pc_enhanced", StringToInt(SQLGetData(6)));
        SetLocalInt(pc, "pc_hak_version", StringToInt(SQLGetData(7)));
    }

}