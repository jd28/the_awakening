#include "pc_funcs_inc"
#include "pc_persist"

void main(){
    int nGold = GetLocalInt(OBJECT_SELF, "con_gold");
    object oPC = GetPCSpeaker();

    if(GetGold(oPC) < nGold){
        SpeakString("Oh, no.  Not to worry, come back when you have the money.");
        return;
    }
    TakeGoldFromCreature(nGold, oPC, TRUE);
    SetPersistantInt(GetPCSpeaker(), "port:DrowOutskirts", 1);
}
