//#include "spawn_functions"
//#include "habd_include"
//#include "cs_wdm_i"
//#include "vg_water_exit"
//#include "vg_cold_exit"
//#include "vg_fire_exit"
//#include "vg_acid_exit"
//#include "vg_smoke_exit"

//#include "zep_inc_phenos"
#include "area_inc"

void main(){

    object oPC = GetExitingObject();
    object oArea = OBJECT_SELF;
    int nDelay;


    if(!GetLocalInt(oPC, VAR_PC_IS_PC)) return;

    Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Area: %s, Occupants: %s, No Clean: %s, Clean Delay: %s",
           GetTag(oArea), IntToString(GetLocalInt(oArea, VAR_AREA_OCCUPIED)),
           IntToString(GetLocalInt(oArea, VAR_AREA_NO_CLEAN)), IntToString(nDelay));

    // Handles the NESS spawn system
    if (GetLocalInt(oArea, "area_spawn") == 1)
        Spawn_OnAreaExit();

    if(GetIsDM(oPC) || GetIsDMPossessed(oPC))
        return;

    DecrementLocalInt(oArea, VAR_AREA_OCCUPIED);

    //--------------------------------------------------------------------------
    // Remove any area effects from player.
    //--------------------------------------------------------------------------

    if(GetLocalInt(oPC, VAR_PC_FLYING)){
        DeleteLocalInt(oPC, VAR_PC_FLYING);
        pl_Fly_Land(oPC);
    }


    //--------------------------------------------------------------------------
    // Clean Area
    //--------------------------------------------------------------------------
    if (!GetLocalInt(oArea, VAR_AREA_NO_CLEAN)){
        nDelay = AREA_CLEAN_DELAY;

        if(GetLocalInt(oArea, VAR_AREA_CLEAN_DELAY) > 0){
            nDelay = GetLocalInt(oArea, VAR_AREA_CLEAN_DELAY);
        }
        DelayCommand(RoundsToSeconds(nDelay), AreaClean(oArea));
    }


}
