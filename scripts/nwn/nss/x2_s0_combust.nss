//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The initial eruption of flame causes  2d6 fire damage +1
   point per caster level(maximum +10)
   with no saving throw.

   Further, the creature must make
   a Reflex save or catch fire taking a further 1d6 points
   of damage. This will continue until the Reflex save is
   made.

   There is an undocumented artificial limit of
   10 + casterlevel rounds on this spell to prevent
   it from running indefinitly when used against
   fire resistant creatures with bad saving throws

*/
//:://////////////////////////////////////////////
// Created: 2003/09/05 Georg Zoeller
//:://////////////////////////////////////////////

#include "gsp_func_inc"
#include "x2_inc_toollib"

//void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic);

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nDamType = DAMAGE_TYPE_FIRE, nDamDice = si.clevel, nDamSides = 6;

	struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 20);
	if (nDamDice > fb.cap)
		nDamDice = fb.cap;

    //--------------------------------------------------------------------------
    // Calculate the damage, 2d6 + casterlevel, capped at +10
    //--------------------------------------------------------------------------
    int nDamage = MetaPower(si, nDamDice, nDamSides, si.clevel, fb.dmg);

    //--------------------------------------------------------------------------
    // Calculate the duration (we need a duration or bad things would happen
    // if someone is immune to fire but fails his safe all the time)
    //--------------------------------------------------------------------------
    float fDuration = RoundsToSeconds(10 + si.clevel);

    //--------------------------------------------------------------------------
    // Setup Effects
    //--------------------------------------------------------------------------
    effect eDam      = EffectDamage(nDamage, nDamType);
    effect eDur      = EffectVisualEffect(498);

    if(!GetIsReactionTypeFriendly(si.target)){
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

       //-----------------------------------------------------------------------
       // Check SR
       //-----------------------------------------------------------------------
        if(!GetSpellResisted(si, si.target)){
           //-------------------------------------------------------------------
           // Apply VFX
           //-------------------------------------------------------------------
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
            TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(si.target), 5, 0.1f,0.0f, 2.0f);

            //------------------------------------------------------------------
            // This spell no longer stacks. If there is one of that type,
            // that's enough
            //------------------------------------------------------------------
            if (GetHasSpellEffect(si.id, si.target) || GetHasSpellEffect(SPELL_INFERNO, si.target)){
                FloatingTextStrRefOnCreature(100775,si.caster,FALSE);
                return;
            }

            //------------------------------------------------------------------
            // Apply the VFX that is used to track the spells duration
            //------------------------------------------------------------------
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, si.target, fDuration);

            //------------------------------------------------------------------
            // Tick damage after 6 seconds again
            //------------------------------------------------------------------
        }
    }
}
