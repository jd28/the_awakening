//::///////////////////////////////////////////////
//:: Epic Fire Trap
//:: X2_T1_FireEpicC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 50d6 damage to all within 10 ft.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main()
{
    //Declare major variables
    int bValid;
    object oTarget = GetEnteringObject();
    location lTarget = GetLocation(oTarget);
    int nDamage, nDice, nSides, nDC;

    nDice = GetLocalInt(OBJECT_SELF, "trap_dice");
    nSides = GetLocalInt(OBJECT_SELF, "trap_sides");
    nDC = GetLocalInt(OBJECT_SELF, "trap_dc");

    if(nDice == 0){
        nDice = GetLocalInt(GetArea(OBJECT_SELF), "trap_dice");
        nSides = GetLocalInt(GetArea(OBJECT_SELF), "trap_sides");
        nDC = GetLocalInt(GetArea(OBJECT_SELF), "trap_dc");
    }
    if(nDice == 0){
        nDice = 50;
        nSides = 6;
        nDC = 33;
    }


    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get first object in the target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    //Cycle through the target area until all object have been targeted
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Roll damage
            nDamage = RollDice(nDice, nSides);
            //Adjust the trap damage based on the feats of the target
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
            {
                if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamage /= 2;
                }
            }
            else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamage = 0;
            }
            else
            {
                nDamage /= 2;
            }
            if (nDamage > 0)
            {
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if (nDamage > 0)
                {
                    //Apply effects to the target.
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        //Get next target in shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    }
}

