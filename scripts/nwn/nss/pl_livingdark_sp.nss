#include "gsp_func_inc"

void AnnoyingEffect(){
    int nDamage;
    float fDelay;
    effect eDamage;
    effect eBlind = EffectBlindness();
    effect eImpact = EffectVisualEffect(VFX_IMP_NIGHTMARE_HEAD_HIT);

    DelayCommand(3.0f, AnnoyingEffect());

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    while(oTarget != OBJECT_INVALID){
        if(GetIsEnemy(oTarget)){
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 3.0);

            fDelay = GetRandomDelay();
            nDamage = d12(40);
            if(FortitudeSave(oTarget, 50, SAVING_THROW_TYPE_DEATH)){
                nDamage /= 2;
            }

            eDamage = EffectDamage(nDamage);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    }
}

void main(){
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAreaOfEffect(AOE_PER_DARKNESS)), OBJECT_SELF);
    //ApplyVisualToObject(VFX_DUR_DARKNESS, OBJECT_SELF);
    DelayCommand(1.0f, AnnoyingEffect());
}
