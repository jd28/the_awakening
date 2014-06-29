// Include Name: gsp_func_inc
// The following code is hugely derived from code posted to the
// old NWN bioboards which no longer exist, except perhaps in
// archive.org or in some of the compilations of forum posts.

#include "x2_i0_spells"

#include "info_inc"
#include "vfx_inc"
#include "mon_func_inc"
#include "gsp_spinfo_inc"
#include "pc_funcs_inc"
#include "pl_pcinvo_inc"


const int GSP_IMPACT_DEATH_NONE           = 0;
const int GSP_IMPACT_DEATH_NORMAL         = 1;
const int GSP_IMPACT_DEATH_SUPERNATURAL   = 2;

struct FocusBonus {
    int dmg, cap;
};

struct SpellImpact {
    float fDuration, fRadius, fDelayBase;
    int nDurSave, nDurType, nDurSaveType, nSave, nSaveType, nMask, nTargetType, nShape, nDeath, nDurVis, nImpact;
    int nDamType, nDamDice, nDamSides, nDamBonus, nDamBonus2, nDamType2, nDamDice2, nDamVuln;
    int bImm, bUnresistable, bStorm;
    effect eDur;
};

void ApplySpellImpactToTarget(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb, float fDelay = 0.0, int bDebug = TRUE);

// Info
int GetCasterAbilityByClass(struct SpellInfo si);

// Gets Damage power increasing +1 per nPerLevel with a maximum of 1 per 2 levels.
// nBase specifies the minimum damage power.
int GetDamagePower(int nNumber);

// Target / Saves / Spell Resistance checks
int GetIsSpellTarget(struct SpellInfo si, object oTarget, int nTargetType = TARGET_TYPE_STANDARD);

int GetSpellResisted(struct SpellInfo si, object oTarget, float fDelay = 0.0);

int GetSpellSaved(struct SpellInfo si, int nSave, object oTarget, int nSaveType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0);

// Metamagic
float MetaDuration(struct SpellInfo si, int nClevel, int nDurType = DURATION_IN_ROUNDS);
int MetaPower(struct SpellInfo si, int nDamDice, int nDamSides, int nDamBonus, int nFocusBonus);

void GSPApplyEffectsToObject(struct SpellInfo si, int nTargetType, effect eLink, effect eImpact,
                             int nSave, int nSaveType = SAVING_THROW_TYPE_NONE, float fDuration = 0.0,
                             int bHostile = TRUE, int bAreaOfEffect = FALSE, float fRadius = RADIUS_SIZE_LARGE);

void RemoveEffectsOfSpells(object oTarget, int nSpell1, int nSpell2 = -1, int nSpell3 = -1, int nSpell4 = -1);

// Creates a cool down period to stop spell spamming.
void SpellDelay(object oCaster, string sSpellName, int nSpellID, float fCoolDown);

void SendSpellResistanceMessage(object oCaster, object oTarget, int nRoll, int nSP, int nSR, float fDelay);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////


struct SpellImpact CreateSpellImpact(){
    struct SpellImpact impact;

    impact.fDelayBase       = 0.4;
    impact.nShape           = SHAPE_SPHERE;
    impact.fRadius          = RADIUS_SIZE_COLOSSAL;
    impact.nDamSides        = 6;
    impact.nMask            = OBJECT_TYPE_CREATURE;
    impact.nSave            = SAVING_THROW_REFLEX;
    impact.nSaveType        = SAVING_THROW_TYPE_NONE;
    impact.nDamType         = -1;
    impact.nDurType         = 0;

    impact.nTargetType      = TARGET_TYPE_SELECTIVE;

    impact.bStorm           = FALSE;
    impact.bImm             = FALSE;
    impact.bUnresistable    = FALSE;

    impact.nDurSave         = SAVING_THROW_FORT;
    impact.nDurSaveType     = SAVING_THROW_TYPE_NONE;

    return impact;
}

void ApplyDamageIfAlive(object oTarget, effect eDam){
    if(!GetIsDead(oTarget)){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}

void ApplyDurationIfAlive(object oTarget, effect eDam, effect eVis, float fDuration){
    if(!GetIsDead(oTarget)){
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oTarget, fDuration);
    }
}

