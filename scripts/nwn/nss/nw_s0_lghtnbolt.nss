//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001


#include "gsp_func_inc"

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

	struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 40);
	int dice = si.clevel;
	if (dice > fb.cap) { dice = fb.cap; }

    int nDamage, nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE;
    //Set the lightning stream to start at the caster's hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    location lTarget = GetLocation(si.target);
    float fDelay;
    int nCnt = 1;

	//Get first target in the lightning area by passing in the location of first target and the casters vector (position)
	si.target = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, nMask, GetPosition(si.caster));
	while (GetIsObjectValid(si.target)) {
		if ( si.target == OBJECT_SELF ) { continue; }

		if (!GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)) { continue; }
		//Fire cast spell at event for the specified target
		SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
		//Make an SR check
		if (GetSpellResisted(si, si.target)) { continue; }

		//Roll damage
		nDamage = MetaPower(si, dice, 6, 0, fb.dmg);

		//Adjust damage based on Reflex Save, Evasion and Improved Evasion
		nDamage = GetReflexAdjustedDamage(nDamage, si.target, si.dc,
										  SAVING_THROW_TYPE_ELECTRICITY);
		//Set damage effect
		eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
		if(nDamage > 0) {
			fDelay = GetSpellEffectDelay(GetLocation(si.target), si.target);
			//Apply VFX impcat, damage effect and lightning effect
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, si.target));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis, si.target));
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, si.target, 1.0);
		//Get the next object in the lightning cylinder
		si.target = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, nMask, GetPosition(si.caster));
	}
}
