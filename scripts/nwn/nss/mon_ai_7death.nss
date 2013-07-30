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

#include "mon_func_inc"

void main(){

    object oKiller = GetLastKiller();

    // Scarface's XP/GP System
    if(!GetLocalInt(OBJECT_SELF, "NoXP")){
        ExecuteScript("mod_xp_system", OBJECT_SELF);
    }
    // End

    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    if(GetIsEncounterCreature(OBJECT_SELF)
            || GetLocalInt(OBJECT_SELF, "PL_AI_SPAWNED")
            || GetLocalInt(OBJECT_SELF, "Despawn") > 0){
        //RLGS Loot...
        struct rlgs_info ri;

        ri.oContainer = OBJECT_SELF;
        ri.oHolder = OBJECT_SELF;
        ri.oPC = oKiller;

        DelayCommand(0.5f, RLGSGenerateLoot(ri));
        DelayCommand(0.6f, ExecuteScript("ta_item_gen", OBJECT_SELF));
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

    // Execute script.
    string sScript = GetLocalString(OBJECT_SELF, "ES_Death");
    if(sScript != "") ExecuteScript(sScript, OBJECT_SELF);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }

}
