#include "area_inc"
#include "pc_persist"

void main(){

    object oArea = OBJECT_SELF;
    object oPC = GetEnteringObject();
    int bFirstEntry = FALSE;
    string sResref;


    //--------------------------------------------------------------------------
    // Do Player specific stuff.
    //--------------------------------------------------------------------------
    if(GetIsPC(oPC)){
        // On first entry by anyone spawn out the loot.
        if(GetLocalInt(oArea, "EnteredOnce") == 0){
            bFirstEntry = TRUE;
            SetLocalInt(oArea, "EnteredOnce", 1);
            int i = 1;
            object oStorage = GetNearestObjectByTag("rlgs_info", GetEnteringObject(), i);
            while(oStorage != OBJECT_INVALID){
                if(!GetLocalInt(oStorage, "Spawned")){
                    SetLocalInt(oStorage, "Spawned", TRUE);
                    sResref = GetLocalString(oStorage, "rlgs_resref");
                    if(sResref != ""){
                        DelayCommand(0.1, ObjectToVoid(CreateObject(OBJECT_TYPE_PLACEABLE, sResref, GetLocation(oStorage))));
                    }
                }
                i++;
                oStorage = GetNearestObjectByTag("rlgs_info", GetEnteringObject(), i);
            }
        }
        // Handles the NESS spawn system
        if (GetLocalInt(oArea, "area_spawn") == 1){
            if (GetIsAreaAboveGround(oArea) && ! GetIsAreaNatural(oArea)){
                // Indoors - no delay on the first HB
                Spawn_OnAreaEnter( "spawn_sample_hb", 10.0 );
                }
            else{ // Outdoors or underground - do a 3 second delay on the first HB
                Spawn_OnAreaEnter( "spawn_sample_hb", 10.0, 3.0 );
            }
        }
        if(GetLocalInt(oArea, VAR_AREA_OCCUPIED) == 0){
            // Respawn the loot.
            if(!bFirstEntry) DelayCommand(0.5, AreaRespawnLoot(oArea));
            // Spawn in dynamic placeables.
            DelayCommand(0.5, AreaSpawnPlaceables(oArea));

            AreaRespawnTraps(oArea);
            //ExecuteScript("se_oea_rsp_trap", OBJECT_SELF);
        }

        // Don't affect DMs or anyone DM possessed
        if(!GetIsDM(oPC) && !GetIsDMPossessed(oPC)){
            // Increment PC counter.
            IncrementLocalInt(oArea, VAR_AREA_OCCUPIED);
            //SetLocalInt(oArea, VAR_AREA_OCCUPIED, GetLocalInt(oArea, VAR_AREA_OCCUPIED) + 1);

            // Reveal area for player
            if (GetLocalInt(oArea, VAR_AREA_REVEAL)){
                ExploreAreaForPlayer(oArea, oPC);
            }

            if (GetLocalInt(oArea, "area_delete_location")){
                DeletePersistantVariable(oPC, "loc");
            }

            // Save location on enter.
            SavePersistentLocation(oPC);

            // Code to make a PC or NPC seem to 'float' (for use in water or flying etc)
            if (GetLocalInt(oArea, VAR_AREA_FLY)){
                pl_Fly(oPC);
                SetLocalInt(oPC, VAR_PC_FLYING, TRUE);
            }

            // Gives the PC the appearance of falling into the area
            if (GetLocalInt(oArea, VAR_AREA_FALL)){
                ApplyEffectToObject(0, EffectAppear(), oPC);
            }

            //Area Damage
            if(GetLocalInt(oArea, VAR_AREA_DMG) != 0)
                DelayCommand(1.0, AreaStartDamage(oArea, oPC));
        }
        string sScript = GetLocalString(oArea, "ES_Enter");
        if(sScript != "")
            ExecuteScript(sScript, oArea);

        Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Area: %s, Occupants: %s, Reveal: %s, Fall: %s, Damage: %s",
               GetTag(oArea), IntToString(GetLocalInt(oArea, VAR_AREA_OCCUPIED)), IntToString(GetLocalInt(oArea, VAR_AREA_REVEAL)),
               IntToString(GetLocalInt(oArea, VAR_AREA_FALL)), IntToString(GetLocalInt(oArea, VAR_AREA_DMG)));
    }

    if(!GetIsEncounterCreature(oPC) && GetTag(oPC) != "Spawned"){
        Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "AREA ENTER : Area: %s, Player: %s, Name: %s",
            GetTag(oArea), GetPCPlayerName(oPC), GetName(oPC));
    }
}
