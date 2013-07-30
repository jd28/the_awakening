// con_below_lvl
#include "pc_funcs_inc"

int StartingConditional(){

    int nLevel = GetLocalInt(OBJECT_SELF, "con_level");

    return GetLevelIncludingLL(GetPCSpeaker()) < nLevel;
}
