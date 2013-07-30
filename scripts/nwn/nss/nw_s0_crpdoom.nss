//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The druid calls forth a mass of churning insects
    and scorpians that bite and sting all those within
    a 20ft square.  The total spell effects does
    1000 damage to all withiin the area of effect
    until all damage is dealt.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  , 2001
//:://////////////////////////////////////////////
//Needed would require an entry into the VFX_Persistant.2DA and a new AOE constant

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
    object oAoE = GetNearestObjectByTag("VFX_PER_CREEPING_DOOM", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_CREEPING_DOOM", si.caster, ++nCount);
    }
}

void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAoE      = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM);
    object oOther    = GetNearestObjectByTag("VFX_PER_CREEPING_DOOM", si.caster, 1);
    float fDur       = GetPersistentAoEDuration(si);
    int nCap         = 40;
    impact           = CreateSpellImpact();
    impact.nDamType  = DAMAGE_TYPE_SONIC;
    impact.nImpact   = VFX_COM_BLOOD_REG_RED;
    impact.nDamSides = 8;
    impact.nDamDice  = (si.clevel > nCap) ? nCap : si.clevel;
    impact.nDamBonus = si.clevel / 2;
    fb               = GetOffensiveFocusBonus(si.caster, si.school, nCap);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 1 Creeping Doom spell may exist in an area at the same time.");
    }
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
