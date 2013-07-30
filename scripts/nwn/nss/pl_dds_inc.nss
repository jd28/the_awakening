#include "pl_effects_inc"

const int DAMAGE_BEHAVIOR_NORMAL = 0;
const int DAMAGE_BEHAVIOR_HEAL = 1;

// Defense
void ApplyAbilities(object oSelf, int nStr = 0, int nDex = 0, int nCon = 0, int nWis = 0, int nInt = 0, int nCha = 0);
void ApplyACBonus(object oSelf, int nDeflect = 0, int nDodge = 0, int nNatural = 0);
void ApplyDamageShield(object oSelf, int nDamageAmount, int nRandomAmount, int nDamageType);
void ApplyElementalImmunities(object oSelf, int nAcid = 0, int nCold = 0, int nElec = 0, int nFire = 0, int nSonic = 0);
void ApplyElementalResistance(object oSelf, int nAcid = 0, int nCold = 0, int nElec = 0, int nFire = 0, int nSonic = 0);
void ApplyExoticImmunities(object oSelf, int nDiv = 0, int nMag = 0, int nNeg = 0, int nPos = 0);
void ApplyExoticResistance(object oSelf, int nDiv = 0, int nMag = 0, int nNeg = 0, int nPos = 0);
void ApplyMiscDefense(object oSelf, int nConceal = 0, int nSR = 0, int nRegen = 0, int nFreedom = FALSE);
void ApplyMiscImmunities(object oSelf, int nImm1 = 0, int nImm2 = 0, int nImm3 = 0, int nImm4 = 0);
void ApplyPhysicalImmunities(object oSelf, int nBludge = 0, int nPierce = 0, int nSlash = 0);
void ApplyPhysicalResistance(object oSelf, int nBludge = 0, int nPierce = 0, int nSlash = 0);
void ApplySight(object oSelf, int nTS = 0, int nSeeInvis = 0, int nUltraVision = 0);
void ApplySoak(object oSelf, int nPlus = 0, int nSoak = 0);
void ApplySpellMiscImmunities(object oSelf, int nSchool = 0, int nLevel = 0);
void ApplySpellImmunities(object oSelf, int nImm1 = 0, int nImm2 = 0, int nImm3 = 0, int nImm4 = 0);
void SetABAbility(object oSelf, int nAbility);
void SetABOverride(object oSelf, int nAB);
int GetIsHealDamage(object oTarget, int nDamageType);
void SetHealDamage(object oSelf, int nDamageType);


// Offense
void ApplyElementalDamage(object oSelf, int nAcid = -1, int nCold = -1, int nElec = -1, int nFire = -1, int nSonic = -1);
void ApplyExoticDamage(object oSelf, int nDiv = -1, int nMag = -1, int nNeg = -1, int nPos = -1);
void ApplyPhysicalDamage(object oSelf, int nBludge = -1, int nPierce = -1, int nSlash = -1);
void ApplyUnblockableDamage(object oSelf, int nDamType, int nDamBonus);

void ApplyAbilities(object oSelf, int nStr = 0, int nDex = 0, int nCon = 0, int nWis = 0, int nInt = 0, int nCha = 0){
    effect eEff;

    if(nStr > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, nStr));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nDex > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, nDex));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nCon > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nWis > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_WISDOM, nWis));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nInt > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_INTELLIGENCE, nInt));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nCha > 0){
        eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CHARISMA, nCha));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Abilities : Strength: %s, "+
    //    "Dexerity: %s, Constitution: %s, Wisdom: %s, Intelligence: %s, Charisma: %s", IntToString(nStr),
    //    IntToString(nDex), IntToString(nCon), IntToString(nWis), IntToString(nInt), IntToString(nCha));
}


void ApplyACBonus(object oSelf, int nDeflect = 0, int nDodge = 0, int nNatural = 0){
    effect eEff;

    if (nDeflect) {
        eEff = SupernaturalEffect(EffectACIncrease(nDeflect, AC_DEFLECTION_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if (nDodge) {
        eEff = SupernaturalEffect(EffectACIncrease(nDodge, AC_DODGE_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if (nNatural) {
        eEff = SupernaturalEffect(EffectACIncrease(nNatural, AC_NATURAL_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "AC : Deflection: %s, "+
    //    "Dodge: %s, Natural: %s", IntToString(nDeflect), IntToString(nDodge), IntToString(nNatural));
}

void ApplyDamageShield(object oSelf, int nDamageAmount, int nRandomAmount, int nDamageType){
    effect eEff = SupernaturalEffect(EffectDamageShield(nDamageAmount, nRandomAmount, nDamageType));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
}

void ApplyElementalImmunities(object oSelf, int nAcid = 0, int nCold = 0, int nElec = 0, int nFire = 0, int nSonic = 0){
    effect eEff;

    // Acid
    if(nAcid > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, nAcid));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nAcid < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, -nAcid));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Cold
    if(nCold > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nCold));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nCold < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, -nCold));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Electrical
    if(nElec > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, nElec));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nElec < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, -nElec));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Fire
    if(nFire > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, nFire));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nFire < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, -nFire));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Sonic
    if(nSonic > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, nSonic));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nSonic < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, -nSonic));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Elemental Immunities : Acid: %s, "+
    //    "Cold: %s, Electrical: %s, Fire: %s, Sonic: %s", IntToString(nAcid), IntToString(nCold),
    //    IntToString(nElec), IntToString(nFire), IntToString(nSonic));

}
void ApplyElementalResistance(object oSelf, int nAcid = 0, int nCold = 0, int nElec = 0, int nFire = 0, int nSonic = 0){
    effect eEff;

    // Acid
    if(nAcid > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ACID, nAcid));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Cold
    if(nCold > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_COLD, nCold));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Electrical
    if(nElec > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nElec));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Fire
    if(nFire > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, nFire));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Sonic
    if(nSonic > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SONIC, nSonic));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Elemental Resist : Acid: %s, "+
   //    "Cold: %s, Electrical: %s, Fire: %s, Sonic: %s", IntToString(nAcid), IntToString(nCold),
    //    IntToString(nElec), IntToString(nFire), IntToString(nSonic));
}

