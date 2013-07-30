//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT1
/*
  Default OnHeartbeat script for NPCs.

  This script causes NPCs to perform default animations
  while not otherwise engaged.

  This script duplicates the behavior of the default
  script and just cleans up the code and removes
  redundant conditional checks.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "pl_ai_inc"

void main(){
    // * if not runnning normal or better Ai then exit for performance reasons
    if (GetAILevel() == AI_LEVEL_VERY_LOW) return;

    string sScript = GetLocalString(OBJECT_SELF, "ES_HB");
    if(sScript != "")
        ExecuteScript(sScript, OBJECT_SELF);

    // Buff ourselves up right away if we should
    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY)){
        // This will return TRUE if an enemy was within 40.0 m
        // and we buffed ourselves up instantly to respond --
        // simulates a spellcaster with protections enabled
        // already.
        if(TalentAdvancedBuff(40.0)){
            // This is a one-shot deal
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);

            // This return means we skip sending the user-defined
            // heartbeat signal in this one case.
            return;
        }
    }
    object oNearEnemy = GetNearestSeenEnemy();
    if(!GetIsFighting(OBJECT_SELF) && oNearEnemy != OBJECT_INVALID){
        PL_AIDetermineCombatRound(oNearEnemy);
    }

    // Send the user-defined event signal if specified
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_HEARTBEAT));
    }
}

