#include "gsp_func_inc"
#include "se_inc_resp_trap"
#include "inc_draw"
#include "pc_funcs_inc"
#include "spawn_functions"

struct AreaDamage{
    int nDamType, nDamDice, nDamSides, nDC, nDelay;
    string sSafetyItem;
};

////////////////////////////////////////////////////////////////////////////////
// PROTOTYPES
////////////////////////////////////////////////////////////////////////////////

// Area Damage

void AreaDoDamage(object oArea, object oTarget, struct AreaDamage ad);
void AreaDoUnderWater(object oPC, struct AreaDamage ad);
void AreaDoPoisoned(object oPC, struct AreaDamage ad);
void AreaDoLightning(object oArea, object oTarget, struct AreaDamage ad);
void AreaDoCursed(object oPC);
void AreaDoPositivePlane(object oArea, object oTarget, struct AreaDamage ad);
void AreaDoWildMagic(object oPC);

void AreaStartDamage(object oArea, object oTarget);

// Cleans area if there are no PCs in the area.
void AreaClean(object oArea, object oSource = OBJECT_INVALID);

//Traps - Sir Elric
void AreaRespawnTraps(object oArea);

// Activates all spawns in a given area.  If oSource is a specified a confirmation
// message will be sent.
void AreaSpawnsActivate(object oArea, object oSource = OBJECT_INVALID);
// Deactivates all spawns in a given area.  If oSource is a specified a confirmation
// message will be sent.
void AreaSpawnsDeactivate(object oArea, object oSource = OBJECT_INVALID);

// Activates loot generation in a given area.  If oSource is a specified a confirmation
// message will be sent.
void AreaLootActivate(object oArea, object oSource = OBJECT_INVALID);
// Deactivates loot generation in a given area.  If oSource is a specified a confirmation
// message will be sent.
void AreaLootDeactivate(object oArea, object oSource = OBJECT_INVALID);

//Checks to see if any players are currently in the area.
int AreaGetIsPlayerInArea(object oArea);

int AreaGetIsPlayerInArea(object oArea){
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC)){
        if(GetArea(oPC) == oArea)
            return TRUE;

        oPC = GetNextPC();
    }
    return FALSE;
}


int GetIsAreaClear (object oArea, object oPC);
int GetIsAreaClear (object oArea, object oPC) {
    object oMonster = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);
    return oMonster == OBJECT_INVALID;
}

int GetPercentEncountersSpawned(object oArea, object oPC);
int GetPercentEncountersSpawned(object oArea, object oPC){
    // TODO: Deal with scripted spawns.
    object oEnc;
    int nTotal, nInactive;
    float fPercent;

    for(oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, oPC, nTotal);
            oEnc != OBJECT_INVALID;
            oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, oPC, nTotal)){
        nTotal++;
        if(GetEncounterActive(oEnc))
            nInactive++;
    }

    //SendMessageToPC(oPC, "Total: " + IntToString(nTotal) + " Active: " + IntToString(nInactive));

    if(nTotal == 0)
        return 0;

    fPercent = (IntToFloat(nInactive) / IntToFloat(nTotal)) * 100.0f;

    return FloatToInt(fPercent);
}
////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////



void AreaRespawnLoot(object oArea){
    string sResref;
    int nCurrentTime = GetLocalInt(GetModule(), "MOD_RESET_TIMER");
    int nRespawnDelay = GetLocalInt(oArea, "area_reset_delay");
    int nLastUsed;

    if(nRespawnDelay == 0) nRespawnDelay = 10;

    if(GetLocalInt(oArea, "Cleaning")){
        DelayCommand(2.0, AreaRespawnLoot(oArea));
        return;
    }

    //TODO: Place minimum on delay.
    int i = 1;
    object oStorage = GetNearestObjectByTag("rlgs_info", GetEnteringObject(), i);
    while(oStorage != OBJECT_INVALID){
        nLastUsed = GetLocalInt(oStorage, "rlgs_used");
        if(nLastUsed != 0 && (nCurrentTime - nLastUsed) >= nRespawnDelay){
            DeleteLocalInt(oStorage, "rlgs_used");
            sResref = GetLocalString(oStorage, "rlgs_resref");
            if(sResref != "" && !GetLocalInt(oStorage, "rlgs_no_respawn")){
                DelayCommand(0.5, ObjectToVoid(CreateObject(OBJECT_TYPE_PLACEABLE, sResref, GetLocation(oStorage))));
            }
        }
        i++;
        oStorage = GetNearestObjectByTag("rlgs_info", GetEnteringObject(), i);
    }
}

