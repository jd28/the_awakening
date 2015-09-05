#include "pc_funcs_inc"

int StartingConditional(){
    object oPC = GetPCSpeaker();
    if(GetIsTestCharacter(oPC))
        return FALSE;

    int nGuild = GetLocalInt(oPC, "pc_guild");
    if(nGuild <= 0)
        return FALSE;

    return TRUE;
}
