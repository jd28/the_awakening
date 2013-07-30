//::///////////////////////////////////////////////
//:: x1_s2_seeker
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    si.clevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
    int nMagic, nDamage;
    int nBonus = ArcaneArcherCalculateBonus() ;

    if(si.target == OBJECT_INVALID
            || !GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE))
        return;

    nDamage = MetaPower(si, si.clevel, 12, 0, 0);
    nMagic = MetaPower(si, nBonus, 12, 0, 0);

    effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
    effect eMagic = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL);

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, 601));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, si.target);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, si.target);
}
