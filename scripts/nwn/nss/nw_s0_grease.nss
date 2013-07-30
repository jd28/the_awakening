//::///////////////////////////////////////////////
//:: Grease
//:: NW_S0_Grease.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
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
    object oAoE = GetNearestObjectByTag("VFX_PER_GREASE", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_GREASE", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE      = EffectAreaOfEffect(AOE_PER_GREASE);
    object oOther    = GetNearestObjectByTag("VFX_PER_GREASE", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    impact           = CreateSpellImpact();
    impact.nDurType  = EFFECT_TRUETYPE_KNOCKDOWN;
    impact.nDurSave  = SAVING_THROW_REFLEX;
    impact.nDurVis   = VFX_IMP_SLOW;
    impact.fDuration = 3.0f;
    impact.eDur      = EffectKnockdown();

    if (GetIsObjectValid(oOther)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Grease spell may exist in an area at the same time.");
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
