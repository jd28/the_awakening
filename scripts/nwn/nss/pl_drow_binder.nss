#include "vfx_inc"

void SpawnDemon(){

    object oWay = GetWaypointByTag("wp_pl_drow_binder");
    string sResref = "pl_drow_demon";
    string sDoorTag = "pl_drow_binder_door";

    SpeakString("Come forth dark spirit!");

    ApplyVisualAtLocation(VFX_FNF_PWKILL, GetLocation(oWay));
    CreateObject(OBJECT_TYPE_CREATURE, sResref, GetLocation(oWay), TRUE, "Spawned");

    object oDoor = GetNearestObjectByTag(sDoorTag, OBJECT_SELF);
    AssignCommand(oDoor, ActionCloseDoor(oDoor));
    AssignCommand(oDoor, SetLocked(oDoor, TRUE));
}

void main(){
    DelayCommand(2.5, SpawnDemon());
}
