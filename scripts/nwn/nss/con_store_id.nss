#include "pc_funcs_inc"

void main(){

    object oPC = GetPCSpeaker();

    if(GetGold(oPC) < 1000){
        SendMessageToPC( oPC, C_RED+"You don't have enough gold!"+C_END );
        return;
    }
    TakeGoldFromCreature( 1000, oPC, TRUE );
    IDAllItems(oPC);
}
