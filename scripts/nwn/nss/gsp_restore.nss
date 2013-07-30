#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;
    int bGrtRestor, bRestor, nVis, nEType;

    switch(si.id){
        case SPELL_LESSER_RESTORATION:
            nVis = VFX_IMP_RESTORATION_LESSER;
        break;
        case 568: //Restore Others
        case SPELL_RESTORATION:
            nVis = VFX_IMP_RESTORATION;
            bRestor = TRUE;
        break;
        case SPELL_GREATER_RESTORATION:
            bGrtRestor = TRUE;
            nVis = VFX_IMP_RESTORATION_GREATER;
        break;
    }

    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    Restore(si, bRestor, bGrtRestor);

    if(bGrtRestor && GetRacialType(si.target) != RACIAL_TYPE_UNDEAD){
        //Apply the VFX impact and effects
        int nHeal = GetMaxHitPoints(si.target) - GetCurrentHitPoints(si.target);
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, si.target);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, si.target);
}
