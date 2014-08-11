//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    int nDamage = 0;
    int nCnt;

    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
	int dice = 2;
    int nMissiles = (si.clevel / 2) + 1;
    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);

    nMissiles = (nMissiles > fb.cap) ? fb.cap : nMissiles;
	if (fb.gsf) { dice = 3; }


    float fDist = GetDistanceBetween(si.caster, si.target);
    float fDelay = fDist / (3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;


    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

        //Make SR Check
        if (!GetSpellResisted(si, si.target, fDelay)){
            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++){
                nDamage = MetaPower(si, dice, 4, 2, fb.dmg);

                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Set damage effect
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                //Apply the MIRV and damage effect
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, si.target));
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, si.target));
             }
         }
         else{
            for (nCnt = 1; nCnt <= nMissiles; nCnt++){
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, si.target);
            }
         }
     }
}
