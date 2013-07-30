//::///////////////////////////////////////////////
//:: Great Thunderclap
//:: X2_S0_GrtThdclp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a loud noise equivalent to a peal of
// thunder and its acommpanying shock wave. The
// spell has three effects. First, all creatures
// in the area must make Will saves to avoid being
// stunned for 1 round. Second, the creatures must
// make Fortitude saves or be deafened for 1 minute.
// Third, they must make Reflex saves or fall prone.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 20, 2002
//:: Updated On: Oct 20, 2003 - some nice Vfx:)
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nDamage = 0, nMask = OBJECT_TYPE_CREATURE;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
    effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
    effect eDeaf = EffectDeaf(), eKnock = EffectKnockdown(), eStun = EffectStunned();
    effect eShake = EffectVisualEffect(356);
    effect eDmg;

    struct FocusBonus fb;
    int nDamDice;
    int nDamType = DAMAGE_TYPE_SONIC;
    int nDamSides = 8;
    int is_sub = FALSE;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, si.loc);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, si.caster, 2.0f);

    if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_009"){
        nDamDice = GetLevelIncludingLL(si.caster);
        nDamType = DAMAGE_TYPE_BLUDGEONING;
        is_sub = TRUE;
    }
    else{
        nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;
        fb = GetOffensiveFocusBonus(si.caster, si.school, 50);
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, si.loc, TRUE, nMask);
    while (GetIsObjectValid(oTarget)){
        if(GetIsSpellTarget(si, oTarget) && oTarget != OBJECT_SELF){
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(oTarget))/20;

            if(!GetSpellSaved(si, SAVING_THROW_FORT, oTarget, SAVING_THROW_TYPE_SONIC)){
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(10)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
            if(!GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_SONIC)){
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if(!GetSpellSaved(si, SAVING_THROW_REFLEX, oTarget, SAVING_THROW_TYPE_SONIC)){
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oTarget,4.0f));
                if(!is_sub){
                    nDamage = MetaPower(si, nDamDice, nDamSides, 0, fb.dmg);
                    eDmg = EffectDamage(nDamage, nDamType);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
                }
            }
            if(is_sub){
                eDmg = EffectDamage(d12(nDamDice), nDamType);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, si.loc, TRUE, nMask);
    }
}

