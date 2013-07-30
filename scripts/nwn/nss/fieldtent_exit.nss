#include "pc_funcs_inc"

//Put this script OnFailToOpen of a door
//This script ports the user of the field tent back to where they set it up.

void main(){

    object oPC = GetClickingObject();

    location lTarget = GetLocalLocation(oPC, "tent_prev_loc");
    JumpSafeToLocation(lTarget, oPC);

    DeleteLocalString(oPC, "tent_prev_loc");
}
