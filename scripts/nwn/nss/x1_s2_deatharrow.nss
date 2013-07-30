//::///////////////////////////////////////////////
//:: x1_s2_deatharrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

#include "gsp_func_inc"
#include "x2_inc_itemprop"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    if(si.target == OBJECT_INVALID || !GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE) || GetLocalInt(si.target, "Boss"))
        return;

    int nWisMod = GetAbilityModifier(ABILITY_WISDOM, si.caster);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, si.caster);
    int nTouch  = TouchAttackRanged(si.target, TRUE);
    if (nTouch == 0)
        return;

    si.clevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, si.caster);
    si.dc = 10 + max(nWisMod, nDexMod) + (si.clevel / 5);
    int nDamage = GetCurrentHitPoints(si.target) - d4();

    if(nTouch < 2){
        nDamage /= 2;
        
        if(GetSpellSaved(si, SAVING_THROW_FORT, si.target)) 
            nDamage /= 2;
    }

    if(nDamage <= 0)
        return;

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    effect ePhysical = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, si.target);
    ApplyVisualToObject(246, si.target);
}

