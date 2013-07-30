//::///////////////////////////////////////////////
//:: Shadow Evade
//:: X0_S2_ShadEvade    .nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main()
{
    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER);
    int nConceal = 20, nDRAmount, nDRPower = 5, nAC, nDRMax;
    int nDuration = nLevel * 2, nCap;
    if(nLevel <= 0) return;
    if(nLevel > 30) nLevel = 30;

    // No stacking
    RemoveEffectsFromSpell(OBJECT_SELF, 477);

    // +1 AC per 3 SD levels.
    nAC = 4;

    // +1 concealment per hide skill over 20
    int nHide = GetSkillRank(SKILL_HIDE, OBJECT_SELF, TRUE) - 20;
    if(nHide < 0) nHide = 0;
    if(nHide > 40) nHide = 40;
    nConceal += nHide;

    if(nLevel >= 20) nCap = 60;
    else if(nLevel >= 15) nCap = 50;
    else nCap = 40;

    if(nConceal > nCap)
        nConceal = nCap;

    // Grants damage reduction with a power of +5 plus 1 per 6 SD levels, an amount of
    // +1 per SD level, and collapses after 5 * base hide skill points of melee damage.
    nDRAmount = nLevel;
    nDRMax = 5 * GetSkillRank(SKILL_HIDE, OBJECT_SELF, TRUE);

    if(nLevel <= 10) nDRPower = 5;
    else if(nLevel <= 20) nDRPower = 6;
    else if(nLevel <= 25) nDRPower = 8;
    else if(nLevel <= 30) nDRPower = 10;
    nDRPower = IPGetDamagePowerConstantFromNumber(nDRPower);

    //Declare Evade Effects
    effect eConceal = EffectConcealment(nConceal);
    effect eAC = EffectACIncrease(nAC);
    effect eDur= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis2 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

    // DR Effects, not in Link
    effect eDR = EffectDamageReduction(nDRAmount, nDRPower, nDRMax);
    effect eVis3 = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    effect eLink2 = EffectLinkEffects(eDR, eVis3);

    //Link effects
    effect eLink = EffectLinkEffects(eConceal, eDur);
    eLink = EffectLinkEffects(eLink, eVis2);
    if(nAC > 0) eLink = EffectLinkEffects(eLink, eAC);

    eLink = ExtraordinaryEffect(eLink);

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 477, FALSE));

    float fDuration = RoundsToSeconds(nDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, OBJECT_SELF, fDuration);

    Logger(OBJECT_SELF, "DebugSpells", LOGLEVEL_DEBUG, "Shadow Evade : " +
        "SD Level: %s, Concealment: %s, Damage Reduction: %s/+%s to %s, AC: %s, Duration: %s",
        IntToString(nLevel), IntToString(nConceal), IntToString(nDRAmount), IntToString(nDRPower),
        IntToString(nDRMax), IntToString(nAC), FloatToString(fDuration, 4, 0));

}


