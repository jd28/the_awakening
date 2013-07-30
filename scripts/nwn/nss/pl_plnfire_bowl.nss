#include "mod_funcs_inc"

void main(){
    if(GetLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL"))
        return;

    object oInvis = GetNearestObjectByTag("InvisibleObject");
    float fDelay = 1800.0f;
    effect eVis = EffectVisualEffect(498);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oInvis, fDelay);
    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL"));

    SetLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL", 1);
    IncrementLocalInt(GetModule(), "PL_PLNFIRE_BOWL");
}
