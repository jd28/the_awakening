#include "pc_funcs_inc"

int StartingConditional(){
    object oPC = GetPCSpeaker();
    if(GetIsTestCharacter(oPC))
        return FALSE;

    int nGuild = GetPlayerInt(oPC, "pc_guild", TRUE);
    if(nGuild <= 0)
        return FALSE;

    return TRUE;
}