void ApplyPlaceLocals(object oSelf, object oWay){

    effect eEff;
    int i;
    /* VFX */
    for (i = 1; i <= 3; i++) {
        int nVFX = GetLocalInt(oWay, "VFXDur" + IntToString(i));
        if (nVFX) {
            eEff = SupernaturalEffect(EffectVisualEffect(nVFX));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        } else
            break;
    }

    /* execute script on spawn - use for extensive custom behavior */
    string sScript = GetLocalString(oWay, "ES_Spawn");
    if (sScript != "")
        DelayCommand(0.5, ExecuteScript(sScript, oSelf));
}

void AreaSpawnPlaceables(object oArea){
    string sResref;
    int nRadius, nFreq;
    if(GetLocalInt(oArea, "Cleaning")){
        DelayCommand(1.0, AreaSpawnPlaceables(oArea));
        return;
    }

    int i = 1;
    object oStorage = GetNearestObjectByTag("spawn_place", GetEnteringObject(), i), oSpawn;
    while(oStorage != OBJECT_INVALID){
        sResref = GetLocalString(oStorage, "Resref");
        if(sResref != ""){
            oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE, sResref, GetLocation(oStorage), FALSE, "Spawned");
            if(GetIsObjectValid(oSpawn))
                ApplyPlaceLocals(oSpawn, oStorage);
        }
        i++;
        oStorage = GetNearestObjectByTag("spawn_place", GetEnteringObject(), i);
    }
}

void AreaRespawnTraps(object oArea){
   int bValid;
//   object oPC = GetEnteringObject();
//   if(GetIsObjectValid(oPC) == FALSE)
//   oPC = OBJECT_SELF;

//   SendMessageToPC(GetFirstPC(), "Traps");
//   object oArea = GetArea(oPC);

   if(GetLocalInt(oArea, "NO_TRAPS_TO_SET") == TRUE)
   {
      SE_Debug("[" + GetName(oArea) + "] Player has entered. No objects or doors are set for respawning traps in this area - return");
      return;
   }

   if(GetLocalInt(oArea, "TRAPS_SET") == FALSE)
   {
      object oObject = GetFirstObjectInArea();
      while(GetIsObjectValid(oObject))
      {
         if(GetLocalInt(oObject, "TRAP_ALWAYS") == TRUE)
         {
            bValid = TRUE;
            ExecuteScript("se_respawn_trap", oObject);
         }
         else if(SE_GetIsASpawnerObject(oObject))
         {
            bValid = TRUE;
            DelayCommand(0.5, ExecuteScript("se_respawn_trap", oObject));
         }
         oObject = GetNextObjectInArea();
      }

      if(bValid == TRUE)
      {
         SetLocalInt(oArea, "TRAPS_SET", TRUE);
         SetLocalInt(oArea, "TRAP_RESPAWN_INITIATED", TRUE);
         // If optional area timer is not set use the default SE_AREA_TIMER
         float fTimer = GetLocalFloat(oArea, "TRAP_AREA_TIMER");
         if(fTimer == 0.0)
         {
            fTimer = SE_AREA_TIMER;

           SE_Debug("[" + GetName(oArea) + "] Optional area timer not set using the default "
               + FloatToString(SE_AREA_TIMER, 2, 0) + " seconds");
         }
         AssignCommand(oArea, DelayCommand(fTimer, DeleteLocalInt(oArea, "TRAPS_SET")));
         AssignCommand(oArea, DelayCommand(fTimer, DeleteLocalInt(oArea, "TRAP_RESPAWN_INITIATED")));
         SE_Debug("[" + GetName(oArea) + "] Player has entered setting traps");
      }
      else
      {
         SetLocalInt(oArea, "NO_TRAPS_TO_SET", TRUE);
         SE_Debug("[" + GetName(oArea) + "] Player has entered. No fsda objects ofdsfr doors are set for respawning traps in this area - return");
      }
   }
   else if(GetLocalInt(oArea, "TRAP_RESPAWN_INITIATED") == TRUE)
   {
       SE_Debug("[" + GetName(oArea) + "] Trap respawn timer already initiated");
   }
   else
   {
      SE_Debug("[" + GetName(oArea) + "] Player has entered. Respawn timer has not yet been initiated");
   }
}

