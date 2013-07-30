#include "pc_funcs_inc"
void main(){
    object oPC = GetPCSpeaker();
    location lLoc = GetLocalLocation(oPC, "DeathLocation");
    DeleteLocalLocation(oPC, "DeathLocation");
    JumpSafeToLocation(lLoc, oPC);
}
