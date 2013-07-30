#include "pc_funcs_inc"
void main(){
    object oPC = GetPCSpeaker();
    int levels = GetHitDice(oPC) - 1;
    //SpeakString(IntToString(levels));
    Delevel(oPC, levels);
}

