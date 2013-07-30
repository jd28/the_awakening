//::///////////////////////////////////////////////
//:: Name n_check_area
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Checks area for players. If none are present -
     set int on control mechanism to turn it off
*/
//:://////////////////////////////////////////////
//:: Created By: nereng
//:: Created On: 12.11.04
//:://////////////////////////////////////////////
#include "x2_am_inc"
void main()
{
    if (NoPlayerInArea() == TRUE)
    {
    SetLocalInt(OBJECT_SELF, "RunHB",0);
    }
}
