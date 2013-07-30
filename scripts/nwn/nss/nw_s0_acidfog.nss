//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the <span class="highlight">AoE</span> take 2d6 acid damage
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

void DoAcidFogHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE)) return;
    if (!GetIsObjectValid(si.caster)){
        DestroyObject(oAoE, 0.5);
        return;
    }
    DelayCommand(RoundsToSeconds(1), DoAcidFogHeartbeat(oAoE, si));
    ApplySpellImpactToAOE(si, impact, fb, oAoE);
}

void StartAcidFogHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_FOGACID", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAcidFogHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_FOGACID", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE      = EffectAreaOfEffect(AOE_PER_FOGACID);
    object oOther    = GetNearestObjectByTag("VFX_PER_FOGACID", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 30;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_ACID;
    impact.nImpact   = VFX_IMP_ACID_S;
    impact.nDamSides = 8;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag only 1 Acid Fog spell may exist in an area at the same time.");
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAcidFogHeartbeat(si));
}

