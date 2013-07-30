#include "mod_funcs_inc"

void main(){
    object oCaster = OBJECT_SELF;
    object oWeapon = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();



    if(!GetHasSpellEffect(TASPELL_ONHIT_FREEZE, oTarget) && Random(100)+1 > 90){
        effect eFreeze = EffectCutsceneParalyze();
        eFreeze = EffectLinkEffects(eFreeze, EffectVisualEffect(VFX_DUR_ICESKIN));
        eFreeze = EffectLinkEffects(eFreeze, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        SetEffectSpellId(eFreeze, TASPELL_ONHIT_FREEZE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, RoundsToSeconds(2));
    }
}
