#include "pc_funcs_inc"
//Put this on action taken in the conversation editor
void main(){
    object oPC = GetPCSpeaker(), oTarget;

    int nDice = d4();

    string sAreaTag = GetTag(GetArea(oPC));

    if(sAreaTag != "pl_fieldtent"){
        SetLocalLocation(oPC, "tent_prev_loc", GetLocation(oPC));
        DelayCommand(0.5, JumpSafeToWaypoint("WP_fieldtent_" + IntToString(nDice), oPC));
        if(!GetIsObjectValid( GetWaypointByTag("WP_fieldtent_" + IntToString(nDice)) ))
            SendMessageToPC(oPC, "Invalid Waypoint" );
    }
    else {
        SendMessageToPC(oPC, "You cannot use the Dimensional Tent inside the Dimensional Tent!");
    }
}
