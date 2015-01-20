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
	si.caster = OBJECT_SELF;
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

    if (GetHasSpellEffect(1515, si.caster))
        RemoveSpellEffects(1515, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(1516, si.caster))
        RemoveSpellEffects(1516, OBJECT_SELF, si.caster);
    if (GetHasSpellEffect(1517, si.caster)) {
        RemoveSpellEffects(1517, OBJECT_SELF, si.caster);
	}

    int nExtraAttacks = 0;
    float fDuration = 60.0f;
	int hp = 1;
	int regen = 10;
	int imm = 5;

    if(si.id == 1517){
        nExtraAttacks = 2;
		hp = 5;
		regen = 30;
		imm = 10;
        fDuration = 180.0f;
    }
    else if(si.id == 1516){
		hp = 2;
		regen = 20;
        nExtraAttacks = 1;
        fDuration = 120.0f;
    }

    effect eHaste = EffectHaste();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHaste, eDur);

    if(nExtraAttacks > 0) {
        effect eExtraAttacks = EffectAdditionalAttacks(nExtraAttacks);
        eLink = EffectLinkEffects(eLink, eExtraAttacks);
    }

	// Permenant Hitpoints DO go in the link.
	eLink = EffectLinkEffects(eLink, EffectPermenantHitpoints(hp * GetHitDice(si.caster)));
	eLink = EffectLinkEffects(eLink, EffectRegenerate(regen, 6.0));
	eLink = EffectLinkEffects(eLink, EffectDamageImmunityAll(imm));

    //Fire cast spell at event for the specified target
    SignalEvent(si.caster, EventSpellCastAt(si.caster, si.id, FALSE));
    //Check for metamagic extension

    // Apply effects to the currently selected target.
    effect eVis = EffectVisualEffect(460);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.caster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), si.caster, fDuration);

}
