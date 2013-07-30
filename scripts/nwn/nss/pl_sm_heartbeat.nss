// pl_sm_heartbeat
//
// Spawn mastser OnHeartbeat

#include "mod_funcs_inc"
#include "pl_sm_inc"

void main(){

    int nLock = GetLocalInt(OBJECT_SELF, "PL_SM_LOCKED");

    // Are we locked? i.e. monsters are in the process of spawning.
    // if not and there are no monsters left, delete yourself.  your job is done.
    if(nLock == 0 && !SMCheckActive()){
        SetPlotFlag(OBJECT_SELF, FALSE);
        DestroyObject(OBJECT_SELF);
        return;
    }

    // Check to see if more players have entered the area and if we need to spawn
    // out some more.
    SMDoSpawn();
}
