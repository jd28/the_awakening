const int EVENT_USER_DEFINED_PRESPAWN  = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;
//#include "hg_inc"
//#include "ac_itemprop_inc"
//#include "ac_effect_inc"
//#include "fky_ai_locals"
//#include "ac_qstatus_inc"
//#include "fky_paragon_inc"

#include "mon_func_inc"

void AddHeals(){
    if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD)
        return;

    if(GetLocalInt(OBJECT_SELF, "Boss"))
        return;

    int nLevel = GetHitDice(OBJECT_SELF);
    int nRoll = Random(100) + 1;

    if(nLevel >= 55 && nRoll <= 30){
        if(nRoll <= 20)
            CreateItemOnObject("nw_it_mpotion012", OBJECT_SELF, 1); // Heal
        else
            CreateItemOnObject("pl_p_restgrt_051", OBJECT_SELF, 1); // Greater Restoration 
    }
    else if(nLevel >= 50 && nRoll <= 20){
        if(nRoll <= 10)
            CreateItemOnObject("nw_it_mpotion012", OBJECT_SELF, 1); // Heal
        else
            CreateItemOnObject("pl_p_restgrt_051", OBJECT_SELF, 1); // Greater Restoration 
    }
    else if(nLevel >= 40 && nRoll <= 10){
        CreateItemOnObject("nw_it_mpotion012", OBJECT_SELF, 1); // Heal
    }
    
}
void ApplyBossProperties(){
    effect eEff;
    object oSelf = OBJECT_SELF;

    // All bosses immune to the harm / heals...
    if (GetRacialType(oSelf) == RACIAL_TYPE_UNDEAD) {
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HEAL));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_MASS_HEAL));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_CURE_MINOR_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_CURE_LIGHT_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_CURE_MODERATE_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_CURE_SERIOUS_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_CURE_CRITICAL_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HEALING_CIRCLE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    } else {
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HARM));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_INFLICT_MINOR_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_INFLICT_LIGHT_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_INFLICT_MODERATE_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_INFLICT_SERIOUS_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_INFLICT_CRITICAL_WOUNDS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    // All bosses have true seeing
    ApplySight(oSelf, TRUE);

    // Immune to Flesh to Stone
    ApplySpellImmunities(oSelf, SPELL_FLESH_TO_STONE);
    ApplySpellImmunities(oSelf, SPELL_BIGBYS_CRUSHING_HAND, SPELL_BIGBYS_FORCEFUL_HAND, SPELL_BIGBYS_GRASPING_HAND, SPELL_DROWN);
    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_FEAR, IMMUNITY_TYPE_MIND_SPELLS, IMMUNITY_TYPE_PARALYSIS);
    ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_NEGATIVE_LEVEL, IMMUNITY_TYPE_KNOCKDOWN, IMMUNITY_TYPE_STUN, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
}
void main() {
    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF, "X2_USERDEFINED_ONSPAWN_EVENTS");
    int nID = GetLocalInt(OBJECT_SELF, "ID");


    /* pre spawn event */
    if (nSpecEvent & 1)
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_USER_DEFINED_PRESPAWN));

    if(GetLocalInt(OBJECT_SELF, "Fall"))
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAppear(), OBJECT_SELF);

    //CheckParagon();
    if(nID)
        DelayCommand(1.0f, ApplyDDS(OBJECT_SELF, nID));

    DelayCommand(1.0f, ApplyLocals());
    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "NW_I_WAS_ATTACKED", 1);
    if (GetLocalInt(OBJECT_SELF, "FKY_AI_WALKWAYPOINTS") || GetLocalInt(OBJECT_SELF, "PL_AI_WALKWAY"))
        WalkWayPoints(GetLocalInt(OBJECT_SELF, "RunWaypoints"), 0.0f);

    SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, TRUE);

    if(GetLocalInt(OBJECT_SELF, "Boss")){
        Logger(OBJECT_SELF, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "BOSS SPAWNED : Area: %s, Name: %s",
            GetTag(GetArea(OBJECT_SELF)), GetName(OBJECT_SELF));

        ApplyBossProperties();
    }
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

    //if(GetHitDice(OBJECT_SELF) >= 40)
    //    AddHeals();
    
    if(GetLocalString(OBJECT_SELF, "ES_Spawn") != ""){
        ExecuteScript(GetLocalString(OBJECT_SELF, "ES_Spawn"), OBJECT_SELF);
    }
    else if(GetLocalInt(OBJECT_SELF, "PL_AI_ATTACK_NEAREST")){
        object oEnemy = GetNearestEnemy();
        ActionMoveToObject(oEnemy, TRUE, 2.0f);
        ActionAttack(oEnemy);
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
        //DetermineCombatRound(oEnemy);
    }
    else
        DelayCommand(0.5, DetermineCombatRound());

    /* post spawn event */
    if (nSpecEvent & 2)
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
}

