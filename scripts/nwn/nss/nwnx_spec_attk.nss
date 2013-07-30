#include "pc_funcs_inc"
#include "gsp_func_inc"

void DoDisarm(object oPC, object oTarget, int nRoll, int bImproved){
    //if(GetLocalInt(oPC, "DisarmDelay"))
    //    return;

    if(GetLocalInt(oTarget, "Boss"))
        return;

    int nLevel = GetHitDice(oTarget);
    int nRoll = Random(100) + 1;

    if(nLevel >= 55 && nRoll <= 95){
        return;
    }
    else if(nLevel >= 50 && nRoll <= 90){
        return;
    }
    else if(nLevel >= 40 && nRoll <= 80){
        return;
    }   

    if(GetSkillCheckResult(SKILL_DISCIPLINE, oTarget, nRoll, TRUE, FALSE, oPC))
        return;

    object oTargetWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    if(oTargetWeapon != OBJECT_INVALID){
        if(GetIsPC(oTarget) && GetItemCursedFlag(oTargetWeapon)){
            SetLocalString(oTargetWeapon, "pc_tag", GetTag(oTarget));
            ErrorMessage(oTarget, "You have been disarmed!");
        }
        ForceUnequipItem(oTarget, oTargetWeapon, FALSE);
    }

    //SetLocalInt(oPC, "DisarmDelay", 1);
    //DelayCommand(IntToFloat(6 + d6()), DeleteLocalInt(oPC, "DisarmDelay"));
}

void DoKnockdown(object oPC, object oTarget, int nRoll, int bImproved){
    if(GetLocalInt(oPC, "KnockdownDelay"))
        return;

    if(GetSkillCheckResult(SKILL_DISCIPLINE, oTarget, nRoll, TRUE, FALSE, oPC))
        return;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1));

    SetLocalInt(oPC, "KnockdownDelay", 1);
    DelayCommand(IntToFloat(6 + d6()), DeleteLocalInt(oPC, "KnockdownDelay"));

}

void DoQuiveringPalm(object oPC, object oTarget){
    if(!GetIsEnemy(oTarget, oPC)) return;

    if(GetLocalInt(oTarget, "Boss"))
        return;

    // Decrement Feat Uses
    DecrementRemainingFeatUses(oPC, FEAT_QUIVERING_PALM);

    int nTouch = TouchAttackMelee(oTarget);
    int nLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nDC = 10 + (nLevel / 2) + GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nChance = (nLevel - 30) * 5;
    int nRoll = d100();

    int bRollSuccess = nRoll <= nChance;

    Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "QUIVERING PALM : DC: %s, bybass roll:" +
        "Chance: %s, Roll: %s", IntToString(nDC), IntToString(nChance), IntToString(nRoll));

    if(!bRollSuccess 
            || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
            || GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT
            || GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oPC)){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
        ApplyVisualToObject(VFX_IMP_DEATH, oTarget);
    }
    if(!GetIsDead(oTarget)){
        int nDamage = d12(nLevel);
        if(nTouch == 2) nDamage = FloatToInt(nDamage * 1.5);

        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
        effect eImpact = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
    }
}

void DoStunningFist(object oPC, object oTarget){
    if(!GetIsEnemy(oTarget, oPC)) return;

    if(GetLocalInt(oTarget, "Boss"))
        return;

    if(GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
        return;

    // Decrement Feat Uses
    //DecrementRemainingFeatUses(oPC, FEAT_STUNNING_FIST);

    int nTouch = TouchAttackMelee(oTarget);
    int nLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    int nDC = 10 + (nLevel / 2) + GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nChance = (nLevel - 20) * 5;
    int nRoll = d100();
    int bRollSuccess = nRoll <= nChance;

    Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "STUNNING FIST : DC: %s, Target Immune to Mind Spells: %s, bybass roll:" +
        "Chance: %s, Roll: %s", IntToString(nDC), IntToString(GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)),
        IntToString(nChance), IntToString(nRoll));


    if(!bRollSuccess || GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        return;

    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC)){
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, RoundsToSeconds(1));
        ApplyVisualToObject(VFX_DUR_PARALYZE_HOLD, oTarget, RoundsToSeconds(1));
    }
}

