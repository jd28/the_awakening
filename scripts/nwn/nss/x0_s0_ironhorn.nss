//::///////////////////////////////////////////////
//:: Balagarn's Iron Horn
//::
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Create a virbration that shakes creatures off their feet.
// Make a strength check as if caster has strength 20
// against all enemies in area
// Changes it so its not a cone but a radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003


#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;


    //Declare major variables
    float fDelay;
    float nSize =  RADIUS_SIZE_COLOSSAL;
    effect eExplode = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, si.caster, RoundsToSeconds(d3()));
    //Apply epicenter explosion on caster
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(si.caster));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, si.loc, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)){
        // * spell should not affect the caster
        if (GetIsSpellTarget(si, oTarget, TARGET_TYPE_STANDARD) && oTarget != si.caster){
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(oTarget))/20;
            if (!GetSpellResisted(si, oTarget, fDelay)){
                effect eTrip = EffectKnockdown();
                // * DO a strength check vs. Strength 20
                if (d20() + GetAbilityScore(oTarget, ABILITY_STRENGTH) <= 20 + d20() ){
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                    FloatingTextStrRefOnCreature(2750, si.caster, FALSE);
             }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, si.loc, TRUE, OBJECT_TYPE_CREATURE);
    }
}