void ApplyEffectIfAlive(object oTarget, effect eDam, effect eVis){
    if(!GetIsDead(oTarget)){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}

void ApplySpellImpactToAOE(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb, object oAOE){
    float fDelay;
    int nBaseDamage, nDamage, nDamage2;

    effect eDam;
    effect eImpact = EffectVisualEffect(impact.nImpact);

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic AOE: "+IntToString(impact.nShape)+", Radius: " + FloatToString(impact.fRadius, 1, 1) +
            ", Damage: " + IntToString(impact.nDamDice) + "d" + IntToString(impact.nDamSides) +
            "+" + IntToString(impact.nDamBonus) + " " + GetDamageTypeName(impact.nDamType);
        if (impact.nDamVuln > 0)
            sMessage += " (" + IntToString(impact.nDamVuln) + "% vuln)";
        if (impact.nDamDice2 < 0) {
            sMessage += " (1/" + IntToString(-impact.nDamDice2) + " " + GetDamageTypeName(impact.nDamType2) + ")";
        } else if (impact.nDamDice2 > 0) {
            sMessage += " / " + IntToString(impact.nDamDice2) + "d" +
                IntToString(impact.nDamSides) + "+" + IntToString(impact.nDamBonus2) +
                " " + GetDamageTypeName(impact.nDamType2);
        }
        if(impact.nDeath > 0){
            sMessage += ". Death: " + IntToString(impact.nDeath);
        }
        sMessage += ", Save: " + GetSaveName(impact.nSave, TRUE) + "/" + GetSaveTypeName(impact.nSaveType, TRUE);
        sMessage += ", Storm: " + IntToString(impact.bStorm);
        sMessage += ", Mask: " + IntToHexString(impact.nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    if (impact.nSaveType == SAVING_THROW_TYPE_NONE)
        impact.nSaveType = GetSaveType(impact.nDamType);

    for (si.target = GetFirstInPersistentObject(oAOE);
         si.target != OBJECT_INVALID;
         si.target = GetNextInPersistentObject(oAOE)) {

        if (impact.bStorm)
            fDelay = GetRandomDelay(impact.fDelayBase, impact.fDelayBase + 1.0);
        else
            fDelay = GetSpellEffectDelay(si.loc, si.target);

        ApplySpellImpactToTarget(si, impact, fb, fDelay, FALSE);
    }
}

void ApplySpellImpactToShape(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb){
    float fDelay;
    int nBaseDamage, nDamage, nDamage2;

    effect eDam;
    effect eImpact = EffectVisualEffect(impact.nImpact);

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Shape: "+IntToString(impact.nShape)+", Radius: " + FloatToString(impact.fRadius, 1, 1) +
            ", Damage: " + IntToString(impact.nDamDice) + "d" + IntToString(impact.nDamSides) +
            "+" + IntToString(impact.nDamBonus) + " " + GetDamageTypeName(impact.nDamType);
        if (impact.nDamVuln > 0)
            sMessage += " (" + IntToString(impact.nDamVuln) + "% vuln)";
        if (impact.nDamDice2 < 0) {
            sMessage += " (1/" + IntToString(-impact.nDamDice2) + " " + GetDamageTypeName(impact.nDamType2) + ")";
        } else if (impact.nDamDice2 > 0) {
            sMessage += " / " + IntToString(impact.nDamDice2) + "d" +
                IntToString(impact.nDamSides) + "+" + IntToString(impact.nDamBonus2) +
                " " + GetDamageTypeName(impact.nDamType2);
        }
        if(impact.nDeath > 0){
            sMessage += ". Death: " + IntToString(impact.nDeath);
        }
        sMessage += ", Save: " + GetSaveName(impact.nSave, TRUE) + "/" + GetSaveTypeName(impact.nSaveType, TRUE);
        sMessage += ", Storm: " + IntToString(impact.bStorm);
        sMessage += ", Mask: " + IntToHexString(impact.nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }


    if (impact.nSaveType == SAVING_THROW_TYPE_NONE)
        impact.nSaveType = GetSaveType(impact.nDamType);

    for (si.target = GetFirstObjectInShape(impact.nShape, impact.fRadius, si.loc, !impact.bStorm, impact.nMask);
         si.target != OBJECT_INVALID;
         si.target = GetNextObjectInShape(impact.nShape, impact.fRadius, si.loc, !impact.bStorm, impact.nMask)) {

        if (impact.bStorm)
            fDelay = GetRandomDelay(impact.fDelayBase, impact.fDelayBase + 1.0);
        else
            fDelay = GetSpellEffectDelay(si.loc, si.target);

        ApplySpellImpactToTarget(si, impact, fb, fDelay, FALSE);
    }
}

void ApplySpellImpactToTarget(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb, float fDelay = 0.0, int bDebug = TRUE){
    if(GetIsDead(si.target))
        return;

    if(impact.nTargetType != TARGET_TYPE_ALL && !GetIsSpellTarget(si, si.target, impact.nTargetType))
        return;

    int nBaseDamage, nDamage, nDamage2;
    effect eDam;

    if (bDebug && GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Target: "+IntToString(impact.nShape)+
            ", Damage: " + IntToString(impact.nDamDice) + "d" + IntToString(impact.nDamSides) +
            "+" + IntToString(impact.nDamBonus) + " " + GetDamageTypeName(impact.nDamType);
        if (impact.nDamVuln > 0)
            sMessage += " (" + IntToString(impact.nDamVuln) + "% vuln)";
        if (impact.nDamDice2 < 0) {
            sMessage += " (1/" + IntToString(-impact.nDamDice2) + " " + GetDamageTypeName(impact.nDamType2) + ")";
        } else if (impact.nDamDice2 > 0) {
            sMessage += " / " + IntToString(impact.nDamDice2) + "d" +
                IntToString(impact.nDamSides) + "+" + IntToString(impact.nDamBonus2) +
                " " + GetDamageTypeName(impact.nDamType2);
        }
        if(impact.nDeath > 0){
            sMessage += ". Death: " + IntToString(impact.nDeath);
        }
        sMessage += ", Save: " + GetSaveName(impact.nSave, TRUE) + "/" + GetSaveTypeName(impact.nSaveType, TRUE);
        sMessage += ", Storm: " + IntToString(impact.bStorm);
        sMessage += ", Mask: " + IntToHexString(impact.nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    if (impact.nSaveType == SAVING_THROW_TYPE_NONE)
        impact.nSaveType = GetSaveType(impact.nDamType);



    if (impact.nDamType >= 0 && GetIsHealDamage(si.target, impact.nDamType)) {
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        nDamage = MetaPower(si, impact.nDamDice, impact.nDamSides, impact.nDamBonus, fb.dmg);
        eDam    = EffectHeal(nDamage);

        ApplyVisualToObject(VFX_IMP_HEALING_G, si.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
        return;
    }

    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    if(!impact.bUnresistable                       &&
       (GetSpellResisted(si, si.target, fDelay)    ||
       (impact.bImm && GetHasSpellImmunity(si.id, si.target))))
        return;

     if(impact.nDeath > 0
            && !GetLocalInt(si.target, "Boss")
            && !GetSpellSaved(si, impact.nSave, si.target, impact.nSaveType, fDelay)){

        effect eDeath;
	eDeath = EffectDeath();
	SetEffectCreator(eDeath, si.caster);

        if(!GetIsImmune(si.target, IMMUNITY_TYPE_DEATH))
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, si.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), si.target);
    }

    if(impact.nDamType >= 0){
        nBaseDamage = MetaPower(si, impact.nDamDice, impact.nDamSides, impact.nDamBonus, fb.dmg);
        if (impact.nSave == SAVING_THROW_REFLEX) {
            nDamage = GetReflexAdjustedDamage(nBaseDamage, si.target, si.dc, impact.nSaveType);
        } else if (impact.nSave > 0) {
            if (GetSpellSaved(si, impact.nSave, si.target, impact.nSaveType, fDelay))
                nDamage = nBaseDamage / 2;
            else
                nDamage = nBaseDamage;
        } else
            nDamage = nBaseDamage;

        if (nDamage > 0) {
            if (impact.nDamVuln > 0) {
                effect eVuln = EffectDamageImmunityDecrease(impact.nDamType, impact.nDamVuln);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, si.target, 6.0));
            }
            if (impact.nDamDice2 != 0) {
                if (impact.nDamDice2 > 0) {
                    nDamage2 = MetaPower(si, impact.nDamDice2, impact.nDamSides, impact.nDamBonus2, fb.dmg);
                    if (nDamage < nBaseDamage)
                        nDamage2 /= 2;
                } else if (impact.nDamDice2 < 0) {
                    nDamage2 = nDamage / -impact.nDamDice2;
                    nDamage -= nDamage2;
                }
                eDam = EffectDamage(nDamage2, impact.nDamType2);
		SetEffectCreator(eDam, si.caster);
                DelayCommand(fDelay, ApplyDamageIfAlive(si.target, eDam));
            }
            eDam = EffectDamage(nDamage, impact.nDamType);
	    SetEffectCreator(eDam, si.caster);
            DelayCommand(fDelay, ApplyEffectIfAlive(si.target, eDam, EffectVisualEffect(impact.nImpact)));
        }
    }

    if (impact.nDurType > 0
            && !GetHasEffectOfTrueType(impact.nDurType, si.target)
            && (!impact.nDurSave || !GetSpellSaved(si, impact.nDurSave, si.target, impact.nDurSaveType, fDelay)))
       DelayCommand(fDelay, ApplyDurationIfAlive(si.target, impact.eDur, EffectVisualEffect(impact.nDurVis), impact.fDuration));
    else if(impact.nDurType < 0
            && !GetHasSpellEffect(si.id, si.target)
            && (!impact.nDurSave || !GetSpellSaved(si, impact.nDurSave, si.target, impact.nDurSaveType, fDelay)))
       DelayCommand(fDelay, ApplyDurationIfAlive(si.target, impact.eDur, EffectVisualEffect(impact.nDurVis), impact.fDuration));
}

void ApplyTouchImpactToShape(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb, int bMelee = TRUE, int nFeedback = FALSE){
    float fDelay;
    int nTouch;

    int nTargetType      = impact.nTargetType;
    impact.nTargetType   = TARGET_TYPE_ALL;
    impact.bUnresistable = TRUE;

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Shape: "+IntToString(impact.nShape)+", Radius: " + FloatToString(impact.fRadius, 1, 1) +
            ", Damage: " + IntToString(impact.nDamDice) + "d" + IntToString(impact.nDamSides) +
            "+" + IntToString(impact.nDamBonus) + " " + GetDamageTypeName(impact.nDamType);
        if (impact.nDamVuln > 0)
            sMessage += " (" + IntToString(impact.nDamVuln) + "% vuln)";
        if (impact.nDamDice2 < 0) {
            sMessage += " (1/" + IntToString(-impact.nDamDice2) + " " + GetDamageTypeName(impact.nDamType2) + ")";
        } else if (impact.nDamDice2 > 0) {
            sMessage += " / " + IntToString(impact.nDamDice2) + "d" +
                IntToString(impact.nDamSides) + "+" + IntToString(impact.nDamBonus2) +
                " " + GetDamageTypeName(impact.nDamType2);
        }
        if(impact.nDeath > 0){
            sMessage += ". Death: " + IntToString(impact.nDeath);
        }
        sMessage += ", Save: " + GetSaveName(impact.nSave, TRUE) + "/" + GetSaveTypeName(impact.nSaveType, TRUE);
        sMessage += ", Storm: " + IntToString(impact.bStorm);
        sMessage += ", Mask: " + IntToHexString(impact.nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    for (si.target = GetFirstObjectInShape(impact.nShape, impact.fRadius, si.loc, !impact.bStorm, impact.nMask);
         si.target != OBJECT_INVALID;
         si.target = GetNextObjectInShape(impact.nShape, impact.fRadius, si.loc, !impact.bStorm, impact.nMask)) {

        if (!GetIsSpellTarget(si, si.target, nTargetType))
            continue;

        fDelay = GetSpellEffectDelay(si.loc, si.target);
        if(bMelee)
            nTouch = TouchAttackMelee(si.target, nFeedback);
        else
            nTouch = TouchAttackRanged(si.target, nFeedback);

        if(nTouch <= 0)
            continue;
        else if (nTouch == 2)
            si.meta |= METAMAGIC_EMPOWER;

        ApplySpellImpactToTarget(si, impact, fb, fDelay, FALSE);
    }
}

void ApplyTouchImpactToTarget(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb, int bMelee = TRUE, int nFeedback = FALSE){
    int nTouch;

    int nTargetType      = impact.nTargetType;
    impact.nTargetType   = TARGET_TYPE_ALL;
    impact.bUnresistable = TRUE;

    if (!GetIsSpellTarget(si, si.target, nTargetType))
        return;

    if(bMelee)
        nTouch = TouchAttackMelee(si.target, nFeedback);
    else
        nTouch = TouchAttackRanged(si.target, nFeedback);

    if(nTouch <= 0)
        return;
    else if (nTouch == 2)
        si.meta |= METAMAGIC_EMPOWER;

    ApplySpellImpactToTarget(si, impact, fb);
}

int GetCasterAbilityByClass(struct SpellInfo si){
    switch(si.class){
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER: return GetAbilityScore(si.caster, ABILITY_CHARISMA);
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:   return GetAbilityScore(si.caster, ABILITY_WISDOM);
        case CLASS_TYPE_WIZARD:   return GetAbilityScore(si.caster, ABILITY_INTELLIGENCE);
    }
    return -1;
}

int GetIsSpellTarget(struct SpellInfo si, object oTarget, int nTargetType = TARGET_TYPE_STANDARD){
    // * if dead, not a valid target
    if (GetIsDead(oTarget) == TRUE) return FALSE;

    int nReturnValue = FALSE;

    switch (nTargetType){
        // * this kind of spell will affect all friendlies and anyone in my
        // * party, even if we are upset with each other currently.
        case TARGET_TYPE_ALL:
            nReturnValue = TRUE;
        break;
        case TARGET_TYPE_ALLIES:
            if(GetIsReactionTypeFriendly(oTarget, si.caster) || GetFactionEqual(oTarget, si.caster))
                nReturnValue = TRUE;
        break;
        case TARGET_TYPE_STANDARD:
        {
            //SpawnScriptDebugger();
            int bPC = GetIsPC(oTarget);
            int bNotAFriend = FALSE;
            int bReactionType = GetIsReactionTypeFriendly(oTarget, si.caster);
            if (bReactionType == FALSE) bNotAFriend = TRUE;

            // * Local Override is just an out for end users who want
            // * the area effect spells to hurt 'neutrals'
            if (GetLocalInt(GetModule(), "X0_G_ALLOWSPELLSTOHURT") == 10)
            {
                bPC = TRUE;
            }

            int bSelfTarget = FALSE;
            object oMaster = GetMaster(oTarget);

            if(SPELLS_HURT_CASTER){
                if (oTarget == si.caster) bSelfTarget = TRUE; // Hurt Self.
                else if (oMaster == si.caster) bSelfTarget = TRUE; // Hurt associates.
            }

            // April 9 2003
            // Hurt the associates of a hostile player
            if (bSelfTarget == FALSE && GetIsObjectValid(oMaster) == TRUE)
            {
                // * I am an associate
                // * of someone
                if ((GetIsReactionTypeFriendly(oMaster,si.caster) == FALSE && GetIsPC(oMaster) == TRUE)
                    || GetIsReactionTypeHostile(oMaster,si.caster) == TRUE)
                {
                    bSelfTarget = TRUE;
                }
            }


            // Assumption: In Full PvP players, even if in same party, are Neutral
            // * GZ: 2003-08-30: Patch to make creatures hurt each other in hardcore mode...

            if (GetIsReactionTypeHostile(oTarget,si.caster)){
                nReturnValue = TRUE;         // Hostile creatures are always a target
            }
            else if (bSelfTarget == TRUE){
                nReturnValue = TRUE;         // Targetting Self (set above)?
            }
            else if (bPC && bNotAFriend){
                nReturnValue = TRUE;         // Enemy PC
            }
            else if (bNotAFriend && (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL))
            {
                if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES) == TRUE)
                {
                    nReturnValue = TRUE;        // Hostile Creature and Difficulty > Normal
                }                               // note that in hardcore mode any creature is hostile
            }
            break;
        }
        // * only harms enemies, ever
        // * current list:call lightning, isaac missiles, firebrand, chain lightning, dirge, Nature's balance,
        // * Word of Faith
        case TARGET_TYPE_SELECTIVE:
            if(GetIsEnemy(oTarget, si.caster))
                nReturnValue = TRUE;
        break;
    }

    // GZ: Creatures with the same master will never damage each other
    if (GetMaster(oTarget) != OBJECT_INVALID && GetMaster(si.caster) != OBJECT_INVALID )
    {
        if (GetMaster(oTarget) == GetMaster(si.caster))
        {
            if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE) == 0 )
                nReturnValue = FALSE;
        }
    }

    return nReturnValue;
}