void AreaClean(object oArea, object oSource = OBJECT_INVALID){

    object oTrash = GetFirstObjectInArea(oArea), oInvItem;
    int nDeletedNPC;

    // If a PC is the area don't clean it unless a DM sent the command.
    if(oSource == OBJECT_INVALID && AreaGetIsPlayerInArea(oArea)) return;

    DeleteLocalInt(oArea, "Populated");
    SetLocalInt(oArea, "LastCleaned", GetLocalInt(GetModule(), "MOD_RESET_TIMER"));

    // Exit if area is already in the process of being cleaned.
    if(GetLocalInt(oArea, "Cleaning")) return;

    if(GetLocalInt(GetModule(), "DEBUG")){
        WriteTimestampedLogEntry("Attempting to clean " + GetName(oArea));
    }

    SetLocalInt(oArea, "Cleaning", 1);

    while(GetIsObjectValid(oTrash)){
        string sTagPrefix = GetStringLeft(GetTag(oTrash), 15);

        // Clear remains, dropped items
        if(GetObjectType(oTrash) == OBJECT_TYPE_ITEM ||
           GetStringLowerCase(GetName(oTrash)) == "remains" ||
           GetTag(oTrash) == "rlgs_loot_bag")
        {
            AssignCommand(oTrash, SetIsDestroyable(TRUE));
            if (GetHasInventory(oTrash)) {
                oInvItem = GetFirstItemInInventory(oTrash);
                while(GetIsObjectValid(oInvItem)) {
                    DestroyObject(oInvItem, 0.0);
                    oInvItem = GetNextItemInInventory(oTrash);
                }
            }
            DestroyObject(oTrash, 0.4);
        }

        // Clear placeable inventories
        else if(GetObjectType(oTrash) == OBJECT_TYPE_PLACEABLE){
            if (CLEAN_PLACABLE_INV && GetHasInventory(oTrash)) {
                object oInvItem = GetFirstItemInInventory(oTrash);
                while(GetIsObjectValid(oInvItem)) {
                    DestroyObject(oInvItem,0.0);
                    oInvItem = GetNextItemInInventory(oTrash);
                }
            }
            else if(GetTag(oTrash) == "Spawned"){
                AssignCommand(oTrash, SetIsDestroyable(TRUE));
                DestroyObject(oTrash, 0.0);
            }
        }

        // Clear encounters
        else if (GetIsEncounterCreature(oTrash)){
            AssignCommand(oTrash, SetIsDestroyable(TRUE));
            DestroyObject(oTrash, 0.0);
        }
        else if(GetStringRight(GetTag(oTrash), 7) == "SDCLONE"){
            AssignCommand(oTrash, SetIsDestroyable(TRUE));
            DestroyObject(oTrash);
        }
        else if(GetTag(oTrash) == "Spawned"){
            AssignCommand(oTrash, SetIsDestroyable(TRUE));
            DestroyObject(oTrash);
        }
        else if(GetLocalInt(oTrash, "Despawn") > 0){
            AssignCommand(oTrash, SetIsDestroyable(TRUE));
            DestroyObject(oTrash);
        }
        if (GetTag(oTrash) == "PSC_B_ICOSAHEDRON" || GetTag(oTrash) == "PSC_B_DODECAHEDRON" ||
                GetTag(oTrash) == "PSC_B_TRIACONTAHEDRON" || GetTag(oTrash) == "PSC_X_TEXTMESSAGE")
            GroupDestroyObject(oTrash);
        oTrash = GetNextObjectInArea(oArea);
    }

    // Reactivate encounters.
    if(GetLocalInt(oArea, "area_reset_spawns"))
        AreaSpawnsActivate(oArea);

    // Dynamic Monster system
    DeleteLocalInt(oArea, "area_highest_ac");
    DeleteLocalInt(oArea, "area_highest_ab");

    DeleteLocalInt(oArea, "Cleaning");

} // void CleanArea(object oArea)

