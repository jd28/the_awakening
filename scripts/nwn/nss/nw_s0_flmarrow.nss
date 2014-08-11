//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a stream of fiery arrows at the selected
    target that do 4d6 damage per arrow.  1 Arrow
    per 4 levels is created.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:: Updated By: Georg Zoeller, Aug 18 2003: Uncapped
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    int nDamage = 0, nCnt;
	effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);

    effect eImp = EffectVisualEffect(VFX_IMP_FLAME_S);
    int nMissiles = (si.clevel) / 4;
    float fDist = GetDistanceBetween(OBJECT_SELF, si.target);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0), fTime, fDelay2;

    //Limit missiles to five
    if(nMissiles == 0)
        nMissiles = 1;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);
	int dice = 4;
	if (fb.gsf) { dice = 14; }

    if(GetIsReactionTypeFriendly(si.target))
        return;

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    //Make SR Check
    if (GetSpellResisted(si, si.target, fDelay)){
        for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, si.target);
        return;
    }

    //Apply a single damage hit for each missile instead of as a single mass
    for (nCnt = 1; nCnt <= nMissiles; nCnt++){
        nDamage = MetaPower(si, dice, 6, 1, fb.dmg);
        nDamage = GetReflexAdjustedDamage(nDamage, si.target, si.dc, SAVING_THROW_TYPE_FIRE);

        fTime = fDelay;
        fDelay2 += 0.1;
        fTime += fDelay2;

        //Set damage effect
        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);

        //Apply the MIRV and damage effect
        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
        DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, si.target));
     }
}
