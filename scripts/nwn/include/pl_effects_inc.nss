// pl_effects_inc

#include "nwnx_structs"
#include "nwnx_effects"

const int CUSTOM_EFFECT_TYPE_CRIT_DMG_BONUS            = 98;
const int CUSTOM_EFFECT_TYPE_CRIT_DMG_PENALTY          = 99;
const int CUSTOM_EFFECT_TYPE_CRIT_THREAT_BONUS         = 100;
const int CUSTOM_EFFECT_TYPE_CRIT_THREAT_PENALTY       = 101;
const int CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL       = 102;
const int CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL  = 103;
const int CUSTOM_EFFECT_TYPE_DMG_PERCENT_BONUS         = 104;
const int CUSTOM_EFFECT_TYPE_DMG_PERCENT_PENALTY       = 105;
const int CUSTOM_EFFECT_TYPE_GOLD_BONUS                = 106;
const int CUSTOM_EFFECT_TYPE_GOLD_PENALTY              = 107;
const int CUSTOM_EFFECT_TYPE_HITPOINTS                 = 108;
const int CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE         = 109;
const int CUSTOM_EFFECT_TYPE_MOVEMENT_BONUS            = 110;
const int CUSTOM_EFFECT_TYPE_MOVEMENT_PENALTY          = 111;
const int CUSTOM_EFFECT_TYPE_MOVEMENT_RATE             = 112;
const int CUSTOM_EFFECT_TYPE_RECURRING                 = 113;
const int CUSTOM_EFFECT_TYPE_SPELL_DAMAGE_BONUS        = 114;
const int CUSTOM_EFFECT_TYPE_SPELL_DAMAGE_PENALTY      = 115;
const int CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE         = 116;
const int CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE         = 117;
const int CUSTOM_EFFECT_TYPE_STACKING_DMG_REDUCTION    = 118;
const int CUSTOM_EFFECT_TYPE_STACKING_DMG_RESISTANCE   = 119;
const int CUSTOM_EFFECT_TYPE_XP_BONUS                  = 120;
const int CUSTOM_EFFECT_TYPE_XP_PENALTY                = 121;


effect EffectAdditionalAttacks(int nAmount);
effect EffectBonusFeat (int nFeat);
effect EffectDCIncrease(int nAmount);
effect EffectDCDecrease(int nAmount);
effect EffectIcon (int nIcon);
effect EffectImmunityDecrease (int nImmunity, int nVuln);
effect EffectMovementRate(int nRate);
effect EffectPermenantHitpoints(int nHitpoints);
effect EffectWounding (int nAmount);


/*
effect EffectOathOfWrath(int nAmount);
effect EffectOffhandAttackIncrease(int nAttacks);
effect EffectOnhandAttackIncrease(int nAttacks);
*/

effect EffectBonusFeat (int nFeat) {
    effect eEff = EffectVisualEffect(nFeat);

    SetEffectTrueType(eEff, EFFECT_TRUETYPE_BONUS_FEAT);
    return eEff;
}

effect EffectIcon (int nIcon) {
    effect eEff = EffectVisualEffect(nIcon);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_ICON);
    return eEff;
}

effect EffectWounding (int nAmount) {
    effect eEff = EffectVisualEffect(nAmount);

    SetEffectTrueType(eEff, EFFECT_TRUETYPE_WOUNDING);
    return eEff;
}

effect EffectAdditionalAttacks(int nAmount) {
	return EffectModifyAttacks(nAmount);
}

effect EffectDCIncrease(int nAmount){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE);
	SetEffectInteger(eEff, 0, nAmount);
    return eEff;
}

effect EffectDCDecrease(int nAmount){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE);
	SetEffectInteger(eEff, 0, nAmount);
    return eEff;
}

effect EffectImmunityDecrease (int nImmunity, int nVuln) {
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE);
	SetEffectInteger(eEff, 0, nImmunity);
	SetEffectInteger(eEff, 1, nVuln);
    return eEff;
}

effect EffectPermenantHitpoints(int nHitpoints){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_HITPOINTS);
	SetEffectInteger(eEff, 0, nHitpoints);
    return eEff;
}

effect EffectMovementRate(int nRate){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_MOVEMENT_RATE);
	SetEffectInteger(eEff, 0, nRate);
    return eEff;
}

effect ExpandedEffectDamageIncrease(int nBonus, int nDamageType, int bCritical, int bUnblockable) {
	int mask = 0;
	if (bCritical) mask |= 2;
	if (bUnblockable) mask |= 4;

	effect dmginc = EffectDamageIncrease(nBonus, nDamageType);
	SetEffectInteger(dmginc, 6, mask);
	return dmginc;
}

effect EffectDamageImmunityAll(int amount) {
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_DAMAGE_IMMUNITY_ALL);
	SetEffectInteger(eEff, 0, amount);
    return eEff;
}

effect EffectDamageVulnerabilityAll(int amount) {
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, CUSTOM_EFFECT_TYPE_DAMAGE_VULNERABILITY_ALL);
	SetEffectInteger(eEff, 0, amount);
    return eEff;
}

/*


effect EffectOathOfWrath(int nAmount){
    if(nAmount < 1)      nAmount = 1;
    else if(nAmount > 5) nAmount = 5;

    effect eEff = EffectVisualEffect(TA_EFFECT_OATH_OF_WRATH);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectOffhandAttackIncrease(int nAttacks){
    effect eEff = EffectVisualEffect(TA_EFFECT_OFFHAND_ATTACKS);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nAttacks);
    return eEff;
}

effect EffectOnhandAttackIncrease(int nAttacks){
    effect eEff = EffectVisualEffect(TA_EFFECT_ONHAND_ATTACKS);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nAttacks);
    return eEff;
}
*/
