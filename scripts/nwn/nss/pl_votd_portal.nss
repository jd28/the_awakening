#include "pc_funcs_inc"

void main()
{
    string sWaypoint = "wp_valedead_chamber";
    if(!GetLocalInt(OBJECT_SELF, "Active")){
        SendMessageToPC(GetLastUsedBy(), "The altar has a lever that appears to be stuck.");
        return;
    }

    if(GetIsInCombat(GetLastUsedBy())){
        SendMessageToPC(GetLastUsedBy(), "You may not port in combat.");
        return;
    }

    JumpSafeToWaypoint(sWaypoint, GetLastUsedBy());
}
