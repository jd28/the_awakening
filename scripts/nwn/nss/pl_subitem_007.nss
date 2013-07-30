#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_SLASHING);
    effect eLink = EffectLinkEffects(eDur, eDmg);
    float fDelay, fDuration = 120.0f, fRadius = 20.0f;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC), TRUE);
    while(GetIsObjectValid(oTarget)){
        if (GetIsFriend(oTarget, oPC) || oTarget == oPC){
            fDelay = GetRandomDelay();

            //Apply the linked effects and the VFX impact
            DelayCommand(fDelay, ApplyVisualToObject(VFX_IMP_HEAD_ODD, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC), TRUE);
    }
}
