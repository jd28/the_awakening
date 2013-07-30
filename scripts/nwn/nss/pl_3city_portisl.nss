#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nHD = GetHitDice(oPC);
    string sWaypoint;

    if(nHD < 30 || Random(100)+1 > 70){ // Attacked at sea
        sWaypoint = "wp_pl_pirate_npc";
    }
    else{ // Straight to Island
        sWaypoint = "wp_strngisle_enter";
    }
    JumpSafeToWaypoint(sWaypoint, oPC);
}