void ApplyExoticImmunities(object oSelf, int nDiv = 0, int nMag = 0, int nNeg = 0, int nPos = 0){
    effect eEff;

    // Divine
    if(nDiv > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, nDiv));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nDiv < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, -nDiv));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Magical
    if(nMag > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, nMag));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nMag < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, -nMag));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Negative
    if(nNeg > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, nNeg));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nNeg < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE, -nNeg));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Positive
    if(nPos > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, nPos));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nPos < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, -nPos));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Exotic Immunities : Divine: %s, "+
    //    "Magical: %s, Negative: %s, Positive: %s", IntToString(nDiv), IntToString(nMag),
    //    IntToString(nNeg), IntToString(nPos));
}

void ApplyExoticResistance(object oSelf, int nDiv = 0, int nMag = 0, int nNeg = 0, int nPos = 0){
    effect eEff;

    // Divine
    if(nDiv > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_DIVINE, nDiv));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Magical
    if(nMag > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_MAGICAL, nMag));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Negative
    if(nNeg > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, nNeg));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Positive
    if(nPos > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_POSITIVE, nPos));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Exotic Resist : Divine: %s, "+
    //    "Magical: %s, Negative: %s, Positive: %s", IntToString(nDiv), IntToString(nMag),
    //    IntToString(nNeg), IntToString(nPos));
}

void ApplyMiscDefense(object oSelf, int nConceal = 0, int nSR = 0, int nRegen = 0, int nFreedom = FALSE){
    effect eEff;
    if(nConceal > 0){
        eEff = SupernaturalEffect(EffectConcealment(nConceal));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nSR > 0){
        eEff = SupernaturalEffect(EffectSpellResistanceIncrease(nSR));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nRegen > 0){
        eEff = SupernaturalEffect(EffectRegenerate(nRegen, 6.0f));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nFreedom){
        eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SLOW));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
}

void ApplyMiscImmunities(object oSelf, int nImm1 = 0, int nImm2 = 0, int nImm3 = 0, int nImm4 = 0){
    effect eEff;

    if(nImm1){
        eEff = SupernaturalEffect(EffectImmunity(nImm1));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm2){
        eEff = SupernaturalEffect(EffectImmunity(nImm2));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm3){
        eEff = SupernaturalEffect(EffectImmunity(nImm3));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm4){
        eEff = SupernaturalEffect(EffectImmunity(nImm4));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Misc Immunities : Imm1: %s, "+
    //    "Imm2: %s, Imm3: %s, Imm4: %s", IntToString(nImm1), IntToString(nImm2),
    //    IntToString(nImm3), IntToString(nImm4));
}

void ApplyPhysicalImmunities(object oSelf, int nBludge = 0, int nPierce = 0, int nSlash = 0){
    effect eEff;

    // Bludge
    if(nBludge > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nBludge));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nBludge < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_BLUDGEONING, -nBludge));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Pierce
    if(nPierce > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nPierce));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nPierce < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_PIERCING, -nPierce));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Slash
    if(nSlash > 0){
        eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nSlash));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    else if(nSlash < 0){
        eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_SLASHING, -nSlash));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Physical Immunities : Bludge: %s, "+
    //    "Pierce: %s, Slash: %s", IntToString(nBludge), IntToString(nPierce), IntToString(nSlash));
}

void ApplyPhysicalResistance(object oSelf, int nBludge = 0, int nPierce = 0, int nSlash = 0){
    effect eEff;

    // Bludge
    if(nBludge > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nBludge));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Pierce
    if(nPierce > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_PIERCING, nPierce));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    // Slash
    if(nSlash > 0){
        eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SLASHING, nSlash));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Physical Resist : Bludge: %s, "+
    //    "Pierce: %s, Slash: %s", IntToString(nBludge), IntToString(nPierce), IntToString(nSlash));
}