void AreaSpawnsActivate(object oArea, object oSource = OBJECT_INVALID){

    object oEnc = GetFirstObjectInArea(oArea);
    while(oEnc != OBJECT_INVALID){
        if(GetObjectType(oEnc) == OBJECT_TYPE_ENCOUNTER){
            SetEncounterActive(TRUE, oEnc);
        }
        oEnc = GetNextObjectInArea(oArea);
    }

    if(oSource != OBJECT_INVALID){
        FloatingTextStringOnCreature(C_RED+"All encounters in " + GetName(oArea) + " have been activated."+C_END, oSource);
    }
}

void AreaSpawnsDeactivate(object oArea, object oSource = OBJECT_INVALID){

    object oEnc = GetFirstObjectInArea(oArea);
    while(oEnc != OBJECT_INVALID){
        if(GetObjectType(oEnc) == OBJECT_TYPE_ENCOUNTER){
            SetEncounterActive(FALSE, oEnc);
        }
        oEnc = GetNextObjectInArea(oArea);
    }

    if(oSource != OBJECT_INVALID){
        FloatingTextStringOnCreature(C_RED+"All encounters in " + GetName(oArea) + " have been deactivated."+C_END, oSource);
    }
}

void AreaLootActivate(object oArea, object oSource = OBJECT_INVALID){

    DeleteLocalInt(oArea, VAR_AREA_NO_LOOT);

    if(oSource != OBJECT_INVALID){
        FloatingTextStringOnCreature(C_RED+"Loot generation in " + GetName(oArea) + " has been activated."+C_END, oSource);
    }
}

void AreaLootDeactivate(object oArea, object oSource = OBJECT_INVALID){

    SetLocalInt(oArea, VAR_AREA_NO_LOOT, TRUE);

    if(oSource != OBJECT_INVALID){
        FloatingTextStringOnCreature(C_RED+"Loot generation in " + GetName(oArea) + " has been deactivated."+C_END, oSource);
    }
}

int GetAreaDamageType(int nDamType){
    switch(nDamType){
        case 1:  return DAMAGE_TYPE_ACID;
        case 2:  return DAMAGE_TYPE_COLD;
        case 3:  return DAMAGE_TYPE_ELECTRICAL;
        case 4:  return DAMAGE_TYPE_FIRE;
        case 5:  return DAMAGE_TYPE_SONIC;
        case 6:  return DAMAGE_TYPE_DIVINE;
        case 7:  return DAMAGE_TYPE_MAGICAL;
        case 8:  return DAMAGE_TYPE_NEGATIVE;
        case 9:  return DAMAGE_TYPE_POSITIVE;
        case 10: return DAMAGE_TYPE_BLUDGEONING;
        case 11: return DAMAGE_TYPE_PIERCING;
        case 12: return DAMAGE_TYPE_SLASHING;
    }
    return -1;
}

struct AreaDamage GetAreaDamage(object oArea){
    struct AreaDamage ad;

    ad.nDamType = GetAreaDamageType(GetLocalInt(oArea, VAR_AREA_DMG));
    ad.nDamDice = GetLocalInt(oArea, VAR_AREA_DMG_DICE);
    ad.nDamSides = GetLocalInt(oArea, VAR_AREA_DMG_SIDES);
    ad.nDamSides = (ad.nDamSides == 0) ? 6 : ad.nDamSides;
    ad.nDC = GetLocalInt(oArea, VAR_AREA_DMG_DC);
    ad.sSafetyItem = GetLocalString(oArea, VAR_AREA_DMG_ITEM);
    ad.nDelay = GetLocalInt(oArea, VAR_AREA_DMG_DELAY);
    if(ad.nDelay == 0) ad.nDelay = 1;

    //Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_NONE, "

    return ad;
}

