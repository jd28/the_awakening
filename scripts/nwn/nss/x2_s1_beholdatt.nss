//::///////////////////////////////////////////////
//:: x2_s1_beholdatt
//:: Beholder Attack Spell Logic
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This spellscript is the core of the beholder's
    attack logic.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-28
//:://////////////////////////////////////////////

/*
?Disintegrate (Fort save or take 120+ damage)
?Enervation (save or take 1-4 temporary negative level)
?Flesh to Stone (Fort save or be petrified, until succeeding a later saving throw every minute)
?Slow;
?Finger of Death (Fort save or die,if save 20D6 negative)
?Scorching Ray (fire damage)
?Bestow Curse (-2 to all ability scores on fail)
?Hold Monster (Will save or be immobilized)
?Inflict Serious Wounds
*/

#include "x2_inc_beholder"
#include "gsp_func_inc"

void main(){
    //SpeakString("x2_s1_beholdatt");

    int nApp = GetAppearanceType(OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    location lLoc = GetLocation(oTarget), lFail;
    vector vFail;
    float fDelay;
    int nTargets  = d4(), nRay, nHit, nSaveType, nDuration, nDam, nProj = BEHOLDER_RAY_DEATH, nSaveDC = 60;
    effect eLink;

    // need that to make them not drop out of combat
    SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    while(oTarget != OBJECT_INVALID && nTargets > 0){
        if(GetIsEnemy(oTarget)){
            //SpeakString(GetName(oTarget));
            nHit = TouchAttackRanged(oTarget,FALSE);
            if(nHit > 0){
                //SpeakString("Hit");
                nRay = d10();

                // Setup Saves & Projectiles
                switch(nRay){
                    case 1:  // Disintigrate
                    case 10:
                        nSaveType = SAVING_THROW_FORT;
                    case 2:  // Enervation
                    case 7:
                        nSaveType = SAVING_THROW_FORT;
                        nProj = BEHOLDER_RAY_WOUND;
                    break;
                    case 3:  // Flesh To Stone
                    case 5:
                    case 8:
                        nSaveType = SAVING_THROW_FORT;
                        nProj = BEHOLDER_RAY_PETRI;
                    break;
                    case 4:  // Finger of Death
                    case 9:
                        nSaveType = SAVING_THROW_NONE;
                    break;
                    case 6: // Scortching Ray
                        nSaveType = SAVING_THROW_REFLEX;
                        nProj = BEHOLDER_RAY_CHARM;
                    break;
                }

                if(nSaveType == SAVING_THROW_NONE
                   || MySavingThrow(nSaveType, oTarget, nSaveDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF, fDelay) == 0){
                   //SpeakString("Apply Ray: " + IntToString(nRay));
                    switch(nRay){
                        case 1:  // Disintigrate
                        case 10:
                            //SpeakString("Disintigrate");
                            ApplyVisualToObject(234, oTarget);
                            nDam = d10(60);
                            if(nHit == 2) nDam = 10 * 60;
                            eLink = EffectDamage(nDam);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                            ApplyRayToObject(VFX_BEAM_DISINTEGRATE, oTarget);

                        case 2:  // Enervation
                        case 7:
                            eLink = EffectLinkEffects(EffectNegativeLevel(d4(2)),
                                                      EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(GetHitDice(OBJECT_SELF)));
                            ApplyVisualToObject(VFX_IMP_REDUCE_ABILITY_SCORE, oTarget);
                            ApplyRayToObject(VFX_BEAM_EVIL, oTarget);
                        break;
                        case 3:  // Flesh To Stone
                        case 5:
                        case 8:
                            //SpeakString("Flesh to Stone");
                            if(!GetHasEffect(EFFECT_TYPE_PETRIFY)){
                                ApplyVisualToObject(VFX_IMP_POLYMORPH, oTarget);
                                eLink = EffectPetrify();
                                eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
                                nDuration = 2 + d4();
                                if(nHit == 2) nDuration *= 2; // Crit... double duration.
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                                ApplyRayToObject(VFX_BEAM_BLACK, oTarget);
                            }
                            else // They have the effect so forget this target.
                                nTargets++;
                        break;
                        case 4:  // Finger of Death
                        case 9:
                            //SpeakString("Finger of Death");
                            ApplyVisualToObject(VFX_IMP_NEGATIVE_ENERGY, oTarget);
                            nDam = d6(20);
                            if(nHit == 2) nDam = 20 * 6;
                            eLink = EffectDamage(nDam);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                            ApplyRayToObject(VFX_BEAM_EVIL, oTarget);
                        break;
                        case 6: // Scortching Ray
                            //SpeakString("Scorting Ray");
                            nDam = d10(60);
                            if(nHit == 2) nDam = 10 * 60;
                            if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                                nDam /= 2;
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(498), oTarget, RoundsToSeconds(1));
                            eLink = EffectDamage(nDam);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                            ApplyRayToObject(VFX_BEAM_FIRE_W, oTarget);
                        break;
                    }
                }
                //SpeakString("FakeSpell");
                //ActionCastFakeSpellAtObject(nProj, oTarget);
            }

            nTargets--;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    }

    // Only if we are beholders andnot  beholder mages
    if (nApp == 472 ||nApp == 401 || nApp == 403)
    {
        OpenAntiMagicEye(oTarget);
    }
}
