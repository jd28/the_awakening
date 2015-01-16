// pl_effects_inc

#include "nwnx_structs"
#include "nwnx_effects"

const int CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS = 0;
const int CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE = 1;
const int CUSTOM_EFFECT_TYPE_HITPOINTS = 2;
const int CUSTOM_EFFECT_TYPE_MOVEMENT_RATE = 3;
const int CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE = 4;
const int CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE = 5;
const int CUSTOM_EFFECT_TYPE_RECURRING = 6;

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
	effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_ADDITIONAL_ATTACKS);
	SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectDCIncrease(int nAmount){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_SPELL_DC_DECREASE);
	SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectDCDecrease(int nAmount){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_SPELL_DC_INCREASE);
	SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectImmunityDecrease (int nImmunity, int nVuln) {
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_IMMUNITY_DECREASE);
	SetEffectInteger(eEff, 1, nImmunity);
	SetEffectInteger(eEff, 2, nVuln);
    return eEff;
}

effect EffectPermenantHitpoints(int nHitpoints){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_HITPOINTS);
	SetEffectInteger(eEff, 1, nHitpoints);
    return eEff;
}

effect EffectMovementRate(int nRate){
    effect eEff = EffectVisualEffect(0);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
	SetEffectInteger(eEff, 0, CUSTOM_EFFECT_TYPE_MOVEMENT_RATE);
	SetEffectInteger(eEff, 1, nRate);
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
