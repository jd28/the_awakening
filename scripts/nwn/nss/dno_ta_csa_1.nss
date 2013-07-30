#include "area_inc"

int StartingConditional()
{
    if(GetLocalInt(OBJECT_SELF, "dno_attacked") != 1){
        return FALSE;
    }
    
    if(!GetIsAreaClear(GetArea(OBJECT_SELF), GetPCSpeaker())){
        return FALSE;
    }

    return TRUE;
}
