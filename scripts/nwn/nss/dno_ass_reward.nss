#include "quest_func_inc"

void main(){
    QuestAdvance(OBJECT_SELF, GetPCSpeaker());
    CreateItemOnObject("dno_ass_belt", GetPCSpeaker());
}