#include "nwnx_specattack"
#include "pc_funcs_inc"

void main() {
    int nEvent     = GetSpecialAttackEventType();
    if(nEvent == NWNX_SPECIAL_ATTACK_EVENT_RESOLVE)
        return;

    object oTarget = GetSpecialAttackTarget();
    if(oTarget == OBJECT_INVALID)
        return;

    object oPC     = OBJECT_SELF;
    int roll       = GetSpecialAttackRoll();
    int type       = GetSpecialAttackType();
    int bImproved  = FALSE;
    int nLevel     = GetLevelByClass(CLASS_TYPE_PALADIN, oPC) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC);  
    int mod        = GetAbilityModifier(ABILITY_CHARISMA, oPC);


    if(nEvent == NWNX_SPECIAL_ATTACK_EVENT_DAMAGE) {
        int bIgnoreAlign    = FALSE;
        int nDamage         = nLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
        effect eVuln        = EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, 10);
        effect eVis         = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
        effect eDmg;

        if(nLevel >= 35)
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

        Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "SMITE EVIL: Damage: %s, Ignore Alignment: %s",
            IntToString(nDamage), IntToString(bIgnoreAlign));

        eDmg = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE); 
        
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, oTarget, RoundsToSeconds(5));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else if(nEvent == NWNX_SPECIAL_ATTACK_EVENT_AB) {
        return;
    }
}
