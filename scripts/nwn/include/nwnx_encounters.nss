#include "mod_funcs_inc"


const string PLS_CREATURE_VAR = "pls_active_var";
const string PLS_ENCOUNTER_VAR = "pls_encounter_var";
const string PLS_ENTER_SCRIPT_VAR = "pls_enter_script";
const string PLS_EXHAUSTED_VAR = "pls_exhausted_var";
const string PLS_RESPAWN_TIME_VAR = "pls_respawn_time";

location LOCATION_INVALID = Location ( GetModule(), Vector(), 0.0 );
int _spawnpt_counter = 0;

int ModGetCurrentTime();

// Spawn Point Functions
int GetEncounterRespawnTime(object oEncounter) { return 0; }
location GetFirstSpawnPoint(object oEncounter);
location GetNextSpawnPoint(object oEncounter);
location GetFurthestSpawnPointFromObject(object oEncounter, object oCreature);
int GetSpawnPointCount(object oEncounter);
location GetSpawnPointByPosition(object enc, int nIndex);

// PLSpawn Encounter Funtions
int PLSpawnGetIsActive(object oEncounter);
int PLSpawnDecrementCreatures(object oEncounter);
int PLSpawnIncrementCreatures(object oEncounter);
void PLSpawnCreature(object oEncounter, string resref, location loc);
int PLSpawnGetExhausted(object oEncounter);
void PLSpawnSetExhausted(object oEncounter, int bool = TRUE);

location GetFirstSpawnPoint(object oEncounter){
    _spawnpt_counter = 0;
    return GetSpawnPointByPosition(oEncounter, _spawnpt_counter);
}

location GetNextSpawnPoint(object oEncounter){
    _spawnpt_counter += 1;
    if(_spawnpt_counter > GetSpawnPointCount(oEncounter))
        return LOCATION_INVALID;

    return GetSpawnPointByPosition(oEncounter, _spawnpt_counter);
}

location GetFurthestSpawnPointFromObject(object oEncounter, object oCreature){
    int count = GetSpawnPointCount(oEncounter), i;
    float fFurthest, fTemp;
    location lFurthest, lTemp;

    if(count <= 0)
        return LOCATION_INVALID;

    for(i = 0; i < count; i++){
        lTemp = GetSpawnPointByPosition(oEncounter, i);
        fTemp = GetDistanceBetweenLocations(lTemp, GetLocation(oCreature));
        if( fTemp > fFurthest){
            fFurthest = fTemp;
            lFurthest = lTemp;
        }
    }
    
    return lFurthest;
}

int GetSpawnPointCount(object enc){
    SetLocalString(enc, "NWNX!FUNCS!GETSPAWNPOINTCOUNT", "      ");
    return StringToInt(GetLocalString(enc, "NWNX!FUNCS!GETSPAWNPOINTCOUNT"));
}

location GetSpawnPointByPosition(object enc, int nIndex){
    float x, y, z;
    string result;
    struct SubString ss;

    SetLocalString(enc, "NWNX!FUNCS!GETSPAWNPOINTBYPOSITION", IntToString(nIndex)+"                                                                                                                ");
    result = GetLocalString(enc, "NWNX!FUNCS!GETSPAWNPOINTBYPOSITION");

    SendMessageToPC(GetFirstPC(), result);    
    if(result == "")
        return LOCATION_INVALID; 

    ss = GetFirstSubString(result, "¬");
    x = StringToFloat(ss.first);
    ss = GetFirstSubString(ss.rest, "¬");
    y = StringToFloat(ss.first);
    ss = GetFirstSubString(ss.rest, "¬");
    z = StringToFloat(ss.first);

    return Location ( GetArea(enc), Vector(x, y, z), 0.0);
}

int GetPlayerTriggeredOnly(object oEncounter){
    SetLocalString(oEncounter, "NWNX!FUNCS!GETPLAYERTRIGGEREDONLY", "      ");
    return StringToInt(GetLocalString(oEncounter, "NWNX!FUNCS!GETPLAYERTRIGGEREDONLY"));
}

int GetRespawnTime(object oEncounter){
    SetLocalString(oEncounter, "NWNX!FUNCS!GETRESPAWNTIME", "      ");
    return StringToInt(GetLocalString(oEncounter, "NWNX!FUNCS!RESPAWNTIME"));
}

int PLSpawnGetCreatureCount(object oEncounter){
    return GetLocalInt(oEncounter, PLS_CREATURE_VAR);
}

int PLSpawnGetRespawnTime(object oEncounter){
    return GetLocalInt(oEncounter, PLS_RESPAWN_TIME_VAR);
}

int PLSpawnDecrementCreatures(object oEncounter){
    int count = DecrementLocalInt(oEncounter, PLS_CREATURE_VAR);
    if (count <= 0)
        PLSpawnSetExhausted(oEncounter, TRUE);

    return count;
}

int PLSpawnIncrementCreatures(object oEncounter){
    return IncrementLocalInt(oEncounter, PLS_CREATURE_VAR);
}

void PLSpawnSetRespawnTime(object oEncounter, int nTime){
    SetLocalInt(oEncounter, PLS_RESPAWN_TIME_VAR, nTime);
}

