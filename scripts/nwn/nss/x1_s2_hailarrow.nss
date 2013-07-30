//::///////////////////////////////////////////////
//:: x1_s2_hailarrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    One arrow per arcane archer level at all targets

    GZ SEPTEMBER 2003
        Added damage penetration

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "gsp_func_inc"

// GZ: 2003-07-23 fixed criticals not being honored
void DoAttack(struct SpellInfo si, object oTarget)
{
    int nBonus = ArcaneArcherCalculateBonus();
    int nDamage, nMagic;
    // * Roll Touch Attack
    int nTouch = TouchAttackRanged(oTarget, TRUE);

    if (nTouch == 0)
        return;

    if( nTouch == 2)
        si.meta = METAMAGIC_EMPOWER;

    nDamage = MetaPower(si, si.clevel, 8, 0, 0);
    nMagic = MetaPower(si, nBonus, 8, 0, 0);

    effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, IPGetDamagePowerConstantFromNumber(nBonus));
    effect eMagic = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget);
}

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    si.clevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, si.caster);
    object oTarget;
    int i = 0;
    float fDist, fDelay;
    effect eArrow = EffectVisualEffect(357);

    for (i = 1; i <= si.clevel; i++){
        si.target = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, i, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        if (si.target == OBJECT_INVALID)
            break;

        fDist = GetDistanceBetween(si.caster, si.target);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);

        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, si.target);
        DelayCommand(fDelay, DoAttack(si, si.target));
    }
}
