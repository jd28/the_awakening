//::///////////////////////////////////////////////
//:: Crumble
//:: X2_S0_Crumble
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// This spell inflicts 1d6 points of damage per
// caster level to Constructs to a maximum of 15d6.
// This spell does not affect living creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003/
//:: 2004-01-02: GZ: Removed Spell resistance check
//:://////////////////////////////////////////////

//TODO: Include application to petrified targets

#include "gsp_func_inc"

void DoCrumble (int nDam, object oCaster, object oTarget);

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int  nType      = GetObjectType(si.target);
    int  nRacial    = GetRacialType(si.target);
    int nDamDice = si.clevel;

    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, si.target);

    if (nType != OBJECT_TYPE_CREATURE && nType !=  OBJECT_TYPE_PLACEABLE && nType != OBJECT_TYPE_DOOR )
        return;

    if (GetRacialType(si.target) != RACIAL_TYPE_CONSTRUCT  &&
        GetLevelByClass(CLASS_TYPE_CONSTRUCT, si.target) == 0)
        return;

    int nDamage = MetaPower(si, nDamDice, 6, 0, 0);

    if (nDamage > 0){
        //----------------------------------------------------------------------
        // * Sever the tie between spellId and effect, allowing it to
        // * bypass any magic resistance
        //----------------------------------------------------------------------
        DelayCommand(0.1f, DoCrumble(nDamage, si.caster, si.target));
    }

}

//------------------------------------------------------------------------------
// This part is moved into a delayed function in order to alllow it to bypass
// Golem Spell Immunity. Magic works by rendering all effects applied
// from within a spellscript useless. Delaying the creation and application of
// an effect causes it to loose it's SpellId, making it possible to ignore
// Magic Immunity. Hacktastic!
//------------------------------------------------------------------------------
void DoCrumble (int nDam, object oCaster, object oTarget){
    float  fDist = GetDistanceBetween(oCaster, oTarget);
    float  fDelay = fDist/(3.0 * log(fDist) + 2.0);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
    effect eMissile = EffectVisualEffect(477);
    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eVis = EffectVisualEffect(135);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
}