int PLSpawnGetIsActive(object oEncounter){
    int nTime = ModGetCurrentTime();
    int nRespawnTime = PLSpawnGetRespawnTime(oEncounter);
    
    if(PLSpawnGetCreatureCount(oEncounter) > 0)
        return FALSE;
    else if(PLSpawnGetExhausted(oEncounter)
            && nTime < nRespawnTime)
        return FALSE;

    PLSpawnSetExhausted(oEncounter, FALSE);
    return TRUE; 
}
int PLSpawnGetValidSpawner(object oCreature, object oEncounter = OBJECT_SELF){
    return GetIsPC(oCreature);
}
void PLSpawnCreature(object oEncounter, string resref, location loc){
    object cre = CreateObject(OBJECT_TYPE_CREATURE, resref, loc);
    SetLocalObject(cre, PLS_ENCOUNTER_VAR, oEncounter);
    PLSpawnIncrementCreatures(oEncounter);
}

int PLSpawnGetExhausted(object oEncounter){
    return GetLocalInt(oEncounter, PLS_EXHAUSTED_VAR);
}

void PLSpawnSetExhausted(object oEncounter, int bool = TRUE){
    int nTime, nRespawnTime;
    // Set Respawn Time.
    if(bool){
        nTime = ModGetCurrentTime();
        nRespawnTime = GetEncounterRespawnTime(oEncounter);
        PLSpawnSetRespawnTime(oEncounter, nTime+nRespawnTime); 
    }

    SetLocalInt(oEncounter, PLS_EXHAUSTED_VAR, bool);
}
// Variable: "ssp_spawn_<spawn #>" | string | resref
// Variable: "ssp_spawn_<spawn #>" | int | See below
// Format: ChMPNB
// B = Base amount to spawn.
// N = Number of extra monsters to be spawned
// P = Per X players
// M = Maximum number that can be spawned.  If max is 0, then no maximum.
// R = Random if set.. resref + dR();
// Ch = Chance out of 100 that will spawn.

void PLSpawnEncounter(location lLoc, object oEncounter = OBJECT_SELF){
    string sScript = GetLocalString(oEncounter, PLS_ENTER_SCRIPT_VAR);
    if(sScript != ""){
        ExecuteScript(sScript, oEncounter);
        return;
    }

    int nPlayers = GetLocalInt(GetArea(OBJECT_SELF), VAR_AREA_OCCUPIED), i, j;
    object oMonster;
    float fDelay;
    //Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Spawn Master DoSpawn: %s",
    //    GetTag(OBJECT_SELF));

    if(nPlayers == 0)
        nPlayers = 1;

    for (i = 1; i <= 10; i++) {
        string sSpawn = GetLocalString(OBJECT_SELF, "ssp_spawn_" + IntToString(i));
        //SpeakString(sSpawn, TALKVOLUME_SHOUT);
        if (sSpawn != "") {
            int nTally = GetLocalInt(OBJECT_SELF, "ssp_tally_" + IntToString(i));
            int nCount = GetLocalInt(OBJECT_SELF, "ssp_spawn_" + IntToString(i));
            int nBase = nCount % 10;
            int nExtra = (nCount /= 10) % 10;
            int nPerPlayer = (nCount /= 10) % 10;
            int nMax = (nCount /= 10) % 10; // Default: 4
            if(nMax == 0) nMax = 4;
            int nRandom = (nCount /= 10) % 10;
            int nChance = nCount / 10; // Default 100%
            if(nChance == 0) nChance = 100;

            int nSpawnedFor = GetLocalInt(OBJECT_SELF, "PL_SM_SPAWNED");
            // We've already spawned as many of these as we can.
            if(nTally == nMax || nPlayers == nSpawnedFor)
                continue;

            // We've already spawned once, so forget the base spawns.
            if(nSpawnedFor > 0){
                nBase = 0;
            }
            // Check the difference between SpawnedFor and current players.
            // This will tell us if more players have come into the area since
            // we spawned.  So - out those we've spawned for already.
            //if(nSpawnedFor < nPlayers) nPlayers -= nSpawnedFor;

            // Calculate the number to spawn.
            if(nPerPlayer > 0){
                float fExtra = ( (nPlayers - nSpawnedFor)  / IntToFloat(nPerPlayer) ) * nExtra;
                nBase +=  FloatToInt(fExtra);
            }
            // Max reduced by number already spawned.
            nMax -= nTally;

            if(nBase > nMax)
                nBase = nMax;

            string sResref;
            for(j = 1; j <= nBase; j++){
                if(nChance >= d100()){
                    nTally++;

                    if(nRandom != 0)
                        sResref = sSpawn + IntToString(RollDice(1, nRandom));
                    else
                        sResref = sSpawn;

                    DelayCommand(0.5, PLSpawnCreature(oEncounter, sResref, lLoc));

                    //oMonster = CreateObject(OBJECT_TYPE_CREATURE, sResref, lLoc, FALSE, "Spawned");
                    //SetLocalObject(oMonster, "ssp_master", OBJECT_SELF);
                    //SetLocalObject(OBJECT_SELF, sSpawn + IntToString(nTally), oMonster);
                }
            }
            SetLocalInt(OBJECT_SELF, "ssp_tally_" + IntToString(i), nTally);

            //Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_DEBUG,
            //    "Tally: %s, Count:%s, Base: %s, Extra: %s per %s players, Max: %s, nSpawnedFor: %s",
            //    IntToString(nTally), IntToString(nCount), IntToString(nBase), IntToString(nExtra),
            //    IntToString(nPerPlayer), IntToString(nMax), IntToString(nSpawnedFor));
        } else
            break;
    }
    SetLocalInt(OBJECT_SELF, "PL_SM_SPAWNED", nPlayers);
}
