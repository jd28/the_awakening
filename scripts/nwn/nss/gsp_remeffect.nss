//::///////////////////////////////////////////////
//:: Remove Effects
//:: NW_SO_RemEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Takes the place of
        Remove Disease
        Neutralize Poison
        Remove Paralysis
        Remove Curse
        Remove Blindness / Deafness
        Remove Fear
        Remove Paralysis
        Stone to Flesh
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nEffect1, nEffect2, nEffect3;
    int bAreaOfEffect = FALSE;
    effect eLink, eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    float fDelay, fDuration, fRadius;

    //Check for which removal spell is being cast.
    if(si.id == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS){
        fRadius = RADIUS_SIZE_MEDIUM;
        nEffect1 = EFFECT_TYPE_BLINDNESS;
        nEffect2 = EFFECT_TYPE_DEAF;
        ApplyVisualAtLocation(VFX_FNF_LOS_HOLY_30, si.loc);
        bAreaOfEffect = TRUE;
    }
    else if(si.id == SPELL_REMOVE_CURSE)
    {
        nEffect1 = EFFECT_TYPE_CURSE;
    }
    else if(si.id == SPELL_REMOVE_DISEASE || si.id == SPELLABILITY_REMOVE_DISEASE)
    {
        nEffect1 = EFFECT_TYPE_DISEASE;
        nEffect2 = EFFECT_TYPE_ABILITY_DECREASE;
    }
    else if(si.id == SPELL_REMOVE_FEAR){
        fDuration = MetaDuration(si, si.clevel);
        fRadius = RADIUS_SIZE_MEDIUM;
        nEffect1 = EFFECT_TYPE_FRIGHTENED;
        eLink = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE));
        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        bAreaOfEffect = TRUE;
        ApplyVisualAtLocation(VFX_FNF_LOS_HOLY_30, si.loc);
    }
    else if(si.id == SPELL_REMOVE_PARALYSIS){
        fRadius = RADIUS_SIZE_LARGE;
        nEffect1 = EFFECT_TYPE_PARALYZE;
        bAreaOfEffect = TRUE;
        ApplyVisualAtLocation(VFX_FNF_LOS_HOLY_20, si.loc);
    }
    else if(si.id == SPELL_NEUTRALIZE_POISON){
        nEffect1 = EFFECT_TYPE_POISON;
        nEffect2 = EFFECT_TYPE_DISEASE;
        nEffect3 = EFFECT_TYPE_ABILITY_DECREASE;
    }
    else if(si.id == SPELL_STONE_TO_FLESH){
        // Don't unpetrify a statue.
        if (GetLocalInt(si.target, "NW_STATUE") == 1) return;
        nEffect1 = EFFECT_TYPE_PETRIFY;
    }

    if(!bAreaOfEffect){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Remove effects
        RemoveSpecificEffect(nEffect1, si.target);
        if(nEffect2 != 0) RemoveSpecificEffect(nEffect2, si.target);
        if(nEffect3 != 0) RemoveSpecificEffect(nEffect3, si.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
    }
    else{
        //Get first target in the spell area
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc);
        while (GetIsObjectValid(oTarget)){
            // Only remove effects from friends.
            if(GetIsFriend(oTarget)){
                fDelay = GetRandomDelay();
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));

                //Remove effects
                RemoveSpecificEffect(nEffect1, si.target);
                if(nEffect2 != 0) RemoveSpecificEffect(nEffect2, si.target);
                if(nEffect3 != 0) RemoveSpecificEffect(nEffect3, si.target);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);

                //Apply the linked effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
            //Get the next target in the spell area.
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc);
        }
    }
}


