//::///////////////////////////////////////////////
//:: Greater Magic Fang
//:: x0_s0_gmagicfang.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    GSPMagicFang(si);
}
