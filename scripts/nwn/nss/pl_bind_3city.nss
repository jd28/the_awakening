#include "pc_funcs_inc"
#include "pc_persist"

void main(){
    int nGold = 100000;
    object oPC = GetPCSpeaker();

    if(GetGold(oPC) < nGold){
        SpeakString("Must have a whole in your pocket?");
        return;
    }
    TakeGoldFromCreature(nGold, oPC, TRUE);
    SetPersistantInt(GetPCSpeaker(), "port:Freeport", 1);
}
