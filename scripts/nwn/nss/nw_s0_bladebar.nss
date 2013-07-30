//::///////////////////////////////////////////////
//:: Blade Barrier
//:: NW_S0_BladeBar.nss
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

struct SpellImpact impact;
struct FocusBonus fb;

void DoAoEHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE)) return;
    if (!GetIsObjectValid(si.caster) || GetArea(si.caster) != GetArea(oAoE)){
        DestroyObject(oAoE, 0.5);
        return;
    }
    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));
    ApplySpellImpactToAOE(si, impact, fb, oAoE);
}

void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_WALLBLADE", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_WALLBLADE", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE      = EffectAreaOfEffect(AOE_PER_WALLBLADE);
    object oOther    = GetNearestObjectByTag("VFX_PER_WALLBLADE", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 40;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_SLASHING;
    impact.nImpact   = VFX_COM_BLOOD_LRG_RED;
    impact.nDamSides = 6;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Blade Barrier spell may exist in an area at the same time.");
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}


