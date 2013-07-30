
#include "quest_func_inc"

int StartingConditional(){
    return QuestHasReqs(OBJECT_SELF, GetPCSpeaker());
}


