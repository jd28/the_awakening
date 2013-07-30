//::///////////////////////////////////////////////
//:: Wall of Fire
//:: NW_S0_WallFire.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall of fire that burns any creature
    entering the area around the wall.  Those moving
    through the AOE are burned for 4d6 fire damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 17, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void DoAoEHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE)) return;
    if (!GetIsObjectValid(si.caster) || GetArea(si.caster) != GetArea(oAoE)){
        DestroyObject(oAoE, 0.5);
        return;
    }
    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));
    int nDamage, nDice = si.clevel / 8;

    if (nDice < 1) nDice = 1;

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDamage;
    object oTarget = GetFirstInPersistentObject(oAoE);
    while (GetIsObjectValid(oTarget)) {
        if (!GetIsSpellTarget(si, oTarget, TARGET_TYPE_STANDARD)) {
            oTarget = GetNextInPersistentObject(oAoE);
            continue;
        }
        SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
        if (!GetSpellResisted(si, oTarget)) {
            nDamage = MetaPower(si, 6, 8, 0, 0);
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, si.dc, SAVING_THROW_TYPE_FIRE);
            if(nDamage > 0){
                eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
        }
        oTarget = GetNextInPersistentObject(oAoE);
    }
}
void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_WALLFIRE", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_WALLFIRE", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE = EffectAreaOfEffect(AOE_PER_WALLFIRE);
    float fDur = MetaDuration(si, si.clevel, DURATION_IN_ROUNDS);

    object oOther = GetNearestObjectByTag("VFX_PER_WALLFIRE", si.caster, 2);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        FloatingTextStringOnCreature("To prevent lag, only 2 Wall of Fire spells may exist in an area at the same time.", si.caster);
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
