// pl_subitem_002
#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eDmgShield = EffectDamageShield(0, DAMAGE_BONUS_2d6, DAMAGE_TYPE_COLD);
    effect eAC = EffectACIncrease(4);
    effect eLink = EffectLinkEffects(eDur, eDur2);
    eLink = EffectLinkEffects(eLink, eDmgShield);
    eLink = EffectLinkEffects(eLink, eAC);

    ApplyVisualToObject(VFX_IMP_HEAD_COLD, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 120.0f);
}
