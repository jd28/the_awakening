//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

struct SpellImpact impact;
struct FocusBonus fb;

void DoAoEHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE)) return;
    if (!GetIsObjectValid(si.caster)){
        DestroyObject(oAoE, 0.5);
        return;
    }
    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));
    ApplySpellImpactToAOE(si, impact, fb, oAoE);
}

void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_FOGFIRE", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_FOGFIRE", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE      = EffectAreaOfEffect(AOE_PER_FOGFIRE);
    object oOther    = GetNearestObjectByTag("VFX_PER_FOGFIRE", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 50;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_FIRE;
    impact.nImpact   = VFX_IMP_FLAME_S;
    impact.nDamSides = 10;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Incendiary Cloud spell may exist in an area at the same time.");
    }
    AssignCommand(GetArea(si.caster), ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur));
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
