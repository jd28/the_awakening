#include "nwnx_inc"
#include "gsp_func_inc"

void main(){
    if(GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();
    int nResist, nAmount;
    float fDuration = TurnsToSeconds(10);
    nResist = 15;
    nAmount = 200;

    effect eCold = EffectDamageResistance(DAMAGE_TYPE_DIVINE, nResist, nAmount);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_MAGICAL, nResist, nAmount);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_POSITIVE, nResist, nAmount);
    effect eSonic = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, nResist, nAmount);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link Effects
    effect eLink = EffectLinkEffects(eCold, eFire);
    eLink = EffectLinkEffects(eLink, eAcid);
    eLink = EffectLinkEffects(eLink, eSonic);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    SetEffectSpellId(eLink, TASPELL_LINUS_LOLLIPOP);

    // Remove previous effects to prevent stacking
    RemoveEffectsOfSpells(OBJECT_SELF, TASPELL_LINUS_LOLLIPOP);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}
