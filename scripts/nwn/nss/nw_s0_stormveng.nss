//::///////////////////////////////////////////////
//:: Storm of Vengeance
//:: NW_S0_StormVeng.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "gsp_func_inc"

struct FocusBonus fb;

void DoAoEHeartbeat (object oAoE, struct SpellInfo si) {
    if(!GetIsObjectValid(oAoE)) return;
    if (!GetIsObjectValid(si.caster) || GetArea(si.caster) != GetArea(oAoE)){
        SetPlotFlag(oAoE, FALSE);
        DestroyObject(oAoE, 0.5);
        return;
    }
    DelayCommand(RoundsToSeconds(1), DoAoEHeartbeat(oAoE, si));

    float fDelay;
    effect eStun = EffectStunned();
    effect eVisStun = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eStun, eVisStun);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eVisElec = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    int nDamage;
    si.clevel  = (si.clevel > 50) ? 50 : si.clevel;

    object oTarget = GetFirstInPersistentObject(oAoE);
    while (GetIsObjectValid(oTarget)) {
        if (!GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE)) {
            oTarget = GetNextInPersistentObject(oAoE);
            continue;
        }
        SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));

        nDamage = MetaPower(si, si.clevel, 8, 0, fb.dmg); 
        fDelay = GetRandomDelay(0.5, 2.0);
        if (!GetSpellResisted(si, oTarget)) {
            if (GetSpellSaved(si, SAVING_THROW_REFLEX, oTarget, SAVING_THROW_TYPE_ELECTRICITY)){
                nDamage /= 2;
                effect eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                effect eVisAcid = EffectVisualEffect(VFX_IMP_ACID_S);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                if (d2() == 1) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
            }
            else{
                effect eElec = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
            }
        }
        oTarget = GetNextInPersistentObject(oAoE);
    }
}
void StartAoEHeartbeat (struct SpellInfo si) {
    if (!GetIsObjectValid(si.caster))
        return;
    object oAoE = GetNearestObjectByTag("VFX_PER_STORM", si.caster);
    int nCount = 1;
    while (GetIsObjectValid(oAoE)) {
        if (!GetLocalInt(oAoE, "AoEHeartbeat")) {
            SetLocalInt(oAoE, "AoEHeartbeat", 1);
            DelayCommand(0.0, DoAoEHeartbeat(oAoE, si));
            return;
        }
        oAoE = GetNearestObjectByTag("VFX_PER_STORM", si.caster, ++nCount);
    }
}
void main() {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eVis   = EffectVisualEffect(VFX_FNF_STORM);
    effect eAoE   = EffectAreaOfEffect(AOE_PER_STORM);
    float fDur    = GetPersistentAoEDuration(si);
    object oOther = GetNearestObjectByTag("VFX_PER_STORM", si.caster, 2);
    fb            = GetOffensiveFocusBonus(si.caster, si.school, 60);

    if (GetIsObjectValid(oOther) && GetIsPC(si.caster)) {
        DestroyObject(oOther);
        ErrorMessage(si.caster, "To prevent lag, only 2 Storm of Vengence spells may exist in an area at the same time.");
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, si.loc);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, si.loc, fDur);
    DelayCommand(2.0, StartAoEHeartbeat(si));
}
/**/
