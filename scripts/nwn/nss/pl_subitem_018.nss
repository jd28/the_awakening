// pl_subitem_002
// Spider Riding

#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int nCurrentAppearance = GetAppearanceType(oPC);

    RemoveEffectsOfSpells(oPC, SPELL_EXPEDITIOUS_RETREAT, SPELL_HASTE, SPELL_MASS_HASTE);

    int nAttackBonus = 2;
    int nExtraAttacks = 1;
    int nACDodge = 4;
    int nDamBonus = DAMAGE_BONUS_1d8;
    int nDamType = DAMAGE_TYPE_BLUDGEONING;
    int nSaveBonus = 4;
    int nDuration = GetLevelIncludingLL(oPC) / 3;

    effect eAB = EffectAttackIncrease(nAttackBonus);
    effect eExtraAttacks = EffectAdditionalAttacks(nExtraAttacks);
    effect eAC = EffectACDecrease(nACDodge);
    effect eDam = EffectDamageIncrease(nDamBonus, nDamType);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur, eAB);
    eLink = EffectLinkEffects(eLink, eExtraAttacks);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDam);
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE, 5));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_POSITIVE, 10));
    eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 10));

    //Apply the VFX impact and effects
    AssignCommand(oPC, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_WEREWOLF);
    // Apply effects to the currently selected target.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));

    DelayCommand(RoundsToSeconds(nDuration), SetCreatureAppearanceType(oPC, nCurrentAppearance));
}
