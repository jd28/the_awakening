//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Feb 16th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "pl_ai_inc"
#include "mon_func_inc"

void main(){
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)){
        DetermineSpecialBehavior();
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS)){
        // Determine Combat Round
        PL_AIDetermineCombatRound();
    }

    // Apply any Dynamic Effects
    ApplyDynamics(OBJECT_SELF);

    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT)){
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}




