#include "rlgs_func_inc"

void main(){

    struct rlgs_info ri;

    ri.oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, "rlgs_loot_bag", GetLocation(OBJECT_SELF));
    if(!GetIsObjectValid(ri.oContainer)) return;

    ri.oHolder = GetNearestObjectByTag("rlgs_info");
    ri.oPC = GetLastKiller();
    ri.nClass = -1;

    int nEffect = GetLocalInt(ri.oHolder, "rlgs_effect");

    // Prevent multiple click spawning

    SetLocalInt(ri.oHolder, "rlgs_used", GetLocalInt(GetModule(), "MOD_RESET_TIMER"));
    RLGSGenerateLoot(ri);

    if(nEffect > 0)
        ApplyVisualToObject(nEffect, ri.oContainer);
}
