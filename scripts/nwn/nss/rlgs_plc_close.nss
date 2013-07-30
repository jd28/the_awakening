#include "rlgs_func_inc"

void main(){
    struct rlgs_info ri;
    ri.oContainer = OBJECT_SELF;
    ri.oHolder = GetNearestObjectByTag("rlgs_info");
    ri.oPC = GetLastOpenedBy();
    ri.nClass = -1;

    int nDelay = GetLocalInt(OBJECT_SELF, "Delay");
    int nRelock = GetLocalInt(OBJECT_SELF, "Relock");

    DeleteLocalInt(ri.oHolder, "rlgs_used");

    if(nRelock != 0)
        DelayCommand(IntToFloat(nDelay), SetLocked(OBJECT_SELF, TRUE));

}
