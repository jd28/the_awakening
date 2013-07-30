//::///////////////////////////////////////////////
//:: Epic Sonic Trap
//:: X2_T1_SoncEpicC
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 4 rounds and 40d4 damage
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main()
{
    //Declare major variables
    object oTarget;
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
        nDice = 40;
        nSides = 4;
        nDC = 30;
    }

    object oCreator = GetTrapCreator(OBJECT_SELF);
    if(oCreator != OBJECT_INVALID){
        Logger(oCreator, "DebugEvents", LOGLEVEL_DEBUG, "Trap Valid: %s, Set: %s, DC: %s, Dice: %s, Sides: %s",
            GetName(oCreator), GetTag(OBJECT_SELF), IntToString(nDC), IntToString(nDice), IntToString(nSides));
    }


    effect eDam;
    effect eStun = EffectStunned();
    effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eLink = EffectLinkEffects(eStun, eMind);
    //effect eDam;
    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(GetEnteringObject()));
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    while (GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Roll damage
            nDamage = RollDice(nDice, nSides);
            //Make a Will roll to avoid being stunned
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            //Apply the VFX impact and damage effect
            DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            //Get the next target in the spell area
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(GetEnteringObject()));
    }
}

