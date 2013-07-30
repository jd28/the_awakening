#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "pl_quest_aribel");
    if(oItem == OBJECT_INVALID){
        SpeakString("You don't have the Talisman!!!");
        return;
    }

    DestroyObject(oItem);
    GiveTakeGold(oPC, 5000, TRUE);
    GiveTakeXP(oPC, 1000, TRUE, TRUE);
}