// Original Author: Acaos, Found on Bioboards.
int GetSpellResisted(struct SpellInfo si, object oTarget, float fDelay = 0.0){
    int nSR = 0, nResisted = 0;
    if (!GetIsObjectValid(oTarget))
        oTarget = si.target;
    if (!GetIsObjectValid(oTarget))
        return 0;
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        nSR = GetSpellResistance(oTarget);
    else
        nSR = GetLocalInt(oTarget, "SR");

    if (nSR > 0 && si.sp >= 0 && !GetFactionEqual(si.caster, oTarget)) {
        int nRoll = d20(1);
        SendSpellResistanceMessage(si.caster, oTarget, nRoll, si.sp, nSR, fDelay);
        if (si.sp + nRoll < nSR)
            nResisted = 1;
    }
    if (nResisted == 0) {
        switch (ResistSpell(si.caster, oTarget)) {
            case 2:  /* globe or spell immunity */
                nResisted = 2;
                break;
            case 3:  /* spell mantle */
                if (si.sp >= 0)
                    nResisted = 3;
                break;
        }
    }
    if (!nResisted)
        return 0;
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
        effect eVis;
        switch (nResisted) {
            case 2:
                eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
                break;
            case 3:
                eVis = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
                break;
            default:
                eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
                break;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return nResisted;
}

int GetSpellSaved(struct SpellInfo si, int nSave, object oTarget, int nSaveType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0){
    effect eVis;
    int bValid = FALSE;

    if(nSave == SAVING_THROW_FORT){
        bValid = FortitudeSave(oTarget, si.dc, nSaveType, si.caster);
    }
    else if(nSave == SAVING_THROW_REFLEX){
        bValid = ReflexSave(oTarget, si.dc, nSaveType, si.caster);
    }
    else if(nSave == SAVING_THROW_WILL){
        bValid = WillSave(oTarget, si.dc, nSaveType, si.caster);
    }

    if(bValid == 1) eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);

    if(bValid == 0){ // return 0 = FAILED SAVE
    /*
        if((nSaveType == SAVING_THROW_TYPE_DEATH
           || si.id == SPELL_WEIRD
            || si.id == SPELL_FINGER_OF_DEATH) &&
           si.id != SPELL_HORRID_WILTING)
        {
            eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    */
    }
    if(bValid == 1 || bValid == 2){ // return 1 = SAVE SUCCESSFUL
        if(bValid == 2){ // return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
            eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            /*
            If the spell is save immune then the link must be applied in order to get the true immunity
            to be resisted.  That is the reason for returing false and not true.  True blocks the
            application of effects.
            */
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

struct FocusBonus GetOffensiveFocusBonus(object oCaster, int nSchool, int nCap){
    int sf, gsf, esf;
    struct FocusBonus fb;
    int nFocusDamage;

    // Make sure if there is no cap, it can never be reached.
    if (nCap == 0) nCap = 100;

    switch(nSchool){
        case SPELL_SCHOOL_NECROMANCY:
            sf = FEAT_SPELL_FOCUS_NECROMANCY;
            gsf = FEAT_GREATER_SPELL_FOCUS_NECROMANCY;
            esf = FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
        break;
        case SPELL_SCHOOL_ILLUSION:
            sf = FEAT_SPELL_FOCUS_ILLUSION;
            gsf = FEAT_GREATER_SPELL_FOCUS_ILLUSION;
            esf = FEAT_EPIC_SPELL_FOCUS_ILLUSION;
        break;
        case SPELL_SCHOOL_EVOCATION:
            sf = FEAT_SPELL_FOCUS_EVOCATION;
            gsf = FEAT_GREATER_SPELL_FOCUS_EVOCATION;
            esf = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
        break;
        case SPELL_SCHOOL_ABJURATION:
            sf = FEAT_SPELL_FOCUS_ABJURATION;
            gsf = FEAT_GREATER_SPELL_FOCUS_ABJURATION;
            esf = FEAT_EPIC_SPELL_FOCUS_ABJURATION;
        break;
        case SPELL_SCHOOL_TRANSMUTATION:
            sf = FEAT_SPELL_FOCUS_TRANSMUTATION;
            gsf = FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION;
            esf = FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
        break;
    }

    if(GetHasFeat(sf, oCaster))
        nFocusDamage += 5;

    if(GetHasFeat(gsf, oCaster)){
        if(nCap == 60)
            nFocusDamage += 10;
        else
            nCap += 10;
    }

    if(GetHasFeat(esf, oCaster))
        nFocusDamage += 25;

    fb.dmg = nFocusDamage;
    fb.cap = nCap;

    return fb;
}


float MetaDuration(struct SpellInfo si, int nClevel, int nDurType = DURATION_IN_ROUNDS){
    int nDur = nClevel;

    if(si.meta == METAMAGIC_EXTEND){
        nDur *= 2;
    }

    if(nDurType == DURATION_IN_ROUNDS) return RoundsToSeconds(nDur);
    else if(nDurType == DURATION_IN_HOURS) return HoursToSeconds(nDur);
    else if(nDurType == DURATION_IN_TURNS) return TurnsToSeconds(nDur);

    return 0.0;
}

int MetaPower(struct SpellInfo si, int nDamDice, int nDamSides, int nDamBonus, int nFocusBonus){
    int nDam = 0;

    if(si.meta == METAMAGIC_MAXIMIZE)
        return (nDamDice * nDamSides) + nDamBonus;

    // Roll our own dice...
    do
        nDam += Random(nDamSides) + 1;
    while ( --nDamDice > 0 );

    if(si.meta == METAMAGIC_EMPOWER)
        return nDam = nDam + (nDam / 2) + nDamBonus;

    return nDam + nDamBonus + ((nDam * nFocusBonus) / 100);
}

void RemoveEffectsOfSpells(object oTarget, int nSpell1, int nSpell2 = -1, int nSpell3 = -1, int nSpell4 = -1){
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)){
        if (GetEffectSpellId(eEff) == nSpell1 ||
            (nSpell2 > 0 && GetEffectSpellId(eEff) == nSpell2) ||
            (nSpell3 > 0 && GetEffectSpellId(eEff) == nSpell3) ||
            (nSpell4 > 0 && GetEffectSpellId(eEff) == nSpell4))
        {
            RemoveEffect(oTarget,eEff);
        }
        eEff = GetNextEffect(oTarget);
    }
}

void SendSpellResistanceMessage(object oCaster, object oTarget, int nRoll, int nSP, int nSR, float fDelay){
    string sMessage;

    if(nSP + nRoll <  nSR){
        sMessage = (IntToString(nRoll) + " + " + IntToString(nSP) + " = "
            + IntToString(nRoll + nSP) + " vs. Spell Resistance " + IntToString(nSR)
            + " :  Resisted Spell.");
    }
    else {
        sMessage = (IntToString(nRoll) + " + " + IntToString(nSP) + " = "
            + IntToString(nRoll + nSP) + " vs. Spell Resistance " + IntToString(nSR)
            + " :  Spell Resistance Defeated.");
    }

    sMessage = C_LT_PURPLE + sMessage + C_END;

    if(GetIsPC(oCaster))
        DelayCommand(fDelay, SendMessageToPC(oCaster, sMessage));
    if(GetIsPC(oTarget))
        DelayCommand(fDelay, SendMessageToPC(oTarget, sMessage));

}

void SpellDelay(object oCaster, string sSpellName, int nSpellID, float fCoolDown){
    float Delay1    = fCoolDown * 0.25;
    string Message1 = IntToString(FloatToInt(Delay1));
    float Delay2    = fCoolDown * 0.50;
    string Message2 = IntToString(FloatToInt(Delay2));
    float Delay3    = fCoolDown * 0.75;
    string Message3 = IntToString(FloatToInt(Delay3));

    SetLocalInt(oCaster, "SPELL_DELAY_" + IntToString(nSpellID), 1);
    DelayCommand(Delay1, SendMessageToPC(oCaster, C_RED + sSpellName + " Recastable In " + Message3 + " seconds"+C_END));
    DelayCommand(Delay2, SendMessageToPC(oCaster, C_RED + sSpellName + " Recastable In " + Message2 + " seconds"+C_END));
    DelayCommand(Delay3, SendMessageToPC(oCaster, C_RED + sSpellName + " Recastable In " + Message1 + " seconds"+C_END));
    DelayCommand(fCoolDown, SendMessageToPC(oCaster, C_GREEN + sSpellName + " Ready"+C_END));
    DelayCommand(fCoolDown, DeleteLocalInt(oCaster, "SPELL_DELAY_" + IntToString(nSpellID)));
}

// Gets Damage power increasing +1 per nPerLevel with a maximum of 1 per 2 levels.
// nBase specifies the minimum damage power.
int GetDamagePower(int nNumber){
    switch(nNumber){
        case 1:  return DAMAGE_POWER_PLUS_ONE;
        case 2:  return DAMAGE_POWER_PLUS_TWO;
        case 3:  return DAMAGE_POWER_PLUS_THREE;
        case 4:  return DAMAGE_POWER_PLUS_FOUR;
        case 5:  return DAMAGE_POWER_PLUS_FIVE;
        case 6:  return DAMAGE_POWER_PLUS_SIX;
        case 7:  return DAMAGE_POWER_PLUS_SEVEN;
        case 8:  return DAMAGE_POWER_PLUS_EIGHT;
        case 9:  return DAMAGE_POWER_PLUS_NINE;
        case 10: return DAMAGE_POWER_PLUS_TEN;
        case 11: return DAMAGE_POWER_PLUS_ELEVEN;
        case 12: return DAMAGE_POWER_PLUS_TWELVE;
        case 13: return DAMAGE_POWER_PLUS_THIRTEEN;
        case 14: return DAMAGE_POWER_PLUS_FOURTEEN;
        case 15: return DAMAGE_POWER_PLUS_FIFTEEN;
        case 16: return DAMAGE_POWER_PLUS_SIXTEEN;
        case 17: return DAMAGE_POWER_PLUS_SEVENTEEN;
        case 18: return DAMAGE_POWER_PLUS_EIGHTEEN;
        case 19: return DAMAGE_POWER_PLUS_NINTEEN;
        case 20: return DAMAGE_POWER_PLUS_TWENTY;
    }
    return DAMAGE_POWER_PLUS_ONE;
}

int GetDamageBonus(int nNumber){
    switch(nNumber){
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11: return DAMAGE_BONUS_11;
        case 12: return DAMAGE_BONUS_12;
        case 13: return DAMAGE_BONUS_13;
        case 14: return DAMAGE_BONUS_14;
        case 15: return DAMAGE_BONUS_15;
        case 16: return DAMAGE_BONUS_16;
        case 17: return DAMAGE_BONUS_17;
        case 18: return DAMAGE_BONUS_18;
        case 19: return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;
    }
    return DAMAGE_BONUS_1;
}
void GSPApplyEffectsToObject(struct SpellInfo si, int nTargetType, effect eLink, effect eImpact,
                             int nSave, int nSaveType = SAVING_THROW_TYPE_NONE, float fDuration = 0.0,
                             int bHostile = TRUE, int bAreaOfEffect = FALSE, float fRadius = RADIUS_SIZE_LARGE){

    float fDelay;

    if(!bAreaOfEffect){
        if(GetIsSpellTarget(si, si.target, nTargetType)){
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, bHostile));
            //Make SR Check
            if(!bHostile || !GetSpellResisted(si, si.target, fDelay)){
                //Make a will save
                if(!bHostile || !GetSpellSaved(si, SAVING_THROW_WILL, si.target, nSaveType, fDelay)){
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, si.target, fDuration));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration));
                }
            }

        }
        return;
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, TRUE);
    while(GetIsObjectValid(oTarget)){
        if (GetIsSpellTarget(si, oTarget, nTargetType)){
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, bHostile));
            //Make SR Check
            if(!bHostile || !GetSpellResisted(si, oTarget, fDelay)){
                //Make a will save
                if(!bHostile || !GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_FEAR, fDelay)){
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImpact, oTarget, fDuration));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, TRUE);
    }
}


