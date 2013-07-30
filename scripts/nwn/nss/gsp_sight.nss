////////////////////////////////////////////////////////////////////////////////
// gsp_sight
//
// Spells:
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eVis, eDur);
    effect eSight;
    float fDuration;

    switch(si.id){
        case SPELL_SEE_INVISIBILITY:
            eSight = EffectSeeInvisible();
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
        break;
        case SPELL_TRUE_SEEING:
            eSight = EffectTrueSeeing();
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
        break;
        case SPELL_DARKVISION:
            eSight = EffectUltravision();
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ULTRAVISION));
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
        break;
    }

    eLink = EffectLinkEffects(eLink, eSight);

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
}
