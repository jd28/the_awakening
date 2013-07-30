#include "pc_funcs_inc"
#include "sha_subr_methds"
#include "pl_pvp_inc"

void main(){

    object oPC = GetLastRespawnButtonPresser();
    if (!GetIsPC(oPC)) return;

    // -------------------------------------------------------------------------
    // Arena Code
    // -------------------------------------------------------------------------
    if(GetLocalInt(GetModule(), "PVP_ACTIVE") && GetLocalInt(oPC, "PVP_SIDE") != 0){
        PVPModRespawn(oPC);
    }
    else{
        PCRespawn(oPC);
    }

    // Reapply SuperNatural Effects, in case.
    ApplyFeatSuperNaturalEffects(oPC);

    // SSE
    SubraceOnPlayerRespawn();
}
