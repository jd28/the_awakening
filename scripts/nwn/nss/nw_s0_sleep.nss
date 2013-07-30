//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Goes through the area and sleeps the lowest 2d4
    HD of creatures first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    object oTarget, oLowest;
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep = EffectSleep();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nHD = MetaPower(si, 1, 4, 0, 0);
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 9;// maximun hd creature affected
    int nLow;

    float fDuration = MetaDuration(si, si.clevel + 3), fDelay;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);

    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);


    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc);

    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget)) bContinueLoop = TRUE;

    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop)){
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc);
        while (GetIsObjectValid(oTarget)){
            //Make faction check to ignore allies
            if (GetIsSpellTarget(si, oTarget) &&
                GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
                GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected){
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6){
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, si.loc);
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID){
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(si.caster, si.id));
            //Make SR check
            if (!GetSpellResisted(si, oLowest)){
                if (GetSpellSaved(si, SAVING_THROW_WILL, oLowest, SAVING_THROW_TYPE_MIND_SPELLS, fDelay)){
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE){
                        effect eLink2 = EffectLinkEffects(eLink, eVis);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, fDuration);
                    }
                    else{ // even though I am immune apply just the sleep effect for the immunity message
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, fDuration);
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}
