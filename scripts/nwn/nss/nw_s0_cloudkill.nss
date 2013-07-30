//::///////////////////////////////////////////////
//:: Cloudkill
//:: NW_S0_CloudKill.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
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
    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));
    ApplySpellImpactToAOE(si, impact, fb, oAoE); 
}
void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_FOGKILL", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_FOGKILL", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE = EffectAreaOfEffect(AOE_PER_FOGKILL);
    object oOther = GetNearestObjectByTag("VFX_PER_FOGKILL", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 30;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_NEGATIVE;
    impact.nImpact   = VFX_IMP_NEGATIVE_ENERGY;
    impact.nDamSides = 8;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 CloudKill spell may exist in an area at the same time.");
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
