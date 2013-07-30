//::///////////////////////////////////////////////
//:: Awaken
//:: NW_S0_Awaken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell makes an animal ally more
    powerful, intelligent and robust for the
    duration of the spell.  Requires the caster to
    make a Will save to succeed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 10, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    GSPMagicFang(si);
}
