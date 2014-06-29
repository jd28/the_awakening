#include "mod_funcs_inc"
#include "gsp_func_inc"

int SMCheckActive(){
    int i, j, nActive;
    object oMonster;

    //Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Spawn Master SMCheckActive: %s",
    //    GetTag(OBJECT_SELF));

    if(!GetLocalInt(OBJECT_SELF, "PL_SM_SPAWNED"))
        return TRUE;

    // Check to see if all spawns are dead, if so destroy self.
    for (i = 1; i <= 10; i++) {
        string sSpawn = GetLocalString(OBJECT_SELF, "ssp_spawn_" + IntToString(i));
        int nTally = GetLocalInt(OBJECT_SELF, "ssp_tally_" + IntToString(i));
        if (sSpawn != "") {
            j = 1;
            while(j <= nTally && !nActive){
                oMonster = GetLocalObject(OBJECT_SELF, sSpawn + IntToString(j));
                if(GetIsObjectValid(oMonster))
                    nActive = TRUE;
                j++;
            }
        } else
            break;
    }

    return nActive;
}

void SpawnMonster(string sResref, string sSpawn, location lLoc, int nTally){
    object oMonster = CreateObject(OBJECT_TYPE_CREATURE, sResref, lLoc, FALSE, "Spawned");
    SetLocalObject(oMonster, "ssp_master", OBJECT_SELF);
    SetLocalObject(OBJECT_SELF, sSpawn + IntToString(nTally), oMonster);

    //return oMonster;
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


void SMDoSpawn(){
    int nPlayers = GetLocalInt(GetArea(OBJECT_SELF), VAR_AREA_OCCUPIED), i, j;
    location lLoc = GetLocation(OBJECT_SELF);
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

                    DelayCommand(GetRandomDelay(), SpawnMonster(sResref, sSpawn, lLoc, nTally));
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

//void main(){}