void Restore(struct SpellInfo si, int bRestor = FALSE, int bGrtRestor = FALSE){
    int nEType;
    effect eBad = GetFirstEffect(si.target);

    //Search for negative effects
    while(GetIsEffectValid(eBad)){
        nEType = GetEffectType(eBad);
            //Lesser Restore
        if (nEType == EFFECT_TYPE_ABILITY_DECREASE ||
            nEType == EFFECT_TYPE_AC_DECREASE ||
            nEType == EFFECT_TYPE_ATTACK_DECREASE ||
            nEType == EFFECT_TYPE_DAMAGE_DECREASE ||
            nEType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            nEType == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            nEType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            nEType == EFFECT_TYPE_SKILL_DECREASE ||
            //Restore
            (nEType == EFFECT_TYPE_BLINDNESS && (bRestor || bGrtRestor)) ||
            (nEType == EFFECT_TYPE_DEAF && (bRestor || bGrtRestor))  ||
            (nEType == EFFECT_TYPE_NEGATIVELEVEL && (bRestor || bGrtRestor)) ||
            (nEType == EFFECT_TYPE_PARALYZE && (bRestor || bGrtRestor))  ||
            //Greater Restore
            (nEType == EFFECT_TYPE_CURSE && bGrtRestor) ||
            (nEType == EFFECT_TYPE_DISEASE && bGrtRestor) ||
            (nEType == EFFECT_TYPE_POISON && bGrtRestor) ||
            (nEType == EFFECT_TYPE_PARALYZE && bGrtRestor) ||
            (nEType == EFFECT_TYPE_CHARMED && bGrtRestor) ||
            (nEType == EFFECT_TYPE_DOMINATED && bGrtRestor) ||
            (nEType == EFFECT_TYPE_DAZED && bGrtRestor) ||
            (nEType == EFFECT_TYPE_CONFUSED && bGrtRestor) ||
            (nEType == EFFECT_TYPE_FRIGHTENED && bGrtRestor) ||
            (nEType == EFFECT_TYPE_SLOW && bGrtRestor) ||
            (nEType == EFFECT_TYPE_STUNNED && bGrtRestor))
        {
            RemoveEffect(si.target, eBad);
        }
        eBad = GetNextEffect(si.target);
    }
}

