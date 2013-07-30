#include "pc_funcs_inc"

void main(){
    object oPC = GetClickingObject();
    object oDoor = OBJECT_SELF;
    string sWP = "wp_"+GetTag(oDoor);

    JumpSafeToWaypoint(sWP, oPC);
}
