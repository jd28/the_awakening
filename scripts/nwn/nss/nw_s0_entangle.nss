//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_Enangle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Area of effect spell that places the entangled
  effect on enemies if they fail a saving throw
  each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 31, 2001

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
    object oAoE = GetNearestObjectByTag("VFX_PER_ENTANGLE", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_ENTANGLE", si.caster, ++nCount);
    }
}
void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;
    
    effect eLink     = EffectEntangle();
    eLink            = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ENTANGLE));
    effect eAoE      = EffectAreaOfEffect(AOE_PER_ENTANGLE);
    object oOther    = GetNearestObjectByTag("VFX_PER_ENTANGLE", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);

    impact           = CreateSpellImpact();
    impact.nDurType  = EFFECT_TRUETYPE_ENTANGLE;
    impact.nDurSave  = SAVING_THROW_REFLEX;
    impact.fDuration = 6.0f;
    impact.eDur      = eLink;

    if (GetIsObjectValid(oOther)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Incendiary Cloud spells may exist in an area at the same time.");
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