void GSPMagicFang(struct SpellInfo si){
    //Declare major variables
    object oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

    int nAttack, nAC, nHP, nDamage;
    effect eAttack, eAC, eHP, eDamage, eLink;
    float fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);

    if (GetIsObjectValid(oTarget) == FALSE){
            FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
            return; // has neither an animal companion
    }

    //Remove effects of anyother fang spells
    RemoveSpellEffects(SPELL_MAGIC_FANG, GetMaster(oTarget), oTarget);
    RemoveSpellEffects(SPELL_GREATER_MAGIC_FANG, GetMaster(oTarget), oTarget);
    RemoveSpellEffects(SPELL_AWAKEN, GetMaster(oTarget), oTarget);

    if(si.id == SPELL_MAGIC_FANG){
        nAttack = 2;
        nAC = 4;
        nHP = d4((si.clevel > 20) ? 20 : si.clevel);
    }
    else if(si.id == SPELL_GREATER_MAGIC_FANG){
        nAttack = 3;
        nAC = 6;
        nHP = si.clevel * 5;
        nDamage = DAMAGE_BONUS_2d6;
    }
    else{ // Awaken
        nAttack = 6;
        nAC = 8;
        nHP = si.clevel * 8;
        nDamage = DAMAGE_BONUS_2d12;
    }

    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = eDur;
    if(nAttack > 0){
        eAttack = EffectAttackIncrease(nAttack);
        eLink = EffectLinkEffects(eAttack, eLink);
    }
    if(nAC > 0){
        eAC = EffectACIncrease(nAC);
        eLink = EffectLinkEffects(eAC, eLink);
    }
    if(nHP > 0){
        eHP = EffectTemporaryHitpoints(nHP);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration);
    }
    if(nDamage > 0){
        eDamage = EffectDamageIncrease(nDamage);
        eLink = EffectLinkEffects(eLink, eDamage);
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

}

