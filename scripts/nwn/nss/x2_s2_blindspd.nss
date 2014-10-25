//::///////////////////////////////////////////////
//:: Haste
//:: x2_s2_blindspd.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the targeted creature one extra partial
    action per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 29, 2001
//:://////////////////////////////////////////////
// Modified March 2003: Remove Expeditious Retreat effects


#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    // Remove Stacking Effects
    if (GetHasSpellEffect(SPELL_EXPEDITIOUS_RETREAT, si.caster))
        RemoveSpellEffects(SPELL_EXPEDITIOUS_RETREAT, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(SPELL_HASTE, si.caster))
        RemoveSpellEffects(SPELL_HASTE, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(SPELL_MASS_HASTE, si.caster))
        RemoveSpellEffects(SPELL_MASS_HASTE, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(TASPELL_BLINDING_SPEED_2, si.caster))
        RemoveSpellEffects(TASPELL_BLINDING_SPEED_2, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(TASPELL_BLINDING_SPEED_3, si.caster))
        RemoveSpellEffects(TASPELL_BLINDING_SPEED_3, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(647, si.caster))
        RemoveSpellEffects(647, OBJECT_SELF, si.caster);

    int nAttackBonus, nExtraAttacks, nACDodge, nDamBonus, nDamType, nSaveBonus;
    float fDuration;

    if(si.id == TASPELL_BLINDING_SPEED_3){
        nAttackBonus = 4;
        nExtraAttacks = 2;
        nACDodge = 6;
        nDamBonus = 52; // 3d8
        nDamType = DAMAGE_TYPE_BLUDGEONING;
        nSaveBonus = 6;
        fDuration = 150.0f;
    }
    else if(si.id == TASPELL_BLINDING_SPEED_2){
        nAttackBonus = 3;
        nExtraAttacks = 1;
        nACDodge = 5;
        nDamBonus = DAMAGE_BONUS_2d8;
        nDamType = DAMAGE_TYPE_BLUDGEONING;
        nSaveBonus = 5;
        fDuration = 120.0f;
    }
    else{
        nAttackBonus = 2;
        nExtraAttacks = 0;
        nACDodge = 4;
        nDamBonus = DAMAGE_BONUS_1d8;
        nDamType = DAMAGE_TYPE_BLUDGEONING;
        nSaveBonus = 4;
        fDuration = 60.0f;
    }

    effect eHaste = EffectHaste();
    effect eAB = EffectAttackIncrease(nAttackBonus);
    effect eAC = EffectACIncrease(nACDodge);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus);
    effect eDam = EffectDamageIncrease(nDamBonus, nDamType);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);
    eLink = EffectLinkEffects(eLink, eAB);

    if(nExtraAttacks > 0) {
        effect eExtraAttacks = EffectAdditionalAttacks(nExtraAttacks);
        eLink = EffectLinkEffects(eLink, eExtraAttacks);
    }                 // edited by Guile added {}

    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eDam);

    //Fire cast spell at event for the specified target
    SignalEvent(si.caster, EventSpellCastAt(si.caster, si.id, FALSE));
    //Check for metamagic extension

    // Apply effects to the currently selected target.
    effect eVis = EffectVisualEffect(460);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.caster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), si.caster, fDuration);

}
