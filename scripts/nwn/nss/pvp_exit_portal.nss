#include "pl_pvp_inc"

void main(){
    object oPC = GetLastUsedBy();
    if(GetIsInCombat(oPC)){
        SendMessageToPC(oPC, "You cannot port in combat!");
        return;
    }

    string sWaypoint;
    int nTeam = GetLocalInt(oPC, "PVP_SIDE");
    if(nTeam == 0) JumpSafeToWaypoint("wp_blackwell_academy", oPC);

    if(GetLocalInt(OBJECT_SELF, "PVP_SIDE") != nTeam){
        SendMessageToPC(oPC, "You cannot use the other teams portal!");
        return;
    }

    sWaypoint = "wp_home_team"+IntToString(nTeam);
    JumpSafeToWaypoint(sWaypoint, oPC);
}