void GSPScaleSummon(int nCasterLevel, object oSelf){
    effect eEff;
    // Haste
    eEff = SupernaturalEffect(EffectHaste());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);

    ApplyAbilities(oSelf, 12, 12, 12, 12, 12, 12);

    switch(nCasterLevel / 6){
        case 0:
            // Nothing
        break;
        case 1:
            ApplyACBonus(oSelf, 1, 1, 1);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
        break;
        case 2:
            ApplyPhysicalResistance(oSelf, 5, 5, 5);
            ApplyACBonus(oSelf, 2, 2, 2);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyPhysicalImmunities(oSelf, 5, 5, 5);
            ApplySight(oSelf, TRUE);
        break;
        case 3:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 3, 3, 3);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 5, 5, 5, 5, 5);
            ApplyElementalImmunities(oSelf, 10, 10, 10, 10, 10);
            ApplyExoticImmunities(oSelf, 10, 10, 10, 10);
            ApplyPhysicalImmunities(oSelf, 10, 10, 10);
        break;
        case 4:
            ApplyPhysicalResistance(oSelf, 10, 10, 10);
            ApplyACBonus(oSelf, 4, 4, 4);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 10, 10, 10, 10, 10);
            ApplyElementalImmunities(oSelf, 20, 20, 20, 20, 20);
            ApplyExoticImmunities(oSelf, 20, 20, 20, 20);
            ApplyPhysicalImmunities(oSelf, 20, 20, 20);
            ApplySight(oSelf, TRUE);
        break;
        case 5:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 5, 5, 5);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 25, 25, 25, 25, 25);
            ApplyExoticImmunities(oSelf, 25, 25, 25, 25);
            ApplyPhysicalImmunities(oSelf, 25, 25, 25);
            ApplySight(oSelf, TRUE);
        break;
        case 6:
            ApplyPhysicalResistance(oSelf, 15, 15, 15);
            ApplyACBonus(oSelf, 6, 6, 6);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_DEATH, IMMUNITY_TYPE_CHARM, IMMUNITY_TYPE_DOMINATE, IMMUNITY_TYPE_FEAR);
            ApplyMiscImmunities(oSelf, IMMUNITY_TYPE_KNOCKDOWN);
            ApplyElementalResistance(oSelf, 15, 15, 15, 15, 15);
            ApplyElementalImmunities(oSelf, 30, 30, 30, 30, 30);
            ApplyExoticImmunities(oSelf, 30, 30, 30, 30);
            ApplyPhysicalImmunities(oSelf, 30, 30, 30);
            ApplySight(oSelf, TRUE);
        break;
    }

}

