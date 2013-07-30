#include "area_inc"
int StartingConditional()
{

    if(!GetIsAreaClear(GetArea(OBJECT_SELF), GetPCSpeaker()) ||
        GetLocalInt(OBJECT_SELF, "dno_attacked") != 2)
        return FALSE;

    return TRUE;
}
