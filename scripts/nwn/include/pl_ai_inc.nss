//#include "x0_i0_enemy"
#include "nw_i0_generic"
#include "mod_funcs_inc"

object PL_AIAquireTarget();
void PL_AIDetermineCombatRound(object oIntruder = OBJECT_INVALID);
int PL_AIGetIsTargetValid(object oCreature);
int PL_AIHasUncommandableEffect(object oCreature);

object PL_AIAquireTarget(){
    object oTarget = GetAttackTarget(), o1;
    int n1, n2;

    // Do we have a hated class?  If our current target is a hated class stick with it, if now switch.
    n1 = GetLocalInt(OBJECT_SELF, "PL_AI_HATED_CLASS") - 1;
    if (n1 > 0){
        if(GetLevelByClass(n1, oTarget) == 0)
            oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, 1, CREATURE_TYPE_CLASS, n1);
    }
    // If we have found a hated class to target or we already have a target. Go with it.
    if (PL_AIGetIsTargetValid(oTarget)){
        return oTarget;
    }

    // No hated class and no current target let's look for something else.

    // Let's attack our last damager.
    oTarget = GetLastDamager();
    if (PL_AIGetIsTargetValid(oTarget)){
        return oTarget;
    }

    // If no last damager... let's go after the most injured.
    //oTarget = GetFactionMostDamagedMember(GetNearestPerceivedEnemy(), TRUE);
    //if (PL_AIGetIsTargetValid(oTarget)){
    //    return oTarget;
    //}

    // If no last damager many possible targets do we have?
    n1 = 1;
    oTarget = GetNearestPerceivedEnemy();
    while (!PL_AIGetIsTargetValid(oTarget) && oTarget != OBJECT_INVALID){
        n1++;
        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, n1);
    }

    //Logger(oTarget, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "PL_AIAquireTarget: %s", GetName(oTarget));

    // Randomly choose one.  If there is one, if not return anyway.  Nothing to be done.
    return oTarget;
}

void PL_AIDetermineCombatRound(object oIntruder = OBJECT_INVALID){
    int n1;
    // New check - If they are commandable, and no stupid ones.
    n1 = PL_AIHasUncommandableEffect(OBJECT_SELF);
    if(n1 == 1){ // We can't do anything
        return;
    }
    else if(n1 == 2){ // We can move away...
        ActionMoveAwayFromObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1,
                                                    CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD,
                                                    CREATURE_TYPE_IS_ALIVE, TRUE));
        return;
    }

    // if no one in the area
    if(GetLocalInt(GetArea(OBJECT_SELF), VAR_AREA_OCCUPIED) == 0)
        return;

    // We're already fighting
    if(GetIsInCombat(OBJECT_SELF)){
        //WriteTimestampedLogEntry("I'm fighting.");
        return;
    }
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL)) {
        WriteTimestampedLogEntry("I'm special.");
        DetermineSpecialBehavior(oIntruder);
        return;
    }

    if (GetCurrentAction() == ACTION_RANDOMWALK){
        ClearAllActions();
    }

    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT");
    if (sSpecialAI != "")
    {
        SetLocalObject(OBJECT_SELF,"X2_NW_I0_GENERIC_INTRUDER", oIntruder);
        ExecuteScript(sSpecialAI, OBJECT_SELF);
        if (GetLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK"))
        {
            DeleteLocalInt(OBJECT_SELF,"X2_SPECIAL_COMBAT_AI_SCRIPT_OK");
            return;
        }
    }

    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: EVALUATIONS
    // ----------------------------------------------------------------------------------------
    if(GetAssociateState(NW_ASC_IS_BUSY)){
        WriteTimestampedLogEntry("I'm busy.");
        return;
    }


    // ** Store HOw Difficult the combat is for this round
    int nDiff = GetCombatDifficulty();
    SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);
    //WriteTimestampedLogEntry("COMBAT: " + IntToString(nDiff));

    // ----------------------------------------------------------------------------------------
    // If no special target has been passed into the function
    // then choose an appropriate target
    // ----------------------------------------------------------------------------------------
    if (PL_AIGetIsTargetValid(oIntruder) == FALSE){
        //WriteTimestampedLogEntry("No target Passed to DCR.");
        oIntruder = PL_AIAquireTarget();
    }
    // ----------------------------------------------------------------------------------------
    /*
       JULY 11 2003
       If in combat round already (variable set) do not enter it again.
       This is meant to prevent multiple calls to DetermineCombatRound
       from happening during the *same* round.

       This variable is turned on at the start of this function call.
       It is turned off at each "return" point for this function
    */
    // ----------------------------------------------------------------------------------------
    if (__InCombatRound() == TRUE)
    {
        return;
    }

    __TurnCombatRoundOn(TRUE);

    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: ACTIONS
    // ----------------------------------------------------------------------------------------
    if(GetIsObjectValid(oIntruder))
    {

        if(TalentPersistentAbilities()) // * Will put up things like Auras quickly
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // ----------------------------------------------------------------------------------------
        // BK September 2002
        // If a succesful tactic has been chosen then
        // exit this function directly
        // ----------------------------------------------------------------------------------------

        if (chooseTactics(oIntruder) == 99)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // ----------------------------------------------------------------------------------------
        // This check is to make sure that people do not drop out of
        // combat before they are supposed to.
        // ----------------------------------------------------------------------------------------

        object oNearEnemy = GetNearestSeenEnemy();
        //DetermineCombatRound(oNearEnemy);
        PL_AIDetermineCombatRound(oNearEnemy);

        return;
    }
     __TurnCombatRoundOn(FALSE);

    // ----------------------------------------------------------------------------------------
    // This is a call to the function which determines which
    // way point to go back to.
    // ----------------------------------------------------------------------------------------
    ClearActions(CLEAR_NW_I0_GENERIC_658);
    SetLocalObject(OBJECT_SELF, "NW_GENERIC_LAST_ATTACK_TARGET", OBJECT_INVALID);
    WalkWayPoints();
}

int PL_AIGetIsTargetValid(object oCreature){

    // If we have the same master this target isn't valid
    object oMaster = GetMaster();
    int iHaveMaster = GetIsObjectValid(oMaster);
    if (iHaveMaster && GetMaster(oCreature) == oMaster){
        return FALSE;
    }

    // Target must be Valid, not dying, dead, or a DM.
    if (GetIsObjectValid(oCreature)
        && oCreature != OBJECT_SELF
        && !GetAssociateState(NW_ASC_MODE_DYING, oCreature)
        && !GetIsDead(oCreature)
        && !GetIsDM(oCreature))
    {
        return TRUE;
    }

    //WriteTimestampedLogEntry("Target Invalid: "+ GetName(oCreature));

    return FALSE;
}

int PL_AIHasUncommandableEffect(object oCreature){

    effect eEff = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eEff)){
        switch(GetEffectType(eEff)){
            case EFFECT_TYPE_STUNNED:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_TURNED:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_DISAPPEARAPPEAR:// Added for dragon flying
                return 1;
            break;
            case EFFECT_TYPE_DAZED:
                return 2;
            break;
        }
        eEff = GetNextEffect(oCreature);
    }
    return FALSE;
}


//void main(){}
