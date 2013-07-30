#include "pc_funcs_inc"

void main (){
    object oPC = GetLastUsedBy();
    if(GetIsInCombat(oPC)){
        ErrorMessage(oPC, "You are unable to port in combat.");
        return;
    }
    if(!GetLocalInt(oPC, "pl_xmas_santa")
       || !GetLocalInt(oPC, "pl_xmas_mrsclaus")) {
        ErrorMessage(oPC, "You have not killed Santa or Mrs Claus");
        return;
    }

    object way = GetWaypointByTag("wp_pl_xmas_end");
    JumpSafeToObject(way, oPC);
}
