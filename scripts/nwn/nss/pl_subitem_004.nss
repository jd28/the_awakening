// pl_subitem_002
#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur, EffectACIncrease(5));


    if(GetLevelByClass(CLASS_TYPE_MONK, oPC) < 3){
        SetMovementRate(oPC, MOVEMENT_RATE_VERY_FAST);
    }

    float fDuration = RoundsToSeconds(GetLevelIncludingLL(oPC));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

    DelayCommand(fDuration, IntToVoid(SetMovementRate(oPC, MOVEMENT_RATE_PC)));
}
