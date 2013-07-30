//pl_wp_shad_death
//
// Description: In Mt. Xansar shadows respawn on death until crystal ball is broken.
//

#include "mod_funcs_inc"
#include "vfx_inc"

void CreateShadow(string sResref, object oKiller){
    object oBall = GetNearestObjectByTag("ms_wp_crystal_orb", oKiller);

    location lLoc = GetLocation(GetWaypointByTag("wp_wp_shadspawn"));
    if(GetIsObjectValid(oBall) && !GetLocalInt(oBall, "Destroyed")){
        ApplyVisualToObject(VFX_IMP_HARM, oBall);
        object oShade = CreateObject(OBJECT_TYPE_CREATURE, sResref, lLoc);
        if(!GetIsObjectValid(oShade)){
            SendMessageToPC(oKiller, "Shade problem");
        }
    }
    else{
        SendMessageToPC(oKiller, "The orb is gone.");
    }
}

void main(){
    object oKiller = GetLastKiller();
    string sResref = GetResRef(OBJECT_SELF);
    object oBall = GetNearestObjectByTag("ms_wp_crystal_orb", oKiller);

    //SendMessageToPC(oKiller, "pl_wp_shad_death");

    CreateShadow(sResref, oKiller);
}
