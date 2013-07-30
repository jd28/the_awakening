//::///////////////////////////////////////////////
//:: Epic Ward
//:: x2_s2_epicward.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the caster invulnerable to damage
    (equals damage reduction 50/+20)
    Lasts 1 round per level

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 12, 2003
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    if(si.item != OBJECT_INVALID && GetTag(si.item) == "pl_drow_queen_ar"){
        if(GetLevelByClass(CLASS_TYPE_CLERIC, si.caster) < 35 || GetAbilityScore(si.caster, ABILITY_WISDOM, TRUE) < 30){
            ErrorMessage(si.caster, "You are not allowed to use this!!");
            return;
        }

        if(GetAbilityScore(si.caster, ABILITY_WISDOM, TRUE) > GetAbilityScore(si.caster, ABILITY_STRENGTH, TRUE))
            si.clevel = GetLevelByClass(CLASS_TYPE_CLERIC, si.caster);

        SetLocalInt(si.item, "RemoveSpellEffect", si.id + 1);
    }

    //Declare major variables
    //ect oTarget = GetSpellTargetObject();
    //int nDuration = GetCasterLevel(OBJECT_SELF);
    //Fire cast spell at event for the specified target
    SignalEvent(si.caster, EventSpellCastAt(si.caster, si.id, FALSE));
    int nLimit = 50*si.clevel;
    effect eDur = EffectVisualEffect(495);
    effect eProt = EffectDamageReduction(30, DAMAGE_POWER_PLUS_TWENTY, nLimit);
    effect eLink = EffectLinkEffects(eDur, eProt);
    eLink = EffectLinkEffects(eLink, eDur);

    // * Brent, Nov 24, making extraodinary so cannot be dispelled
    eLink = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(si.caster, si.id);
    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.caster, RoundsToSeconds(si.clevel));

}
