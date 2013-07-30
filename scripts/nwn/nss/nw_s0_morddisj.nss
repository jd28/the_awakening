//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Massive Dispel Magic and Spell Breach rolled into one
    If the target is a general area of effect they lose
    6 spell protections.  If it is an area of effect everyone
    in the area loses 2 spells protections.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated On: Oct 20, 2003, Georg Zoeller
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main () {

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect   eVis        = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect   eImpact     = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
    object   oTarget     = GetSpellTargetObject();
    location lLocal      = GetSpellTargetLocation();
    int      nCasterLevel= GetCasterLevel(OBJECT_SELF);


    //--------------------------------------------------------------------------
    // Mord's is not capped anymore as we can go past level 20 now
    //--------------------------------------------------------------------------
    /*
        if(nCasterLevel > 20)
        {
            nCasterLevel = 20;
        }
    */

    if (GetIsObjectValid(oTarget))
    {
        //----------------------------------------------------------------------
        // Targeted Dispel - Dispel all
        //----------------------------------------------------------------------
        spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact,TRUE,TRUE);
    }
    else
    {
        //----------------------------------------------------------------------
        // Area of Effect - Only dispel best effect
        //----------------------------------------------------------------------

        //Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, si.loc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);

            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, si.loc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
    }
}

