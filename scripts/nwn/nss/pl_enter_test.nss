#include "pc_funcs_inc"
#include "srv_funcs_inc"

int StartingConditional(){
    object oPC = GetPCSpeaker();

    //Only DMs and Admins can use this until tested.
    //if(!VerifyAdminKey(oPC) && !VerifyDMKey(oPC))
    //    return FALSE;

    return GetIsTestCharacter(oPC);
}
