// pl_effects_inc

#include "nwnx_structs"
#include "nwnx_effects"

int TA_EFFECT_DC_DECREASE            = 1;
int TA_EFFECT_ONHAND_ATTACKS         = 2;
int TA_EFFECT_OFFHAND_ATTACKS        = 3;
int TA_EFFECT_PERMENANT_HITPOINTS    = 4;
int TA_EFFECT_DC_INCREASE            = 5;
int TA_EFFECT_IMMUNITY_DECREASE      = 6;
int TA_EFFECT_ADDITIONAL_ATTACKS     = 7;
int TA_EFFECT_OATH_OF_WRATH          = 8;
int TA_EFFECT_MOVEMENT_RATE          = 9;

effect EffectAdditionalAttacks(int nAmount);
effect EffectBonusFeat (int nFeat);
effect EffectDCIncrease(int nAmount);
effect EffectDCDecrease(int nAmount);
effect EffectIcon (int nIcon);
effect EffectImmunityDecrease (int nImmunity, int nVuln);
effect EffectMovementRate(int nRate);
effect EffectOathOfWrath(int nAmount);
effect EffectOffhandAttackIncrease(int nAttacks);
effect EffectOnhandAttackIncrease(int nAttacks);
effect EffectPermenantHitpoints(int nHitpoints);
effect EffectWounding (int nAmount);

effect EffectBonusFeat (int nFeat) {
    effect eEff = EffectVisualEffect(nFeat);

    SetEffectTrueType(eEff, EFFECT_TRUETYPE_BONUS_FEAT);
    return eEff;
}

effect EffectDCIncrease(int nAmount){
    effect eEff = EffectVisualEffect(TA_EFFECT_DC_INCREASE);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectDCDecrease(int nAmount){
    effect eEff = EffectVisualEffect(TA_EFFECT_DC_DECREASE);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nAmount);
    return eEff;
}

effect EffectIcon (int nIcon) {
    effect eEff = EffectVisualEffect(nIcon);

    SetEffectTrueType(eEff, EFFECT_TRUETYPE_ICON);
    return eEff;
}

effect EffectImmunityDecrease (int nImmunity, int nVuln) {
    effect eEff = EffectVisualEffect(TA_EFFECT_IMMUNITY_DECREASE);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nImmunity);
    SetEffectInteger(eEff, 2, nVuln);
    return eEff;
}

effect EffectMovementRate(int nRate){
    effect eEff = EffectVisualEffect(TA_EFFECT_MOVEMENT_RATE);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nRate);
    return eEff;
}

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

effect EffectPermenantHitpoints(int nHitpoints){
    effect eEff = EffectVisualEffect(TA_EFFECT_PERMENANT_HITPOINTS);
    SetEffectTrueType(eEff, EFFECT_TRUETYPE_MODIFYNUMATTACKS);
    SetEffectInteger(eEff, 1, nHitpoints);
    return eEff;
}

effect EffectWounding (int nAmount) {
    effect eEff = EffectVisualEffect(nAmount);

    SetEffectTrueType(eEff, EFFECT_TRUETYPE_WOUNDING);
    return eEff;
}

