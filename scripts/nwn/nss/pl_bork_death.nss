#include "quest_func_inc"

void main(){
    object oPC;
    int nQuest, i = 1;
    if(GetTag(OBJECT_SELF) == "pl_malbork"){
        nQuest = 6;
    }
    else{
        nQuest = 5;
    }

    oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, i);
    while(oPC != OBJECT_INVALID){
        // Don't get the reward unless you got the letter.
        if(GetIsObjectValid(GetItemPossessedBy(oPC, "pl_bork_letter")))
            QuestAdvance(OBJECT_SELF, oPC, nQuest);

        i++;
        oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, i);
    }
}
