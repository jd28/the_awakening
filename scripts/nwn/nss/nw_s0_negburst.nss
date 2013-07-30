//::///////////////////////////////////////////////
//:: Negative Energy Burst
//:: NW_S0_NegBurst
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster releases a burst of negative energy
    at a specified point doing 1d8 + 1 / level
    negative energy damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

// TODO : REDO

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    int nDamage;
    int nAdditionalLevelDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_20); //Replace with Negative Pulse
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDam, eHeal;

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);


    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 20);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    int nStr = nDamDice / 4;
    if (nStr == 0) nStr = 1;

    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
    effect eStr_Low = EffectAbilityDecrease(ABILITY_STRENGTH, nStr);
    effect eGood = EffectLinkEffects(eStr, eDur);
    effect eBad = EffectLinkEffects(eStr_Low, eDur2);

    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, si.loc);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)){
        if(GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE)){
            //Roll damage for each target
            nDamage = MetaPower(si, nDamDice, 8, nDamDice, fb.dmg);
            if(GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_NEGATIVE, fDelay))
                nDamage /= 2;

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(oTarget))/20;

            // * any undead should be healed, not just Friendlies
            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD){
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
                //Set the heal effect
                eHeal = EffectHeal(nDamage);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oTarget));
            }
            else if(!GetSpellResisted(si, oTarget, fDelay)){
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc);
    }
}
