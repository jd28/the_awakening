// -----------------------------------------------------------------------------
//  sj_tilemagic_ent
// -----------------------------------------------------------------------------
/*
    Area/Trigger OnEnter event script for Sunjammer's TileMagic System.

    Converts all TileMagic Markers in the area.
*/
// -----------------------------------------------------------------------------
/*
    Version 1.01 - 21 May 2006 - Sunjammer
    - removed unnecessary DelayCommand

    Version 1.00 - 26 Jun 2006 - Sunjammer
    - created
*/
// -----------------------------------------------------------------------------
#include "sj_tilemagic_i"

void main()
{
    // get area - this technique works for both areas and
    object oArea = GetArea(OBJECT_SELF);

    // check "do once" flag
    if(GetLocalInt(OBJECT_SELF, "sj_tilemagic_done"))
    {
        return;
    }

    // sweep area and convert all markers
    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
        if(GetTag(oObject) == SJ_TAG_TILEMAGIC_MARKER)
        {
            // markers found: convert
            // NOTE: there could potentially be hundreds of markers so we
            // must use AssignCommand avoid the risk of a TMI
            AssignCommand(OBJECT_SELF, SJ_TileMagic_ConvertObjectToTile(oObject));
        }
        oObject = GetNextObjectInArea(oArea);
    }

    // raise "do once" flag
    SetLocalInt(OBJECT_SELF, "sj_tilemagic_done", TRUE);
}

