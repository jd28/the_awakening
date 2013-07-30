#include "pl_ai_inc"
const int EVENT_USER_DEFINED_PRESPAWN  = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;
//#include "hg_inc"
//#include "ac_itemprop_inc"
//#include "ac_effect_inc"
//#include "fky_ai_locals"
//#include "ac_qstatus_inc"
//#include "fky_paragon_inc"
#include "nw_i0_generic"
#include "mon_func_inc"
#include "mod_funcs_inc"
#include "dip_func_inc"
#include "pl_dds_inc"

void main() {
    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF, "X2_USERDEFINED_ONSPAWN_EVENTS");
    int nID = GetLocalInt(OBJECT_SELF, "ID");


    if(GetLocalInt(OBJECT_SELF, "Boss")){
        Logger(OBJECT_SELF, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "BOSS SPAWNED : Area: %s, Name: %s",
            GetTag(GetArea(OBJECT_SELF)), GetName(OBJECT_SELF));
    }

    /* pre spawn event */
    if (nSpecEvent & 1)
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_USER_DEFINED_PRESPAWN));

    if(GetLocalInt(OBJECT_SELF, "Fall"))
        SetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION);

    //CheckParagon();
    if(nID)
        ApplyDDS(OBJECT_SELF, nID);

    ApplyLocals();
    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "NW_I_WAS_ATTACKED", 1);
    if (GetLocalInt(OBJECT_SELF, "FKY_AI_WALKWAYPOINTS")
        || GetLocalInt(OBJECT_SELF, "PL_AI_WALKWAY") )
        WalkWayPoints(GetLocalInt(OBJECT_SELF, "RunWaypoints"), 0.0f);

    SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, TRUE);

    switch(GetLocalInt(OBJECT_SELF, "DIPType")){
        case 1: // Right hand
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND),
                OBJECT_INVALID, OBJECT_INVALID));
        break;
        case 2: // Dual
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND),
                GetItemInSlot(INVENTORY_SLOT_LEFTHAND), OBJECT_INVALID));
        break;
        case 3: // Guants
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_ARMS),
                OBJECT_INVALID, OBJECT_INVALID));
        break;
        default:
            DelayCommand(2.0, ApplyLocalsToWeapon(OBJECT_SELF, GetItemInSlot(INVENTORY_SLOT_CWEAPON_R),
                GetItemInSlot(INVENTORY_SLOT_CWEAPON_L), GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)));
    }

    if(GetLocalInt(OBJECT_SELF, "PL_AI_ATTACK_NEAREST")){
        object oEnemy = GetNearestEnemy();
        ActionMoveToObject(oEnemy, TRUE, 2.0f);
        ActionAttack(oEnemy);
        PL_AIDetermineCombatRound(oEnemy);
    }
    else
        PL_AIDetermineCombatRound(GetNearestSeenEnemy());

    /* post spawn event */
    if (nSpecEvent & 2)
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
}

