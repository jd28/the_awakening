//::///////////////////////////////////////////////
//:: Undeath to Death
//:: X2_S0_Undeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

  This spell slays 1d4 HD worth of undead creatures
  per caster level (maximum 20d4). Creatures with
  the fewest HD are affected first;

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On:  August 13,2003
//:://////////////////////////////////////////////

// No longer considers lowest target

#include "gsp_func_inc"
#include "x2_inc_toollib"

void DoUndeadToDeath(struct SpellInfo si, object oTarget){

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
    SetLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD", TRUE);

    if (!GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_NONE)){
        float fDelay = GetRandomDelay(0.2f,0.4f);
        if (!GetSpellResisted(si, oTarget, fDelay)){
            effect eDeath = EffectDamage(GetCurrentHitPoints(oTarget),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay+0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget));
            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
       }
       else{
            DelayCommand(1.0f,DeleteLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD"));
       }
    }
    else{
        DelayCommand(1.0f,DeleteLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD"));
    }
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_STRIKE_HOLY), si.loc);
    TLVFXPillar(VFX_FNF_LOS_HOLY_20, si.loc, 3);

    int sides = 4;
    int cap = 40;
    
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, si.caster)){
        cap = 60;
        sides = 6;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, si.caster)){
        cap = 50;
        sides = 6;
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, si.caster)){
        sides = 6;
    }

    if (si.clevel > cap)
        si.clevel = cap;

    // calculate number of hitdice affected
    int nHDLeft = MetaPower(si, si.clevel, sides, 0, 0);

    int nCurHD;

    // Only start loop if there is a creature in the area of effect
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc );
    while (oTarget != OBJECT_INVALID && nHDLeft > 0){
        if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ||
            GetLevelByClass(CLASS_TYPE_PALE_MASTER, oTarget)){
            nCurHD = GetHitDice(oTarget);
            if (nCurHD <= nHDLeft){
                if(GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE)){
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));

                    if (!GetSpellSaved(si, SAVING_THROW_WILL, oTarget, SAVING_THROW_TYPE_NONE)){
                        float fDelay = GetRandomDelay(0.2f,0.4f);
                        if (!GetSpellResisted(si, oTarget, fDelay)){
                            effect eDeath = EffectDamage(GetCurrentHitPoints(oTarget),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
                            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
                            DelayCommand(fDelay+0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget));
                            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                    nHDLeft -= GetHitDice(oTarget);
                }
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
    }
}
