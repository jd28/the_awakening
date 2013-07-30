#include "area_inc"

void main(){
    object oPC = GetLastUsedBy();
    object oMarker = GetNearestObjectByTag("pl_tombhor_famtomb", oPC);
    int bClear = TRUE; //GetIsAreaClear(GetArea(oPC));
    string sWaypoint = "wp_" + GetTag(OBJECT_SELF);

    if(GetIsInCombat(oPC)){
        ErrorMessage(oPC, "A force in the area is keeping you from using this object!");
        return;
    }

    if(oMarker != OBJECT_INVALID){
        ErrorMessage(oPC, "A force in the area is keeping you from using this object!");
        return;
    }

    ApplyVisualToObject(VFX_IMP_UNSUMMON, oPC);
    DelayCommand(2.0, JumpSafeToWaypoint(sWaypoint, oPC));
}