int GetHighestCasterAbility(object oCaster);
int GetHighestCasterAbility(object oCaster){
    int nWis = GetAbilityScore(oCaster, ABILITY_WISDOM, TRUE);
    int nCha = GetAbilityScore(oCaster, ABILITY_CHARISMA, TRUE);
    int nInt = GetAbilityScore(oCaster, ABILITY_INTELLIGENCE, TRUE);

    if(nWis > nCha && nWis > nInt)
        return ABILITY_WISDOM;
    else if(nCha > nWis && nCha > nInt)
        return ABILITY_CHARISMA;

    return ABILITY_INTELLIGENCE;
}



int CreateShadow(object oTarget, int nCasterLevel, string sName, int nAppearance = -1, int nPortrait = -1, string sDesc = "", object oPC = OBJECT_SELF);
int CreateShadow(object oTarget, int nCasterLevel, string sName, int nAppearance = -1, int nPortrait = -1, string sDesc = "", object oPC = OBJECT_SELF){

    if (GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 0 || GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) > 0){
        SendMessageToPC(oPC, C_RED+"Druids and Shifters are unable to use this ability!"+C_END);
        return FALSE;
    }
    else if(GetIsPCShifted(oPC) || GetIsPCShifted(oTarget)){
        SendMessageToPC(oPC, C_RED+"You can't use this feat while polymorphed"+C_END);
        return FALSE;
    }
    object oShade = GetLocalObject(oPC, "X0_L_MYSHADE");
    if(GetIsObjectValid(oShade)){
        AssignCommand(oShade, SetIsDestroyable(TRUE));
        ApplyVisualToObject(VFX_IMP_UNSUMMON, oShade);
        DestroyObject(oShade);
    }

    oShade = CopyObject(oTarget, GetSpellTargetLocation(), OBJECT_INVALID, "SDCLONE" + GetName(oPC));
	SetLocalInt(oShade, "TA_CLONE", TRUE);
	SetCurrentHitPoints(oShade, SetMaxHitPoints (oShade, GetMaxHitPoints(oTarget)));
    SetName(oShade, sName);

    if(nAppearance >= 0)
        SetCreatureAppearanceType(oShade, nAppearance);

    if(nPortrait >= 0)
        SetPortraitId(oShade, nPortrait);

    if(sDesc != "")
        SetDescription(oShade, sDesc);

    AddHenchman(oPC, oShade);
    SetCreatureEventHandler(oShade, CREATURE_EVENT_ATTACKED, "x0_ch_hen_attack");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_BLOCKED, "x0_ch_hen_block");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_CONVERSATION, "x0_hen_conv");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_DAMAGED, "x0_ch_hen_damage");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_DEATH, "x2_hen_death");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_DISTURBED, "x0_ch_hen_distrb");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_ENDCOMBAT, "x0_ch_hen_combat");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_HEARTBEAT, "x0_ch_hen_heart");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_PERCEPTION, "x0_ch_hen_percep");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_RESTED, "x0_ch_hen_rest");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_SPAWN, "x0_ch_hen_spawn");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_SPELLCAST, "x2_hen_spell");
    SetCreatureEventHandler(oShade, CREATURE_EVENT_USERDEF, "x0_ch_hen_usrdef");

    SetLocalInt(oShade, "X2_L_BEH_OFFENSE", TRUE);

    object oItem = GetFirstItemInInventory(oShade);
    while(oItem != OBJECT_INVALID){
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oShade);
    }
    int i;
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++){
        oItem = GetItemInSlot(i, oShade);

        if(i == INVENTORY_SLOT_ARMS && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oShade)))
        {
            DestroyObject(oItem);
            continue;
        }
        else if(i == INVENTORY_SLOT_BELT || i == INVENTORY_SLOT_BOOTS ||
                i == INVENTORY_SLOT_LEFTRING || i == INVENTORY_SLOT_RIGHTRING ||
                i == INVENTORY_SLOT_NECK)
        {
            DestroyObject(oItem);
            continue;
        }
        else if (i == INVENTORY_SLOT_CHEST ||
                 i == INVENTORY_SLOT_CLOAK ||
                 i == INVENTORY_SLOT_HEAD ||
                 (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) ||
                 (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) ||
                 (i == INVENTORY_SLOT_LEFTHAND && GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD) ||
                 (i == INVENTORY_SLOT_BULLETS && GetBaseItemType(oItem) == BASE_ITEM_HELMET))
        {
            RemoveAllItemProperties(oItem);
        }

        SetDroppableFlag(oItem, FALSE);
        SetPickpocketableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
    }
    TakeGoldFromCreature(GetGold(oShade), oShade, TRUE);
    if(oTarget == oPC)
        SetLocalInt(oShade, "X0_L_MYTIMERTOEXPLODE", 50);
    else
        SetLocalInt(oShade, "X0_L_MYTIMERTOEXPLODE", 25);

    SetLocalObject(oShade, "X0_L_MYMASTER", oPC);
    SetLocalObject(oPC, "X0_L_MYSHADE", oShade);
    AssignCommand(oShade, SetIsDestroyable(TRUE));

    GSPScaleSummon(nCasterLevel, oShade);

    return TRUE;
}

