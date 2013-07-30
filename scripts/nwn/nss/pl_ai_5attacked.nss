//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 4th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////

#include "pl_ai_inc"
void main(){
    // If plot ignore..
    if (GetPlotFlag(OBJECT_SELF)) return;

    string sEnc = GetLocalString(OBJECT_SELF, "ActivateEncounters");
    if(sEnc != "" && !GetLocalInt(OBJECT_SELF, "EncountersActive")){
        SetLocalInt(OBJECT_SELF, "EncountersActive", 1);
        int i = 1;
        object oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, OBJECT_SELF, i);
        while(oEnc != OBJECT_INVALID){
            SetEncounterActive(TRUE, oEnc);
            i++;
            oEnc = GetNearestObject(OBJECT_TYPE_ENCOUNTER, OBJECT_SELF, i);
        }
    }

    if(GetLastAttacker() != OBJECT_INVALID){
        PL_AIDetermineCombatRound();

        //Shout Attack my target, only works with the On Spawn In setup
        SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

        //Shout that I was attacked
        SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
    }

    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT)){
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
    }
}
