//::///////////////////////////////////////////////
//:: Mummy Dust
//:: X2_S2_MumDust
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons a strong warrior mummy for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

#include "pl_summon_inc"
#include "gsp_func_inc"

void Scale(){
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);

    Log("Attempting to Scale Epic Mummy");

    ScaleEpicMummy(oSummon, GetHighestCasterAbility(OBJECT_SELF));
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if(si.id < 0) return;


    //Declare major variables
    int nDuration = 24;
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Summon the appropriate creature based on the summoner level
    //Warrior Mummy
    eSummon = EffectSummonCreature("X2_S_MUMMYWARR",496,1.0f);
    eSummon = ExtraordinaryEffect(eSummon);
    //Apply the summon visual and summon the undead.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
    DelayCommand(2.0f, Scale());
}


