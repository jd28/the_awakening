//::///////////////////////////////////////////////
//:: Weird
//:: nw_s0_Weird
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All enemies in LOS of the spell must make 2 saves or die.
    Even IF the fortitude save is succesful, they will still take
    3d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: DEc 14 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 27, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
    effect eWeird = EffectVisualEffect(VFX_FNF_WEIRD);
    effect eAbyss = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
    int nDamage, bImm, nDamDice;
    float fDelay;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 60);
    nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWeird, si.loc);

    for (si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc, TRUE);
         GetIsObjectValid(si.target);
         si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc, TRUE)) {

        if (!GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE))
            continue;

        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

        fDelay = GetRandomDelay(3.0, 4.0);

        if (!GetSpellResisted(si, si.target, fDelay) &&
            (!bImm || !GetHasSpellImmunity(si.id, si.target))) {

            //Roll damage
            nDamage = MetaPower(si, nDamDice, 10, 0, fb.dmg);

            //Make a Will save against mind-affecting
            if(GetSpellSaved(si, SAVING_THROW_WILL, si.target, SAVING_THROW_TYPE_MIND_SPELLS, fDelay)){
                nDamage /= 2;
            }
            else{ // Failed will
                if(!GetSpellSaved(si, SAVING_THROW_FORT, si.target, SAVING_THROW_TYPE_DEATH, fDelay))
                { // We die.
                    effect eDeath = EffectDeath();
                    // Need to make this supernatural, so that it ignores death immunity.
                    //if(!GetLocalInt(si.target, "Boss") && d100() > 75){
                    //    eDeath = SupernaturalEffect( eDeath );
                    //}
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, si.target));
                }
            }

            //Set damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
            //Apply VFX Impact and damage effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
        }
    }
}
