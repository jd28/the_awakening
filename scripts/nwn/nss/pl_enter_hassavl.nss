#include "nwnx_inc"
#include "pc_funcs_inc"

int StartingConditional(){
    // Test characters don't have saved locations.
    if(GetIsTestCharacter(GetPCSpeaker())){
        return FALSE;
    }

    location lLoc = GetDbLocation(GetPCSpeaker(), VAR_PC_SAVED_LOCATION);
    return GetIsLocationValid(lLoc);
}
