//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT6
//:: Default OnDamaged handler
/*
    If already fighting then ignore, else determine
    combat round
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////
//:://////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 17th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////////

#include "mon_func_inc"

void main(){

    // If Plot ignore.
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

        //if(GetLocalString(OBJECT_SELF, "ActivateEncountersMsg") != "")
        //    SpeakString(GetLocalString(OBJECT_SELF, "ActivateEncountersMsg"));
    }

    object oDamager = GetLastDamager();
    object oMe=OBJECT_SELF;
    int nHPBefore;

    if(GetFleeToExit()) {
        // We're supposed to run away, do nothing
    } else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS)) {
        // don't do anything?
    } else {
        if (!GetIsObjectValid(oDamager)) {
            // don't do anything, we don't have a valid damager
        } else if (!GetIsFighting(OBJECT_SELF)) {
            // If we're not fighting, determine combat round
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
                DetermineSpecialBehavior(oDamager);
            } else {
                if(!GetObjectSeen(oDamager)
                   && GetArea(OBJECT_SELF) == GetArea(oDamager)) {
                    // We don't see our attacker, go find them
                    ActionMoveToLocation(GetLocation(oDamager), TRUE);
                    ActionDoCommand(DetermineCombatRound());
                } else {
                    DetermineCombatRound();
                }
            }
        } else {
            // We are fighting already -- consider switching if we've been
            // attacked by a more powerful enemy
            object oTarget = GetAttackTarget();
            if (!GetIsObjectValid(oTarget))
                oTarget = GetAttemptedAttackTarget();
            if (!GetIsObjectValid(oTarget))
                oTarget = GetAttemptedSpellTarget();

            // If our target isn't valid
            // or our damager has just dealt us 25% or more
            //    of our hp in damager
            // or our damager is more than 2HD more powerful than our target
            // switch to attack the damager.
            if (!GetIsObjectValid(oTarget)
                || (
                    oTarget != oDamager
                    &&  (
                         GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4)
                         || (GetHitDice(oDamager) - 2) > GetHitDice(oTarget)
                         )
                    )
                )
            {
                // Switch targets
                DetermineCombatRound(oDamager);
            }
        }
    }

    string sScript = GetLocalString(OBJECT_SELF, "ES_Dmged");
    if(sScript != "")
        ExecuteScript(sScript, OBJECT_SELF);

    // Send the user-defined event signal
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}
