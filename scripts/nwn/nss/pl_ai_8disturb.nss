//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT8
/*
  Default OnDisturbed event handler for NPCs.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "pl_ai_inc"

void main(){
    if (GetLastDisturbed() != OBJECT_INVALID)
        PL_AIDetermineCombatRound();

    // Send the disturbed flag if appropriate.
    if(GetSpawnInCondition(NW_FLAG_DISTURBED_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DISTURBED));
    }
}
