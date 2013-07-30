// Player has told the truth...

#include "quest_func_inc"

void main(){
    object oPC = GetPCSpeaker();

    QuestAdvance(OBJECT_SELF, oPC, 7);

    // Give helmet.
}
