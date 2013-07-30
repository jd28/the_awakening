////////////////////////////////////////////////////////////////////////////////
// gsp_elemresist
//
// Spells:
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nResist, nAmount, bDebug = FALSE;
    float fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);

    switch(si.id){
        case SPELL_ENDURE_ELEMENTS:
            nResist = 20;
            nAmount = 40;
        break;
        case SPELL_RESIST_ELEMENTS:
            nResist = 30;
            nAmount = 60;
        break;
        case SPELL_PROTECTION_FROM_ELEMENTS:
            nResist = 40;
            nAmount = 80;
        break;
        case SPELL_ENERGY_BUFFER:
            nResist = 60;
            nAmount = 120;
        break;
    }
    if(bDebug){
        Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Generic Elemental Resistance: " +
               "Resist: %s/-; Limit: %s", IntToString(nResist), IntToString(nAmount));
    }
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_SONIC, nResist, nAmount);
    effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist, nAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eElec);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    // Remove previous effects to prevent stacking
    RemoveEffectsFromSpell(si.target, si.id);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
}