void AreaDoDamage(object oArea, object oTarget, struct AreaDamage ad){

    effect eDamage, eImpact;
    int nSaveType, nDamage;
    float fDelay;

    if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != oArea)
        return;

    DelayCommand(RoundsToSeconds(ad.nDelay), AreaDoDamage(oArea, oTarget, ad));

    if(!GetIsDead(oTarget) && (ad.sSafetyItem == "" || !GetIsEquippedByTag(oTarget, ad.sSafetyItem))){ //Do damage unless Target is dead or has safety item

        nDamage = RollDice(ad.nDamDice, ad.nDamSides);

        if(ad.nDC > 0){
            nSaveType = GetSaveType(ad.nDamType);
            if (FortitudeSave(oTarget, ad.nDC, nSaveType))
                nDamage /=  2;
        }

        eDamage = EffectDamage(nDamage, ad.nDamType);
        fDelay = GetRandomDelay();
        Logger(oTarget, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Attempting to Damage: %s", IntToString(nDamage));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
    }
}


void AreaStartDamage(object oArea, object oTarget){
    string sError;
    int nDamageType = GetLocalInt(oArea, VAR_AREA_DMG);
    struct AreaDamage ad;

    // Skip Non PCs and DMs
    if(!GetIsPC(oTarget)) return;
    if(GetIsDM(oTarget) || GetIsDMPossessed(oTarget)) return;

    if(nDamageType > 0 && nDamageType < 13){
        ad = GetAreaDamage(oArea);
        AreaDoDamage(oArea, oTarget, ad);
        Logger(oTarget, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Starting Area Damage");
    }
    else if(nDamageType == 13){
        // If someone logged underwater we need to restart.
        if(GetLocalInt(GetModule(), "WATER_LOG_" + GetTag(oTarget))){
            DeleteLocalInt(GetModule(), "WATER_LOG_" + GetTag(oTarget));
        }
        // if we're already underwater don't start this.
        else if(GetLocalInt(oTarget, "UnderWater"))
            return;

        // Torch goes out underwater
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        if(GetBaseItemType(oItem) == BASE_ITEM_TORCH){
            DelayCommand(1.0, FloatingTextStringOnCreature("Your torch fizzles out.", oTarget, FALSE));
            DelayCommand(1.0, AssignCommand(oTarget, ActionUnequipItem(oItem)));
        }


        // Set up drowning control Ints and Safty item.
        ad.nDC = 15;
        ad.sSafetyItem = "pl_water_helm";

        // Start checking for holding of breath and damage
        DelayCommand(0.1, FloatingTextStringOnCreature("** This water is deep! **", oTarget, FALSE));
        SetLocalInt(oTarget, "UnderWater", TRUE);
        DelayCommand(0.5, AreaDoUnderWater(oTarget, ad));


    }
    else if(nDamageType == 14){
    }
    else if(nDamageType == 15){ // Poisoned
        ad = GetAreaDamage(oArea);
        ad.nDamType = DAMAGE_TYPE_ACID;
        // Set up acid burn controls
        SetLocalInt(oTarget, "ACID", 1);
        // Tell the PC they are in acid so they can panic
        DelayCommand(0.1, SendMessageToPC(oTarget,"** Acid fumes fill the air! **"));
        // Start checking for acid burn damage and inhalation secondary damage
        DelayCommand(0.5, AreaDoPoisoned(oTarget,ad));
    }
    else if(nDamageType == 16){
    }
    else if(nDamageType == 17){
        ad = GetAreaDamage(oArea);
        AreaDoPositivePlane(oArea, oTarget, ad);
    }
    else if(nDamageType == 18){ // Storm
        ad = GetAreaDamage(oArea);
        ad.nDamType = DAMAGE_TYPE_ELECTRICAL;
        AreaDoLightning(oArea, oTarget, ad);
    }
    else{
        sError = Logger(oTarget, VAR_DEBUG_LOGS, LOGLEVEL_ERROR, "AREA : %s, %s : Invalid Area damage type.",
                        GetName(oArea), GetTag(oArea));
        SendMessageToAllDMs(sError);
    }

    Logger(oTarget, VAR_DEBUG_AREAS, LOGLEVEL_DEBUG, "Area: %s, Player: %s, Type: %s, DC: %s, Safety Item: %s",
        GetName(oArea), GetName(oTarget), IntToString(nDamageType), IntToString(ad.nDC), ad.sSafetyItem);
}


////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
void AreaDoPoisoned(object oPC, struct AreaDamage ad){

    effect eDamage, eImpact;
    int nSaveType, nDamage;
    float fDelay;

    if(!GetIsObjectValid(oPC)) return;

    if(GetLocalInt(GetArea(oPC), VAR_AREA_DMG) != 13 || GetIsDead(oPC)){ // Exited

    }

    DelayCommand(RoundsToSeconds(ad.nDelay), AreaDoPoisoned(oPC, ad));
    if(GetIsEquippedByTag(oPC, ad.sSafetyItem)) return;

    SendMessageToPC(oPC,"** Your flesh is burning due to the acid **");

    nDamage = RollDice(ad.nDamDice, ad.nDamSides);

    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ACID, 20);
    effect eDazed = EffectDazed();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oPC, 30.0);

    if (GetLocalInt(oPC,"Acidburn")==1){
        if (FortitudeSave(oPC, ad.nDC, SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(OBJECT_SELF)) ==0){
            effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION,d4());
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,eCon,oPC);
            SetLocalInt(oPC,"Acidburn",2);
        }
    }
    if(GetLocalInt(oPC,"Acidburn") == 0){
        if (FortitudeSave(oPC, ad.nDC, SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(OBJECT_SELF)) ==0){
            effect eMov=EffectMovementSpeedDecrease(20);
            effect eCon=EffectAbilityDecrease(ABILITY_CONSTITUTION,1);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMov,oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,eCon,oPC);
            SetLocalInt(oPC,"Acidburn",1);
        }
    }
}

