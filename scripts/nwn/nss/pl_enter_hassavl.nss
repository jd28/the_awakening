#include "nwnx_inc"
#include "pc_funcs_inc"
#include "pc_persist"

int StartingConditional(){
    // Test characters don't have saved locations.
    if(GetIsTestCharacter(GetPCSpeaker())){
        return FALSE;
    }

    return GetIsLocationValid(GetPersistantLocation(GetPCSpeaker(), "loc"));
}