effect GetScaledConcealmentEffect(object oPC, int nSkill, int nPerPoint = 1, int bBase = TRUE, int nCap = 60){
    int nRank = GetSkillRank(nSkill, oPC, bBase);
    int nConceal = nRank / nPerPoint;

    if (nConceal > nCap)
        nConceal = nCap;

    return EffectConcealment(nConceal);
}

effect GetScaledDamageReductionEffect(object oPC, int nSkill, int nSoak, int nPerPoint = 5, int bBase = TRUE){
    int nRank = GetSkillRank(nSkill, oPC, bBase);
    int nLimit = nRank * nPerPoint;
    int nPower = GetDamagePowerFromNumber( GetLevelIncludingLL(oPC) / 6);

    return EffectDamageReduction(nSoak, nPower, nLimit);
}

int GetSubraceSpellDC(int clevel){
    if(clevel >= 51)
        return 60;
    else if(clevel >= 41)
        return 55;
    else if(clevel >= 31)
        return 50;
    else if(clevel >= 21)
        return 45;
    else if(clevel >= 11)
        return 30;
    else
        return 20;
}

void Cure(struct SpellInfo si, int nDamage, int nHarmImpact, int nHealImpact){

    effect eHeal, eDam;

    if (GetRacialType(si.target) != RACIAL_TYPE_UNDEAD){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), si.target);
        ApplyVisualToObject(nHealImpact, si.target);
    }
    //Check that the target is undead
    else{
        if(TouchAttackMelee(si.target) > 0 && GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)){
            if(si.id == SPELL_HEAL) nDamage = GetCurrentHitPoints(si.target) - d4();
            //Fire cast spell at event for the specified target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
            if (!GetSpellResisted(si, si.target)){
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                ApplyVisualToObject(nHarmImpact, si.target);
            }
        }
    }
}

void Harm(struct SpellInfo si, int nDamage, int nHarmImpact, int nHealImpact){

    effect eHeal, eDam;

    if (GetRacialType(si.target) == RACIAL_TYPE_UNDEAD){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDamage), si.target);
        ApplyVisualToObject(nHealImpact, si.target);
    }
    //Check that the target is undead
    else{
        if(TouchAttackMelee(si.target) > 0 && GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)){
            //Fire cast spell at event for the specified target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
            if (!GetSpellResisted(si, si.target)){
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                ApplyVisualToObject(nHarmImpact, si.target);
            }
        }
    }
}

float GetPersistentAoEDuration (struct SpellInfo si){
    int base = 5;
    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, si.caster))
        base += 5;

    return MetaDuration(si, base, DURATION_IN_ROUNDS);
}
