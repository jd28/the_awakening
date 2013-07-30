//::///////////////////////////////////////////////
//:: Greater Ruin
//:: X2_S2_Ruin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The caster deals 35d6 damage to a single target
   fort save for half damage
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 18, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "gsp_func_inc"

void main(){

    if (!X2PreSpellCastCode()) return;

    struct SpellInfo sSI = GetSpellInfo(OBJECT_SELF);

    float fDist = GetDistanceBetween(OBJECT_SELF, sSI.target);
    float fDelay = fDist / (3.0 * log(fDist) + 2.0);

    if (spellsIsTarget(sSI.target, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
        //Fire cast spell at event for the specified target
        SignalEvent(sSI.target, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Roll damage
        int nDam = d12(40) + 120;

        //Set damage effect
        if (MySavingThrow(SAVING_THROW_FORT, sSI.target, sSI.dc, SAVING_THROW_TYPE_SPELL, OBJECT_SELF) != 0 ){
            nDam /= 2;
        }

        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
        ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(sSI.target));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), sSI.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), sSI.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), sSI.target);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, sSI.target));
    }
}
