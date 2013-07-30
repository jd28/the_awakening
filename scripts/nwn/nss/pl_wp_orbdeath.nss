#include "mod_funcs_inc"
#include "vfx_inc"

void KillShadows(object oKiller){
    object oShadow = GetNearestObjectByTag("ms_wp_shadow", oKiller);
    effect eDeath = EffectDeath();
    int i = 1;

    SupernaturalEffect(eDeath);
    while(GetIsObjectValid(oShadow)){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oShadow);
        i++;
        oShadow = GetNearestObjectByTag("ms_wp_shadow", oKiller, i);
    }
}

void main(){
    object oBall = OBJECT_SELF;
    object oDoor = GetNearestObjectByTag("ms_wp_orb_door");
    object oWay = GetWaypointByTag("rlgs_info");

    SetLocalInt(oBall, "Destroyed", TRUE);

    ApplyVisualAtLocation(VFX_IMP_DISPEL_DISJUNCTION, GetLocation(oWay));
    DelayCommand(1.0, KillShadows(GetLastKiller()));


    AssignCommand(oDoor, SetLocked(oDoor, FALSE));
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
}
