#include "pc_funcs_inc"

void main(){
    if(GetLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL"))
        JumpSafeToWaypoint("wp_ms_poe5to10", GetLastUsedBy());

    if(GetLocalInt(GetModule(), "PL_PLNFIRE_BOWL") < 4)
        return;

    object oInvis = GetNearestObjectByTag("InvisibleObject");
    float fDelay = 600.0f;
    effect eVis = EffectVisualEffect(498);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oInvis, fDelay);
    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL"));

    SpeakString("You have 10 minutes to enter the portal.");
    SetLocalInt(OBJECT_SELF, "PL_PLNFIRE_BOWL", 1);
    DeleteLocalInt(GetModule(), "PL_PLNFIRE_BOWL");
}
