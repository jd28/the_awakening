//::///////////////////////////////////////////////
//:: Chain Lightning
//:: NW_S0_ChLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The primary target is struck with 1d6 per caster,
    1/2 with a reflex save.  1 secondary target per
    level is struck for 1d6 / 2 caster levels.  No
    repeat targets can be chosen.
*/
//:://////////////////////////////////////////////
//:: Created By: Brennon Holmes
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 26, 2001
//:: Update Pass By: Preston W, On: July 26, 2001

/*
bugfix by Kovi 2002.07.28
- successful saving throw and (improved) evasion was ignored for
 secondary targets,
- all secondary targets suffered exactly the same damage
2002.08.25
- primary target was not effected
*/

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE;
    int nNumAffected = 0;
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, si.caster, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oHolder, oFirstTarget;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 40);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    int nDamage = MetaPower(si, nDamDice, 6, 0, fb.dmg);

    //Damage the initial target
    if (GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make an SR Check
        if (!GetSpellResisted(si, si.target)){
            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, si.target, si.dc, SAVING_THROW_TYPE_ELECTRICITY);
            //Set the damage effect for the first target
            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            //Apply damage to the first target and the VFX impact.
            if(nDamage > 0){
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,si.target);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,si.target);
            }
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, si.target, 0.5);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, si.target, BODY_NODE_CHEST);

    // *
    // * Secondary Targets
    // *
    //Get the first target in the spell shape
    float fDelay = 0.2;
    int nCnt = 0;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.target), TRUE, nMask);
    while (GetIsObjectValid(oTarget) && nCnt < si.clevel){
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != si.target && GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE) && oTarget != si.caster){
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 0.5));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
            //Do an SR check
            if (!GetSpellResisted(si, si.target, fDelay)){
                nDamage = GetReflexAdjustedDamage(nDamage, si.target, si.dc, SAVING_THROW_TYPE_ELECTRICITY);
                //Set the damage effect for the first target
                eDamage = EffectDamage(nDamage / 2, DAMAGE_TYPE_ELECTRICAL);
                if(nDamage > 0){
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
                eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else{
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning)){
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
            nCnt++;
        }

        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.target), TRUE, nMask);
      }
 }
