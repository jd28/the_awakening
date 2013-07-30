//::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    if(!GetSpellResisted(si, si.target))
        DoPetrification(si.clevel, si.caster, si.target, si.id, si.dc);
}


