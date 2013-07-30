#include "gsp_func_inc"

void ApplyInvis(){
    effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eLight = EffectVisualEffect(VFX_FNF_BLINDDEAF);
    location lLoc = GetLocation(OBJECT_SELF);
    float fDelay = GetRandomDelay(0.2, 0.6);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLight, OBJECT_SELF, fDelay);
    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, OBJECT_SELF, fDelay));
}

void main(){
    float fDelay = GetRandomDelay(0.5, 1.0);
    int nFlickers = d6
    () + 4, i;

    for(i = 0; i < nFlickers; i++){
        DelayCommand(fDelay, ApplyInvis());
        fDelay += GetRandomDelay(0.2, 0.6);
    }
}
