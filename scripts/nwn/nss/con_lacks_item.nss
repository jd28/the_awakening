#include "quest_func_inc"

int StartingConditional(){
    return !HasItem(GetPCSpeaker(), GetLocalString(OBJECT_SELF, "LacksItem"));
}