void AreaDoLightning(object oArea, object oTarget, struct AreaDamage ad){
    effect eDamage, eImpact = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    int nSaveType, nDamage;
    float fDelay;

    if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != oArea)
        return;

    DelayCommand(RoundsToSeconds(ad.nDelay), AreaDoLightning(oArea, oTarget, ad));

    if(!GetIsDead(oTarget) && (ad.sSafetyItem == "" || !GetIsEquippedByTag(oTarget, ad.sSafetyItem)))
    { //Do damage unless Target is dead or has safety item
        ApplyVisualToObject(VFX_FNF_SCREEN_SHAKE, oTarget);
        PlaySound ("as_wt_thundercl3");

        if(d3() == 1){ // hit pc
            nDamage = RollDice(ad.nDamDice, ad.nDamSides);

            if(ad.nDC > 0){
                nSaveType = GetSaveType(ad.nDamType);
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, ad.nDC, nSaveType);
            }
            eDamage = EffectDamage(nDamage, ad.nDamType);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }
        else{
            oTarget = GetNearestObjectByTag("pl_plc_ligtning", oTarget, d6());
        }

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(oTarget));

        int nXPos, nYPos, nCount;
        for (nCount = 0; nCount < 5; nCount++){
            nXPos = Random(10) - 5;
            nYPos = Random(10) - 5;

            vector vNewVector = GetPositionFromLocation(GetLocation(oTarget));
            vNewVector.x += nXPos;
            vNewVector.y += nYPos;

            location lNewLoc = Location(oArea, vNewVector, 0.0);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), lNewLoc);
        }

    }
}

