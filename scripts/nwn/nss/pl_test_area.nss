#include "nwnx_funcs"

void main(){
/*
    object oArea = GetFirstArea();
    while(oArea != OBJECT_INVALID){
        SendMessageToPC(GetFirstPC(), GetTag(oArea));
        oArea = GetNextArea();
    }
*/
    int i;
    object pc = GetFirstPC();
    for(i = 0; i < 1000; i++){
        SendMessageToPC(pc, IntToString(SetAge(pc, 1000)));
    }
}
