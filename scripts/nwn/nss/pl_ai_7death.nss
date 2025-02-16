//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
#include "rlgs_func_inc"
#include "x2_inc_compon"
#include "x0_i0_spawncond"

void main(){

    object oKiller = GetLastKiller();

    // Scarface's XP/GP System
    if(!GetLocalInt(OBJECT_SELF, "NoXP")){
        ExecuteScript("mod_xp_system", OBJECT_SELF);
    }
    // End

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // Execute script.
    string sScript = GetLocalString(OBJECT_SELF, "ES_Death");
    if(sScript != "") ExecuteScript(sScript, OBJECT_SELF);

    if( !GetLocalInt(OBJECT_SELF, "DM_SPAWNED") ) {
        //RLGS Loot...
        struct rlgs_info ri;

        ri.oContainer = OBJECT_SELF;
        ri.oHolder = OBJECT_SELF;
        ri.oPC = oKiller;

        DelayCommand(0.5f, RLGSGenerateLoot(ri));
        DelayCommand(0.5f, ExecuteScript("ta_loot_gen", OBJECT_SELF));
    }

    string sDoor = GetLocalString(OBJECT_SELF, "UnlockDoor");
    if(sDoor != ""){
        int i = 1;
        object oDoor = GetNearestObjectByTag(sDoor, oKiller, i);
        while(GetIsObjectValid(oDoor)){
            AssignCommand(oDoor, SetLocked(oDoor, FALSE));
            AssignCommand(oDoor, ActionOpenDoor(oDoor));
            i++;
            oDoor = GetNearestObjectByTag(sDoor, oKiller, i);
        }
    }

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }

}
