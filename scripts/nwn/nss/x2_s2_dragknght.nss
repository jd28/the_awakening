//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons an adult red dragon for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////
#include "x2_inc_toollib"

#include "pl_summon_inc"
#include "gsp_func_inc"

void Scale(){
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);

    ScaleEpicDragonKnight(oSummon, GetHighestCasterAbility(OBJECT_SELF) );
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if(si.id < 0) return;


    //Declare major variables
    int nDuration = 20;
    effect eSummon;
    effect eVis = EffectVisualEffect(460);
    int nHD = GetHitDice(OBJECT_SELF);

    string sSummon;

    if(nHD <= 25)
        sSummon = "pl_drgkngt_001";
    else if(nHD <= 35)
        sSummon = "pl_drgkngt_002";
    else
        sSummon = "pl_drgkngt_003";

    eSummon = EffectSummonCreature(sSummon,481,0.0f,TRUE);

    // * make it so dragon cannot be dispelled
    eSummon = ExtraordinaryEffect(eSummon);
    //Apply the summon visual and summon the dragon.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,GetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,GetSpellTargetLocation()));
    DelayCommand(1.0f, Scale());
}