void DoSmiteEvil(object oPC, object oTarget){
    int bIgnoreAlign    = FALSE;
    int nLevel          = GetLevelByClass(CLASS_TYPE_PALADIN, oPC) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC);
    int nDamage         = nLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eVuln        = EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, 10);
    effect eVis         = EffectVisualEffect(1);
    effect eDmg;

    if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 45 || GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC) >= 35)
        bIgnoreAlign = TRUE;

    if(!bIgnoreAlign && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL){
        ErrorMessage(oPC, "Smite Evil: *FAILED*");
        return;
    }

    if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_10, oPC))
        nDamage += 10 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_9, oPC))
        nDamage += 9 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_8, oPC))
        nDamage += 8 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_7, oPC))
        nDamage += 7 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_6, oPC))
        nDamage += 6 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_5, oPC))
        nDamage += 5 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_4, oPC))
        nDamage += 4 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_3, oPC))
        nDamage += 3 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_2, oPC))
        nDamage += 2 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_1, oPC))
        nDamage += nLevel;

    Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "SMITE EVIL: Damage: %s, Ignore Alignment:",
        IntToString(nDamage), IntToString(bIgnoreAlign));

    eDmg = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE); 
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, oTarget, RoundsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
void DoSmiteGood(object oPC, object oTarget){
    int bIgnoreAlign    = FALSE;
    int nLevel          = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
    int nDamage         = nLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eVuln        = EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE, 10);
    effect eVis         = EffectVisualEffect(1);
    effect eDmg;

    if(nLevel >= 35)
        bIgnoreAlign = TRUE;

    if(!bIgnoreAlign && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD){
        ErrorMessage(oPC, "Smite Good: *FAILED*");
        return;
    }

    if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_10, oPC))
        nDamage += 10 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_9, oPC))
        nDamage += 9 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_8, oPC))
        nDamage += 8 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_7, oPC))
        nDamage += 7 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_6, oPC))
        nDamage += 6 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_5, oPC))
        nDamage += 5 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_4, oPC))
        nDamage += 4 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_3, oPC))
        nDamage += 3 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_2, oPC))
        nDamage += 2 * nLevel;
    else if(GetHasFeat(FEAT_EPIC_GREAT_SMITING_1, oPC))
        nDamage += nLevel;

    Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "SMITE GOOD: Damage: %s, Ignore Alignment:" +
        IntToString(nDamage), IntToString(bIgnoreAlign));

    eDmg = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE); 
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, oTarget, RoundsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

void main(){
    int roll        = GetSpecialAttackRoll();
    int type        = GetSpecialAttackType();
    object oTarget  = GetSpecialAttackTarget();
    object oPC      = OBJECT_SELF;
    int bImproved   = FALSE;
    int nEvent     = GetSpecialAttackEventType();

    if(nEvent != NWNX_SPECIAL_ATTACK_EVENT_RESOLVE)
        return; 
    if(oTarget == OBJECT_INVALID)
        return;

    Logger(oPC, "DebugSpecialAttks", LOGLEVEL_DEBUG, "Type: " + IntToString(type) + " Roll: " + IntToString(roll) + " Target: " + GetName(oTarget));

    switch (type){
        case TA_SPECIAL_ATTACK_AOO:
        case TA_SPECIAL_ATTACK_CLEAVE:
        case TA_SPECIAL_ATTACK_CLEAVE_GREAT:
        case TA_SPECIAL_ATTACK_KI_DAMAGE: // UNUSED
        case TA_SPECIAL_ATTACK_SAP:
            return;
        break;
        case TA_SPECIAL_ATTACK_CALLED_SHOT_ARM:
        break;
        case TA_SPECIAL_ATTACK_CALLED_SHOT_LEG:
        break;
        case TA_SPECIAL_ATTACK_DISARM_IMPROVED:
            bImproved = TRUE;
        case TA_SPECIAL_ATTACK_DISARM:
            DoDisarm(oPC, oTarget, roll, bImproved);
        break;
        case TA_SPECIAL_ATTACK_KNOCKDOWN_IMPROVED:
            bImproved = TRUE;
        case TA_SPECIAL_ATTACK_KNOCKDOWN:
            return;
            //DoKnockdown(oPC, oTarget, roll, bImproved);

        break;
        case TA_SPECIAL_ATTACK_QUIVERING_PALM:
            DoQuiveringPalm(oPC, oTarget);
        break;
        case TA_SPECIAL_ATTACK_SMITE_EVIL:
            DoSmiteEvil(oPC, oTarget);
        break;
        case TA_SPECIAL_ATTACK_SMITE_GOOD:
            DoSmiteGood(oPC, oTarget);
        break;
        case TA_SPECIAL_ATTACK_STUNNING_FIST:
            DoStunningFist(oPC, oTarget);
        break;
    }

}
