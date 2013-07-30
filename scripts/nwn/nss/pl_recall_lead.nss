#include "pc_funcs_inc"
void main(){
    object oPC = GetPCSpeaker();
    object oLeader = GetFactionLeader(oPC);

    if(oPC != oLeader)
        JumpSafeToObject(oLeader, oPC);
    else
        SendMessageToPC(oPC, C_RED+"You are party leader!"+C_END);
}
