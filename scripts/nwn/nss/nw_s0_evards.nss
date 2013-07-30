//::///////////////////////////////////////////////
//:: Evards Black Tentacles
//:: NW_S0_Evards.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    or their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001

#include "gsp_func_inc"

struct SpellImpact impact;
struct FocusBonus fb;

void DoAoEHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE))
        return;

    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));
    ApplySpellImpactToAOE(si, impact, fb, oAoE);
}
void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_EVARDS_BLACK_TENTACLES", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_EVARDS_BLACK_TENTACLES", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES);
    object oOther = GetNearestObjectByTag("VFX_PER_EVARDS_BLACK_TENTACLES", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 20;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_BLUDGEONING;
    impact.nImpact   = VFX_COM_BLOOD_REG_RED;
    impact.nDamSides = 6;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    impact.nDamBonus = si.clevel / 2;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Evard's Black Tentacle spell may exist in an area at the same time.");
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
