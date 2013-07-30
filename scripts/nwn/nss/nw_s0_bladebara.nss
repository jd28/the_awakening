//::///////////////////////////////////////////////
//:: Blade Barrier: On Enter
//:: NW_S0_BladeBarA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){
    //Declare major variables
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
        return;

    struct SpellInfo si = GetSpellInfo(GetAreaOfEffectCreator());
    si.target = GetEnteringObject();
    if(!GetIsSpellTarget(si, si.target))
        return;

    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED), eDamage;
    int nDamage, nDamDice = si.clevel;
    if(si.clevel > 60)
        si.clevel = 60;

    Logger(si.target, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Caster: %s, Spell: %s, Target: %s, " +
           "DC: %s, SP: %s, School: %s, Caster Level: %s, Spell Level: %s, Metamagic: %s, " +
           "Item: %s, Dice: %s", GetName(si.caster), IntToString(si.id), GetName(si.target),
           IntToString(si.dc), IntToString(si.sp), IntToString(si.school), IntToString(si.clevel),
           IntToString(si.slevel), IntToString(si.meta), GetName(si.item), IntToString(nDamDice));

    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
    if (!GetSpellResisted(si, si.target)) {
        nDamage = MetaPower(si, nDamDice, 6, 0, 0);
        nDamage = GetReflexAdjustedDamage(nDamage, si.target, si.dc);

        if(nDamage > 0){
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, si.target);
        }
    }
}


//::///////////////////////////////////////////////
//:: Blade Barrier: On Enter
//:: NW_S0_BladeBarA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
/*

void main() {
    struct SpellInfo si = GetSpellInfo(GetAreaOfEffectCreator());
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED), eDamage;
    int nDamage, nDamDice = si.clevel;

    if (!GetIsObjectValid(si.caster)) return;

    if(!GetIsSpellTarget(si, oTarget)) return;

    SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
    if (!GetSpellResisted(si, oTarget)) {
        nDamage = MetaPower(si, nDamDice, 6);
        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, si.dc);

        if(nDamage > 0){
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }
    }
}
*/
