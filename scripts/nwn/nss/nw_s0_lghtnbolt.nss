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
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;

	//Get first target in the lightning area by passing in the location of first target and the casters vector (position)
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, nMask, GetPosition(si.caster));
	while (GetIsObjectValid(oTarget)) {
		if ( oTarget == OBJECT_SELF ) { continue; }

		if (!GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)) { continue; }
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
		//Make an SR check
		if (GetSpellResisted(si, si.target)) { continue; }

		//Roll damage
		nDamage = MetaPower(si, dice, 6, 0, fb.dmg);

		//Adjust damage based on Reflex Save, Evasion and Improved Evasion
		nDamage = GetReflexAdjustedDamage(nDamage, oTarget, si.dc,
										  SAVING_THROW_TYPE_ELECTRICITY);
		//Set damage effect
		eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
		if(nDamage > 0) {
			fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
			//Apply VFX impcat, damage effect and lightning effect
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
		//Set the currect target as the holder of the lightning effect
		//oNextTarget = oTarget;
		//eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);

		//Get the next object in the lightning cylinder
		oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, nMask, GetPosition(OBJECT_SELF));
	}
}