void AreaDoUnderWater(object oPC, struct AreaDamage ad){
    if(!GetIsObjectValid(oPC)) return;

    int iCON = GetAbilityModifier(ABILITY_CONSTITUTION,oPC);    // << Constitution Modifier of oPC
    int iCONSave = d20(1) + iCON;                               // << CON Save if failed to hold breath
    int iHOLD = 2 + (iCON*2);                                   // << Let them hold their breath in seconds

    if(GetLocalInt(GetArea(oPC), VAR_AREA_DMG) != 13){
        // Loop through effects on PC and remove movement rate decreases
        effect eSlow = GetFirstEffect(oPC);

        while(GetIsEffectValid(eSlow)){
            if(GetEffectType(eSlow) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
               || GetEffectType(eSlow) == EFFECT_TYPE_SILENCE)
            {
                RemoveEffect(oPC, eSlow);
            }
            eSlow = GetNextEffect(oPC);
        }

        // The following will reset all counters, DCs, etc in case they fall in the trap again
        // Set the Drowning Round to zero
        DeleteLocalInt(oPC, "ROUND");
        // Reset the Drown counter
        DeleteLocalInt(oPC, "DROWN");
        DeleteLocalInt(oPC, "UnderWater");
        return;
    }
    DelayCommand(RoundsToSeconds(AREA_DAMAGE_DELAY), AreaDoUnderWater(oPC, ad));

    // If we're dead... skip damage and reset variables
    if(GetIsDead(oPC)){
        // The following will reset all counters, DCs, etc in case they fall in the trap again
        ad.nDC = 10;
        // Set the Drowning Round to zero
        DeleteLocalInt(oPC, "ROUND");
        // Reset the Drown counter
        DeleteLocalInt(oPC, "DROWN");
        return;
    }

    // Reduce the entering objects movement speed and silence
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectMovementSpeedDecrease(75)), oPC, RoundsToSeconds(AREA_DAMAGE_DELAY));

    // If we're wearing the safety item, return.
    if(GetIsEquippedByTag(oPC, ad.sSafetyItem) ||
       GetHasSpellImmunity(SPELL_DROWN, oPC) ){
        // Apply our globe.
        effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
        eVis = SupernaturalEffect(eVis);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, RoundsToSeconds(AREA_DAMAGE_DELAY));
        return;
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectSilence()), oPC, RoundsToSeconds(AREA_DAMAGE_DELAY));

    // Do underwater damage
    int iROUND = GetLocalInt(oPC,"ROUND");                  // << Determines number of rounds
    if (iROUND <= iHOLD){
        iROUND=iROUND+1;
        SetLocalInt(oPC,"ROUND",iROUND);
        SendMessageToPC(oPC,"** You are holding your breath **");

        Logger(oPC, VAR_DEBUG_AREAS, LOGLEVEL_DEBUG, "Area: %s, Player: %s, Round: %s",
            GetName(GetArea(oPC)), GetName(oPC), IntToString(iROUND));
    }
    else if (iROUND > iHOLD){
        if (iCONSave >= ad.nDC){
            ad.nDC++;
            SendMessageToPC(oPC,"** You are barely holding your breath **");
             //FloatingTextStringOnCreature("** blub blub **", oPC, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BUBBLES), oPC);
        }
        else{
            int iHPs = GetCurrentHitPoints(oPC);
            int iDROWN = GetLocalInt(oPC,"DROWN");
            effect eDamage;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BUBBLES), oPC);

            switch(iDROWN){
                case 0:
                    eDamage = EffectDamage(iHPs/4,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_PLUS_TWENTY);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC,0.0);
                    SetLocalInt(oPC,"DROWN",1);
                break;
                case 1:
                    eDamage = EffectDamage(iHPs/2,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_PLUS_TWENTY);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC,0.0);
                    SetLocalInt(oPC,"DROWN",2);
                break;
                case 2:
                    eDamage = EffectDamage(iHPs,DAMAGE_TYPE_DIVINE,DAMAGE_POWER_PLUS_TWENTY);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC,0.0);
                    SetLocalInt(oPC,"DROWN",0);
                break;
            }

            iROUND += 1;
            SetLocalInt(oPC, "ROUND", iROUND);
        }
    }
}


void AreaDoPositivePlane(object oArea, object oTarget, struct AreaDamage ad){
    effect eDamage, eImpact;
    int nSaveType, nDamage;
    float fDelay;

    if(!GetIsObjectValid(oTarget) || GetArea(oTarget) != oArea)
        return;

    DelayCommand(RoundsToSeconds(ad.nDelay), AreaDoPositivePlane(oArea, oTarget, ad));

    if(!GetIsDead(oTarget) && (ad.sSafetyItem == "" || !GetIsEquippedByTag(oTarget, ad.sSafetyItem))){ //Do damage unless Target is dead or has safety item

        nDamage = RollDice(ad.nDamDice, ad.nDamSides);

        if(ad.nDC > 0){
            nSaveType = GetSaveType(ad.nDamType);
            if (FortitudeSave(oTarget, ad.nDC, nSaveType))
                nDamage /=  2;
        }

        fDelay = GetRandomDelay();
        if(GetCurrentHitPoints(oTarget) >= GetMaxHitPoints(oTarget) + FloatToInt(GetMaxHitPoints(oTarget) * 0.25f)){
            //SendMessageToPC(oTarget, C_GOLD+""+C_END);
        }
        else if(GetCurrentHitPoints(oTarget) >= GetMaxHitPoints(oTarget) + FloatToInt(GetMaxHitPoints(oTarget) * 0.5f)){
            //SendMessageToPC(oTarget, C_GOLD+""+C_END);
        }
        else if(GetCurrentHitPoints(oTarget) >= GetMaxHitPoints(oTarget) + FloatToInt(GetMaxHitPoints(oTarget) * 0.75f)){
            //SendMessageToPC(oTarget, C_GOLD+""+C_END);
        }
        if(GetCurrentHitPoints(oTarget) >= (GetMaxHitPoints(oTarget) * 2)){
            effect eDeath = SupernaturalEffect(EffectDeath());
            eImpact = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
        }
        else{
            SendMessageToPC(oTarget, C_GOLD+"Hit Points Gained: "+IntToString(nDamage)+C_END);
            DelayCommand(fDelay, IntToVoid(ModifyCurrentHitPoints(oTarget, nDamage)));
        }

        //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
        //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
    }
}