void ApplySight(object oSelf, int nTS = 0, int nSeeInvis = 0, int nUltraVision = 0){
    effect eEff;
    if(nTS){
        eEff = SupernaturalEffect(EffectTrueSeeing());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        return; // All others are uncessary.
    }
    if(nSeeInvis){
        eEff = SupernaturalEffect(EffectSeeInvisible());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nUltraVision){
        eEff = SupernaturalEffect(EffectUltravision());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
}

void ApplySoak(object oSelf, int nPlus = 0, int nSoak = 0){
    effect eEff;

    nPlus = GetDamagePowerFromNumber(nPlus);
    eEff = SupernaturalEffect(EffectDamageReduction(nSoak, nPlus));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
}


void ApplySpellMiscImmunities(object oSelf, int nSchool = 0, int nLevel = 0){
    effect eEff;

    if(nSchool){
        eEff = SupernaturalEffect(EffectSpellLevelAbsorption(9, 0, nSchool));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    if(nLevel){
        eEff = SupernaturalEffect(EffectSpellLevelAbsorption(nLevel, 0));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
}

void ApplySpellImmunities(object oSelf, int nImm1 = 0, int nImm2 = 0, int nImm3 = 0, int nImm4 = 0){
    effect eEff;

    if(nImm1){
        eEff = SupernaturalEffect(EffectSpellImmunity(nImm1));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm2){
        eEff = SupernaturalEffect(EffectSpellImmunity(nImm2));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm3){
        eEff = SupernaturalEffect(EffectSpellImmunity(nImm3));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    if(nImm4){
        eEff = SupernaturalEffect(EffectSpellImmunity(nImm4));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    //Logger(oSelf, "DebugDynamicDefense", LOGLEVEL_DEBUG, "Spell Immunities : Imm1: %s, "+
    //    "Imm2: %s, Imm3: %s, Imm4: %s", IntToString(nImm1), IntToString(nImm2),
    //    IntToString(nImm3), IntToString(nImm4));
}

void SetABAbility(object oSelf, int nAbility){
    // Deity Format:
    // CCBAAA
    // AAA = Attack Bonus
    // B = Attack Ability + 1
    // CC = Absolute Immunity
    int nValue = StringToInt(GetDeity(oSelf));
    nValue += (nAbility+1)*1000;
    SetDeity(oSelf, IntToString(nValue));
}

void SetABOverride(object oSelf, int nAB){
    // Deity Format:
    // CCBAAA
    // AAA = Attack Bonus
    // B = Attack Ability + 1
    // CC = Absolute Immunity
    if(nAB <= 125){
        int nValue = StringToInt(GetDeity(oSelf));
        nValue += nAB;
        SetDeity(oSelf, IntToString(nValue));
    }
}

int GetIsHealDamage(object oTarget, int nDamageType){
    int nHealDamage, bHeal;

    nHealDamage = GetLocalInt(oTarget, "HealDamage") - 1;

    if(nHealDamage == 0) return FALSE;

    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD &&
       nDamageType == DAMAGE_TYPE_NEGATIVE){
        bHeal = TRUE;
    }
    else if(nHealDamage == nDamageType){
        bHeal = TRUE;
    }
    else if(nHealDamage == DAMAGE_TYPE_ELEMENTALS &&
            (nDamageType == DAMAGE_TYPE_ACID ||
             nDamageType == DAMAGE_TYPE_COLD ||
             nDamageType == DAMAGE_TYPE_ELECTRICAL ||
             nDamageType == DAMAGE_TYPE_FIRE ||
             nDamageType == DAMAGE_TYPE_SONIC))
    {
        bHeal = TRUE;
    }
    else if(nHealDamage == DAMAGE_TYPE_EXOTICS &&
            (nDamageType == DAMAGE_TYPE_DIVINE ||
             nDamageType == DAMAGE_TYPE_MAGICAL ||
             nDamageType == DAMAGE_TYPE_NEGATIVE ||
             nDamageType == DAMAGE_TYPE_POSITIVE))
    {
        bHeal = TRUE;
    }
    else if(nHealDamage == DAMAGE_TYPE_PHYSICALS &&
            (nDamageType == DAMAGE_TYPE_BASE_WEAPON ||
             nDamageType == DAMAGE_TYPE_BLUDGEONING ||
             nDamageType == DAMAGE_TYPE_PIERCING ||
             nDamageType == DAMAGE_TYPE_SLASHING))
    {
        bHeal = TRUE;
    }

    return bHeal;
}

void SetHealDamage(object oSelf, int nDamageType){
    SetLocalInt(oSelf, "HealDamage", nDamageType+1);
}


int GetOverHealType(int nString);
int GetOverHealType(int nString){
    return 0;
}


void SetACTouchBase(object oCreature, int nAC);
void SetACTouchBase(object oCreature, int nAC){
}

void ApplyDynamics(object oCreature);

void ApplyDynamics(object oCreature){

    int nLevel = GetLocalInt(GetArea(oCreature), "area_level");
    int nDynamic = GetLocalInt(oCreature, "PL_AI_DYNAMIC"), i;

    if(nLevel > 0 && nDynamic > 0){
        int nAC = GetLocalInt(GetArea(oCreature), "area_highest_ac");
        int nAB = GetLocalInt(GetArea(oCreature), "area_highest_ab");

        int nACMod = GetLocalInt(oCreature, "PL_AI_ACMOD");
        int nABMod = GetLocalInt(oCreature, "PL_AI_ABMOD");
        int nMyAB = GetBaseAttackBonus(oCreature) + nABMod;
        int nMyAC = GetAC(oCreature);// + nACMod;
        nMyAB += GetHasFeat(FEAT_WEAPON_FINESSE) ? GetAbilityModifier(ABILITY_DEXTERITY) : GetAbilityModifier(ABILITY_STRENGTH);

        switch(nDynamic){
            case 1:
                if(nMyAC < nAB + 15){
                    SetACNaturalBase(oCreature, GetACNaturalBase(oCreature) + (nAB + 15 - nMyAC));
                    //SetLocalInt(oCreature, "PL_AI_ACMOD", nACMod + (nAB + 15 - nMyAC));
                }
                if(nMyAB < nAC - 15){
                    ModifySkillRank (oCreature, SKILL_RIDE, (nAC - 15) - nMyAB);
                    SetLocalInt(oCreature, "PL_AI_ABMOD", nABMod + (nAC - 15) - nMyAB);
                }
            break;
            case 2:
                if(nMyAC < nAB + 10){
                    SetACNaturalBase(oCreature, GetACNaturalBase(oCreature) + (nAB + 10 - nMyAC));
                    //SetLocalInt(oCreature, "PL_AI_ACMOD", nACMod + (nAB + 10 - nMyAC));
                }
                if(nMyAB < nAC - 10){
                    ModifySkillRank (oCreature, SKILL_RIDE, (nAC - 10) - nMyAB);
                    SetLocalInt(oCreature, "PL_AI_ABMOD", nABMod + (nAC - 10) - nMyAB);
                }
            break;
            case 3:
                if(nMyAC < nAB + 5){
                    SetACNaturalBase(oCreature, GetACNaturalBase(oCreature) + (nAB + 5 - nMyAC));
                    //SetLocalInt(oCreature, "PL_AI_ACMOD", nACMod + (nAB + 5 - nMyAC));
                }
                if(nMyAB < nAC - 5){
                    ModifySkillRank (oCreature, SKILL_RIDE, (nAC - 5) - nMyAB);
                    SetLocalInt(oCreature, "PL_AI_ABMOD", nABMod + (nAC - 5) - nMyAB);
                }
            break;
            case 4:
                if(nMyAC < nAB + 2){
                    SetACNaturalBase(oCreature, GetACNaturalBase(oCreature) + (nAB + 2 - nMyAC));
                    //SetLocalInt(oCreature, "PL_AI_ACMOD", nACMod + (nAB + 2 - nMyAC));
                }
                if(nMyAB < nAC){
                    ModifySkillRank (oCreature, SKILL_RIDE, nAC - nMyAB);
                    SetLocalInt(oCreature, "PL_AI_ABMOD", nABMod + nAC - nMyAB);
                }
            break;
        }
    }

    /* Spells */
    for (i = 1; i <= 3; i++) {
        int nSpell = GetLocalInt(oCreature, "Spell" + IntToString(i))-1;
        if (nSpell && !GetHasSpellEffect(nSpell, oCreature)) {
            ActionCastSpellAtObject(nSpell, oCreature, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        } else
            break;
    }
}

void ApplyDamage(object oCreature){
    // Acid Cold Elec Fire Sonic Magic Positive Negative Divine


}

void ApplyImmunities(object oSelf, int nImm, int bVuln = FALSE, int nScalar = 10);
void ApplyImmunities(object oSelf, int nImm, int bVuln = FALSE, int nScalar = 10){
    /* Acid Cold Elec Fire Sonic Magic Positive Negative Divine */
    int i, nDigit0, nDigit1, nDigit2, nDigit3, nDigit4, nDigit5, nDigit6, nDigit7, nDigit8, nDigit9;
    effect eEff;

    if (nImm) {
        nDigit0 = (nImm % 10);
        nDigit1 = (nImm /= 10) % 10;
        nDigit2 = (nImm /= 10) % 10;
        nDigit3 = (nImm /= 10) % 10;
        nDigit4 = (nImm /= 10) % 10;
        nDigit5 = (nImm /= 10) % 10;
        nDigit6 = (nImm /= 10) % 10;
        nDigit7 = (nImm /= 10) % 10;
        nDigit8 = (nImm /= 10) % 10;
        if (nDigit8 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, (nDigit8 * nScalar) + nScalar) );
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, (nDigit8 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit7 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, (nDigit7 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, (nDigit7 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit6 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, (nDigit6 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, (nDigit6 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit5 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, (nDigit5 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, (nDigit5 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit4 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, (nDigit4 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, (nDigit4 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit3 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, (nDigit3 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, (nDigit3 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit2 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, (nDigit2 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, (nDigit2 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit1 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, (nDigit1 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_NEGATIVE, (nDigit1 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit0 > 0) {
            if(!bVuln) eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, (nDigit0 * nScalar) + nScalar));
            else eEff = SupernaturalEffect(EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, (nDigit0 * nScalar) + nScalar));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
    }
}

void ApplyLocals ();
void ApplyLocals () {
    object oSelf = OBJECT_SELF;
    int nPlot = GetLocalInt(oSelf, "Plot");
    if (nPlot)
        SetPlotFlag(oSelf, TRUE);
    int nAILevel = GetLocalInt(oSelf, "AILevel");
    if (nAILevel)
        SetAILevel(oSelf, nAILevel);

    int nRandDrop = GetLocalInt(oSelf, "RandDrop");
    if (nRandDrop) {
        object oNPC = oSelf;
        object oItem = GetFirstItemInInventory(oNPC);
        while (GetIsObjectValid(oItem)) {
            if (GetDroppableFlag(oItem) == FALSE) {
                int nDroppable = d100() > 50;
                SetDroppableFlag(oItem, nDroppable);
            }
            oItem = GetNextItemInInventory(oNPC);
        }
    }

    int i, nDigit0, nDigit1, nDigit2, nDigit3, nDigit4, nDigit5, nDigit6, nDigit7, nDigit8, nDigit9;
    effect eEff;
    /* Cutscene Ghost */
    int nGhost = GetLocalInt(oSelf, "Ghost");
    if (nGhost) {
        eEff = SupernaturalEffect(EffectCutsceneGhost());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Ability AB override
    int nAbilityAB = GetLocalInt(oSelf, "AbilityAB");
    if (nAbilityAB)
        SetAbilityAB(oSelf, nAbilityAB);
    */

    /* Add AB */
    int nAddAB = GetLocalInt(oSelf, "AddAB");
    if (nAddAB) {
        eEff = SupernaturalEffect(EffectAttackIncrease(nAddAB));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Extra Attacks */
    int nAddAttacks = GetLocalInt(oSelf, "AddAttacks");
    if (nAddAttacks) {
        eEff = SupernaturalEffect(EffectAdditionalAttacks(nAddAttacks));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Conceal */
    int nConceal = GetLocalInt(oSelf, "Conceal");
    if (nConceal) {
        eEff = SupernaturalEffect(EffectConcealment(nConceal));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Physical Resistances - increase by 5 times input amount - from 5/- to 45/- */
    /* Bludgeon Pierce Slash */
    int nRes = GetLocalInt(oSelf, "Resist");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        if (nDigit2 > 0) {
            eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nDigit2 * 5));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit1 > 0) {
            eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_PIERCING, nDigit1 * 5));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit0 > 0) {
            eEff = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_SLASHING, nDigit0 * 5));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
    }

    /* Ability Boosting- str dex con int wis cha - increase by twice the input number - from 2-12 */
    int nAbility = GetLocalInt(oSelf, "Ability");
    if (nAbility) {
        nDigit0 = (nAbility % 10);
        nDigit1 = (nAbility /= 10) % 10;
        nDigit2 = (nAbility /= 10) % 10;
        nDigit3 = (nAbility /= 10) % 10;
        nDigit4 = (nAbility /= 10) % 10;
        nDigit5 = (nAbility /= 10) % 10;
        if (nDigit0) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CHARISMA, nDigit0 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit1) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_WISDOM, nDigit1 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit2) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_INTELLIGENCE, nDigit2 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit3) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, nDigit3 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit4) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, nDigit4 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit5) {
            eEff = SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, nDigit5 * 2));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
    }

    /* SR */
    int nSR = GetLocalInt(oSelf, "SR");
    if (nSR) {
        eEff = SupernaturalEffect(EffectSpellResistanceIncrease(nSR));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Regen */
    int nRegen = GetLocalInt(oSelf, "Regen");
    if (nRegen) {
        eEff = SupernaturalEffect(EffectRegenerate(nRegen, 6.0));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Soak - specified as Soak+Plus (defaults to 20+1; specify 0+0 for no soak) */
    string sSoak = GetLocalString(oSelf, "Soak");
    if (sSoak != "") {
        struct SubString ss, spss;
        ss.rest = sSoak;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest, " ");
            if (ss.first != "0+0" && ss.first != "0") {
                spss = GetFirstSubString(ss.first, "+");
                int nSoak = StringToInt(spss.first);
                int nPlus = GetDamagePowerFromNumber(StringToInt(spss.rest));
                eEff = SupernaturalEffect(EffectDamageReduction(nSoak, nPlus));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
    }
    /* Soak - specified as Soak+Plus (defaults to 20+1; specify 0+0 for no soak) */
    sSoak = GetLocalString(oSelf, "Soak2");
    if (sSoak != "") {
        struct SubString ss, spss;
        ss.rest = sSoak;
        while (ss.rest != "") {
            ss = GetFirstSubString(ss.rest, " ");
            if (ss.first != "0+0" && ss.first != "0") {
                spss = GetFirstSubString(ss.first, "+");
                int nSoak = StringToInt(spss.first);
                int nPlus = GetDamagePowerFromNumber(StringToInt(spss.rest));
                eEff = SupernaturalEffect(EffectDamageReduction(nSoak, nPlus));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
    }
    // else {
//        eEff = SupernaturalEffect(EffectDamageReduction(20, DAMAGE_POWER_PLUS_ONE));
//        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
//    }

    int nImm = GetLocalInt(oSelf, "EnergyImmunities");
    if (nImm)
        ApplyImmunities(oSelf, nImm);
    nImm = GetLocalInt(oSelf, "EnergyImmunities5");
    if (nImm)
        ApplyImmunities(oSelf, nImm, FALSE, 5);
    nImm = GetLocalInt(oSelf, "EnergyVulnerabilities");
    if (nImm)
        ApplyImmunities(oSelf, nImm, TRUE);
    nImm = GetLocalInt(oSelf, "EnergyVulnerabilities5");
    if (nImm)
        ApplyImmunities(oSelf, nImm, TRUE, 5);
    nImm = GetLocalInt(oSelf, "Knockdown");
    if (nImm){
        eEff = SupernaturalEffect(EffectImmunityDecrease(IMMUNITY_TYPE_KNOCKDOWN, nImm));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        
    }

    /* Energy Resistances - 5/- to 45/- */
    /* Acid Cold Elec Fire Sonic Magic Positive Negative Divine */
    nRes = GetLocalInt(oSelf, "EnergyResistance");
    if (nRes) {
        nDigit0 = (nRes % 10);
        nDigit1 = (nRes /= 10) % 10;
        nDigit2 = (nRes /= 10) % 10;
        nDigit3 = (nRes /= 10) % 10;
        nDigit4 = (nRes /= 10) % 10;
        nDigit5 = (nRes /= 10) % 10;
        nDigit6 = (nRes /= 10) % 10;
        nDigit7 = (nRes /= 10) % 10;
        nDigit8 = (nRes /= 10) % 10;

        ApplyElementalResistance(oSelf, nDigit8 * 5, nDigit7 * 5, nDigit6 * 5, nDigit5 * 5, nDigit4 * 5);
        ApplyExoticResistance(oSelf, nDigit0 * 5, nDigit3 * 5, nDigit1 * 5,  nDigit2 * 5);
    }

    /* OtherImmunes: HLKDMCTSBP
     *
     *   H: 1 = Haste
     *
     *   L: 1 = Level/Abil Drain     4 = Level/Abil Decrease    7 = Abil/Skill Decrease
     *      2 = Level Drain          5 = Skill Decrease         8 = Level/Abil/Skill Decrease
     *      3 = Abil Decrease        6 = Level/Skill Decrease
     *
     *   K: 1 = Knockdown            4 = AB Decrease            7 = KD/AC/AB Decrease
     *      2 = AC Decrease          5 = KD/AB Decrease
     *      3 = KD/AC Decrease       6 = AC/AB Decrease
     *
     *   D: 1 = Death                4 = DI Decrease            7 = Death/Save/DI Decrease
     *      2 = Save Decrease        5 = Death/DI Decrease
     *      3 = Death/Save Decrease  6 = Save/DI Decrease
     *
     *   M: 1 = Mind                 4 = Fear                   7 = Mind/Paralysis/Fear
     *      2 = Paralysis            5 = Mind/Fear              8 = Dominate/Charm/Confuse
     *      3 = Mind/Paralysis       6 = Paralysis/Fear         9 = Dominate/Charm/Confuse/Fear
     *
     *   C: 1 = Critical Hits        4 = Poison/Disease         7 = Crit/Sneak/Poison/Disease
     *      2 = Sneak Attacks        5 = Crit/Poison/Disease    8 = Crit/Poison/Disease/Stun/Daze/Sleep
     *      3 = Crit/Sneak           6 = Sneak/Poison/Disease   9 = Crit/Sneak/Poison/Disease/Stun/Daze/Sleep
     *
     *   T: 1 = True Seeing          4 = TS/Blindness/Deafness  7 = SI/Deafness
     *      2 = TS/Blindness         5 = See Invisible          8 = SI/Blindness/Deafness
     *      3 = TS/Deafness          6 = SI/Blindness           9 = Darkvision
     *
     *   B: 10 + (digit * 10)% slashing
     *   P: 10 + (digit * 10)% bludgeoning
     *   S: 10 + (digit * 10)% piercing
     */
    nImm = GetLocalInt(oSelf, "OtherImmunes");
    if (nImm) {
        nDigit0 = (nImm % 10);
        nDigit1 = (nImm /= 10) % 10;
        nDigit2 = (nImm /= 10) % 10;
        nDigit3 = (nImm /= 10) % 10;
        nDigit4 = (nImm /= 10) % 10;
        nDigit5 = (nImm /= 10) % 10;
        nDigit6 = (nImm /= 10) % 10;
        nDigit7 = (nImm /= 10) % 10;
        nDigit8 = (nImm /= 10) % 10;
        nDigit9 = (nImm /= 10) % 10;

        if (nDigit9) {
            eEff = SupernaturalEffect(EffectHaste());
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }

        if (nDigit8) {
            if (nDigit8 > 1) {
                nDigit8--;
                if (nDigit8 & 4) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SKILL_DECREASE));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit8 & 2) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit8 & 1) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            } else {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }

        if (nDigit7) {
            if (nDigit7 & 2) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ATTACK_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit7 & 2) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_AC_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit7 & 1) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }

        if (nDigit6) {
            if (nDigit6 & 4) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit6 & 2) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit6 & 1) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }

        if (nDigit5) {
            if (nDigit5 > 7) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DOMINATE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CONFUSED));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CHARM));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                if (nDigit5 > 8)  {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_FEAR));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            } else {
                if (nDigit5 & 4) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_FEAR));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit5 & 2) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit5 & 1) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            }
        }

        if (nDigit4) {
            if (nDigit4 > 7) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DAZED));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SLEEP));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_STUN));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                if (nDigit4 & 1) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            } else {
                if (nDigit4 & 4) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_POISON));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DISEASE));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit4 & 2) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit4 & 1) {
                    eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            }
        }

        if (nDigit3) {
            if (nDigit3 & 4) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit3 & 2) {
                eEff = SupernaturalEffect(EffectSeeInvisible());
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectUltravision());
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit3 & 1) {
                eEff = SupernaturalEffect(EffectTrueSeeing());
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }

        if (nDigit2) {
            eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, (nDigit2 * 10) + 10));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit1) {
            eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, (nDigit1 * 10) + 10));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
        if (nDigit0) {
            eEff = SupernaturalEffect(EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, (nDigit0 * 10) + 10));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
    }

    /* SpellImmunes: FH7DWA3IBX
     *
     *   F: 1 = Freedom              2 = Paralysis
     *
     *   H: 1 = Harm                 4 = Mass Inflict           7 = Harm/Inflict/Mass Inflict
     *      2 = Inflict              5 = Harm/Mass Inflict
     *      3 = Harm/Inflict         6 = Inflict/Mass Inflict
     *     (if undead, replace 'Harm' with 'Heal' and 'Inflict' with 'Cure')
     *
     *   7: UNUSED
     *
     *   (unimplemented)
     *   D: 1 = Mord                 4 = Dispels                7 = Mord/Breach/Dispel
     *      2 = Breaches             5 = Mord/Dispel
     *      3 = Mord/Breaches        6 = Breach/DIspel
     *
     *   W: 1 = Word of Faith
     *      2 = Earthquake
     *      3 = WoF/Earthquake
     *
     *   (unimplemented)
     *   A: 1 = Creeping Doom        4 = Blade Barrier          7 = Creeping/Evards/Blade
     *      2 = Evards               5 = Creeping/Blade         8 = Trap Spells (e.g. DBF)
     *      3 = Creeping/Evards      6 = Evards/Blade           9 = Creeping/Evards/Blade/Trap
     *
     *   3: UNUSED
     *
     *   I: 1 = Implosion            4 = Disintegrate           7 = Implosion/Drown/Disintegrate
     *      2 = Drown                5 = Implosion/Disintegrate
     *      3 = Implosion/Drown      6 = Drown/Disintegrate
     *
     *   B: 1 = Bigby 7/9 Grasps     4 = Bigby Interpose        7 = Grasp/Forceful/Interpose
     *      2 = Bigby Forceful       5 = Grasp/Interpose        8 = 7 Grasp/Forceful
     *      3 = Grasp/Forceful       6 = Forceful/Interpose     9 = 7 Grasp/Forceful/Interpose
     *
     *   X: Spells X and Lower
     */
    nImm = GetLocalInt(oSelf, "SpellImmunes");
    if (nImm) {
        nDigit0 = (nImm % 10);
        nDigit1 = (nImm /= 10) % 10;
        nDigit2 = (nImm /= 10) % 10;
        nDigit3 = (nImm /= 10) % 10;
        nDigit4 = (nImm /= 10) % 10;
        nDigit5 = (nImm /= 10) % 10;
        nDigit6 = (nImm /= 10) % 10;
        nDigit7 = (nImm /= 10) % 10;
        nDigit8 = (nImm /= 10) % 10;
        nDigit9 = (nImm /= 10) % 10;
        if (nDigit9) {
            eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            if (nDigit9 == 1) {
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_SLOW));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
        if (nDigit8) {
            if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD) {
                if (nDigit8 & 1) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HEAL));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_MASS_HEAL));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit8 & 2) {
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
                }
                if (nDigit8 & 4) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HEALING_CIRCLE));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    /*
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_CURE_LIGHT_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_CURE_MODERATE_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_CURE_SERIOUS_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_CURE_CRITICAL_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    */
                }
            } else {
                if (nDigit8 & 1) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_HARM));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    //eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_HARM));
                    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit8 & 2) {
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
                /*
                if (nDigit8 & 4) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_INFLICT_LIGHT_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_INFLICT_MODERATE_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_INFLICT_SERIOUS_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_MASS_INFLICT_CRITICAL_WOUNDS));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                */
            }
        }
        if (nDigit6) {
            if (nDigit6 & 1) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_MORDENKAINENS_DISJUNCTION));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit6 & 2) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_LESSER_SPELL_BREACH));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_GREATER_SPELL_BREACH));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                //eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_GREATER_SPELL_BREACH));
                //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit6 & 4) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_LESSER_DISPEL));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_DISPEL_MAGIC));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_GREATER_DISPELLING));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
        if (nDigit5) {
            if (nDigit5 & 1) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_WORD_OF_FAITH));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit5 & 2) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_EARTHQUAKE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
        }
        if (nDigit2) {
            if (nDigit2 & 1) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_IMPLOSION));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            if (nDigit2 & 2) {
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_DROWN));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            /*
            if (nDigit2 & 4) {
                eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_DISINTEGRATE));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            }
            */
        }
        if (nDigit1) {
            if (nDigit1 > 7) {
                if (nDigit1 > 8)  {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_INTERPOSING_HAND));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_GRASPING_HAND));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
            } else {
                if (nDigit1 & 1) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_CRUSHING_HAND));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_GRASPING_HAND));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit1 & 2) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
                if (nDigit1 & 4) {
                    eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_BIGBYS_INTERPOSING_HAND));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
                }
            }
        }
        if (nDigit0) {
            eEff = SupernaturalEffect(EffectSpellLevelAbsorption(nDigit0, 0));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        }
    }

    /* Deflection AC */
    int nAC = GetLocalInt(oSelf, "DeflectionAC");
    if (nAC) {
        eEff = SupernaturalEffect(EffectACIncrease(nAC, AC_DEFLECTION_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    /* Dodge AC */
    nAC = GetLocalInt(oSelf, "DodgeAC");
    if (nAC) {
        eEff = SupernaturalEffect(EffectACIncrease(nAC, AC_DODGE_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }
    /* Natural AC */
    nAC = GetLocalInt(oSelf, "NaturalAC");
    if (nAC) {
        eEff = SupernaturalEffect(EffectACIncrease(nAC, AC_NATURAL_BONUS));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
    }

    /* Petrification immunity */
    if (GetLocalInt(oSelf, "NoPet") & 1) {
        eEff = SupernaturalEffect(EffectSpellImmunity(SPELL_FLESH_TO_STONE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        /*
        eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_CAST_IN_STONE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        eEff = SupernaturalEffect(EffectSpellImmunity(HGSPELL_CALL_OF_STONE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        */
    }

    /* VFX */
    for (i = 1; i <= 3; i++) {
        int nVFX = GetLocalInt(oSelf, "VFXDur" + IntToString(i)) - 1;
        if (nVFX) {
            eEff = SupernaturalEffect(EffectVisualEffect(nVFX));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
        } else
            break;
    }

    /* execute script on spawn - use for extensive custom behavior like boss spawnins etc */
    string sScript = GetLocalString(oSelf, "ES_Spawn");
    if (sScript != "")
        ExecuteScript(sScript, oSelf);
    /* apply dynamics effects, item properties, and autocasting */
    DelayCommand(2.0, ApplyDynamics(oSelf));
}

// Offense
void ApplyElementalDamage(object oSelf, int nAcid = -1, int nCold = -1, int nElec = -1, int nFire = -1, int nSonic = -1);
void ApplyExoticDamage(object oSelf, int nDiv = -1, int nMag = -1, int nNeg = -1, int nPos = -1);
void ApplyPhysicalDamage(object oSelf, int nBludge = -1, int nPierce = -1, int nSlash = -1);

// nDamType cannot be physical /and/ be unblockable.
void ApplyUnblockableDamage(object oSelf, int nDamType, int nDamBonus);

void ApplyElementalDamage(object oSelf, int nAcid = -1, int nCold = -1, int nElec = -1, int nFire = -1, int nSonic = -1){
    int nDIPType = GetLocalInt(oSelf, "DIPType");
    object oItem = OBJECT_INVALID, oItem1 = OBJECT_INVALID, oItem2 = OBJECT_INVALID;

    switch(nDIPType){
        case 1: //Single
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        break;
        case 2: //Dual
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        break;
        case 3: // Guants
            oItem = GetItemInSlot(INVENTORY_SLOT_ARMS);
        break;
        default: // Creature attacks
            oItem  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L);
            oItem2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);
    }

        if (nAcid > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nAcid));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nAcid));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, nAcid));
        }
        if (nCold > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, nCold));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, nCold));
            if(oItem2!= OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, nCold));
        }
        if (nElec > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, nElec));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, nElec));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, nElec));

        }
        if (nFire > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nFire));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nFire));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nFire));
        }
        if (nSonic > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, nSonic));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, nSonic));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, nSonic));
        }
}
void ApplyExoticDamage(object oSelf, int nDiv = -1, int nMag = -1, int nNeg = -1, int nPos = -1){
    int nDIPType = GetLocalInt(oSelf, "DIPType");
    object oItem = OBJECT_INVALID, oItem1 = OBJECT_INVALID, oItem2 = OBJECT_INVALID;

    switch(nDIPType){
        case 1: //Single
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        break;
        case 2: //Dual
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        break;
        case 3: // Guants
            oItem = GetItemInSlot(INVENTORY_SLOT_ARMS);
        break;
        default: // Creature attacks
            oItem  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L);
            oItem2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);
    }

        if (nMag > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nMag));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nMag));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, nMag));
        }
        if (nPos > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nPos));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nPos));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE, nPos));
        }
        if (nNeg > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nNeg));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nNeg));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, nNeg));
        }
        if (nDiv > 0) {
            if(oItem != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDiv));
            if(oItem1 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem1, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDiv));
            if(oItem2 != OBJECT_INVALID)
                IPSafeAddItemProperty(oItem2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, nDiv));
        }
}
void ApplyPhysicalDamage(object oSelf, int nBludge = -1, int nPierce = -1, int nSlash = -1){
    int nDIPType = GetLocalInt(oSelf, "DIPType");
    object oItem = OBJECT_INVALID, oItem1 = OBJECT_INVALID, oItem2 = OBJECT_INVALID;

    switch(nDIPType){
        case 1: //Single
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        break;
        case 2: //Dual
            oItem  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        break;
        case 3: // Guants
            oItem = GetItemInSlot(INVENTORY_SLOT_ARMS);
        break;
        default: // Creature attacks
            oItem  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R);
            oItem1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L);
            oItem2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);
    }


}


void ApplyUnblockableDamage(object oSelf, int nDamType, int nDamBonus){
    // Note does not work on Physicals
    effect eEff = SupernaturalEffect(EffectDamageIncrease(nDamBonus, nDamType));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oSelf);
}
