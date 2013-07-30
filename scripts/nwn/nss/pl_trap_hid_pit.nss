#include "pc_funcs_inc"

void TrapPlayAnim(object oTrap){
   AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
}


void main(){
    object oPC = GetEnteringObject();
    object oTrap = GetNearestObjectByTag("ZEP_TRAPS012", oPC);

    AssignCommand(oTrap, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
    DelayCommand(0.5,JumpSafeToWaypoint("wp_tombhor_oubliette_"+IntToString(d8()), oPC));

}