int CheckTransition(object oTransition, object oClicker){
    object oArea      = GetArea(oClicker);
    string sKey       = GetLocalString(oTransition, "KeyTag");
    int nCheckSpawn   = GetLocalInt(oTransition, "CheckSpawn");
    int nCheckDespawn = GetLocalInt(oTransition, "CheckDespawn");
    int nDespawnTime  = GetLocalInt(oArea, "DespawnTime");
    int nCheckEnv     = GetLocalInt(oTransition, "CheckEnv");
    int nCheckLevel   = GetLocalInt(oTransition, "Level");

    int nPercent      = GetPercentEncountersSpawned(oArea, oClicker);
    int bClear        = GetIsAreaClear(oArea, oClicker);
    int bJump         = TRUE;
    int nHideTime     = GetLocalInt(oArea, "PL_LAST_STEALTH");
    int nTime         = GetLocalInt(GetModule(), "uptime") - nHideTime;

   /* if (nHideTime > 0 && nTime < 300 && nPercent < 50) {
        bJump = FALSE;
        FloatingTextStringOnCreature("You cannot make this transition after hiding.", oClicker);
    } else if (nCheckSpawn && !bClear) {
        FloatingTextStringOnCreature("You cannot make this transition while enemies are about.", oClicker);
        bJump = FALSE;
    } else if (nCheckDespawn && nDespawnTime > 0) {
        FloatingTextStringOnCreature("You may not continue after despawning monsters.", oClicker, FALSE);
        bJump = FALSE;
    } else if (nCheckLevel && !GetIsDM(oClicker) && (nCheckLevel > GetLevelIncludingLL(oClicker))) {
        FloatingTextStringOnCreature("You must be at least level " + IntToString(nCheckLevel) + " to use this transition.", oClicker, FALSE);
        bJump = FALSE;
    } else if (sKey != "" && !GetLocalInt(oTransition, "Open")) {
        object oKey = GetItemPossessedBy(oClicker, sKey);
        if (GetIsObjectValid(oKey)) {
            DestroyObject(oKey);
            SetLocalInt(oTransition, "Open", 1);
            FloatingTextStringOnCreature("The key allows passage!", oClicker, FALSE);
            string sBarrier = GetLocalString(oTransition, "KeyBarrier");
            if (sBarrier != "") {
                object oBarrier = GetNearestObjectByTag(sBarrier, oTransition);
                SetPlotFlag(oBarrier, FALSE);
                DestroyObject(oBarrier);
            }
        } else{
            FloatingTextStringOnCreature("The way is blocked.", oClicker, FALSE);
            bJump = FALSE;
        }
    }
*/
    string sMsg = "Transition - Key: %s, Check Spaws: %s, Clear: %s, Check Despawn: %s at %s, ";
    sMsg += "Hide: %s, Spawned Encounters: %s, Check Level: %s";

    Logger(oClicker, "DebugTransitions", LOGLEVEL_DEBUG, sMsg, sKey, IntToString(nCheckSpawn), IntToString(bClear), IntToString(nCheckDespawn),
            IntToString(nDespawnTime), IntToString(nTime), IntToString(nPercent), IntToString(nCheckLevel));

    return bJump;
}
