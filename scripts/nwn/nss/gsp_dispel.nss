////////////////////////////////////////////////////////////////////////////////
// gsp_dispel
//
// Spells: Lesser, Greater, Dispel Magic, Mord's Disjunction; Lesser & Greater
//         Spell Breach
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main () {
    object    oTarget      = GetSpellTargetObject();
    location  lLocal       = GetSpellTargetLocation();

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDelay, fRadius = RADIUS_SIZE_LARGE;
    int bStorm = TRUE, bBreach = FALSE, nLevel, nShape = SHAPE_SPHERE;
    int nMask = OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE;
    effect eVis, eImpact;

    si.target = GetSpellTargetObject();
    si.loc = GetSpellTargetLocation();

    // Handle Breaches
    if(si.id == SPELL_LESSER_SPELL_BREACH || SPELL_GREATER_SPELL_BREACH){
        if(si.id == SPELL_LESSER_SPELL_BREACH)
            DoSpellBreach(si.target, 3, 5, si.id);
        else
            DoSpellBreach(si.target, 6, 10);

        return;
    }

    // Handle Dispels
    switch (si.id) {
        case TASPELL_HARPER_MIELIKKIS_TRUTH:
        case SPELL_LESSER_DISPEL:
            eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
            eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
            nLevel = (si.clevel > 10) ? 10 : si.clevel;
        break;
        case SPELL_DISPEL_MAGIC:
            eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
            eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
            nLevel = (si.clevel > 15) ? 15 : si.clevel;
        break;
        case SPELL_GREATER_DISPELLING:
            eVis = EffectVisualEffect( VFX_IMP_BREACH );
            eImpact = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );
            nLevel = (si.clevel > 20) ? 20 : si.clevel;
        break;
        case SPELL_MORDENKAINENS_DISJUNCTION:
            eImpact = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
            eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
            bBreach = TRUE;
            nLevel = si.clevel;
        break;
    }

    if (GetIsObjectValid(oTarget)){
        spellsDispelMagic(oTarget, nLevel, eVis, eImpact, TRUE, bBreach);
    }
    else{
        //SendMessageToPC(si.caster, "Invalid Object");
        //Apply the VFX impact and effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLocal);
        oTarget = GetFirstObjectInShape(nShape, fRadius, lLocal, !bStorm, nMask);
        while (GetIsObjectValid(oTarget)){
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT){
                spellsDispelAoE(oTarget, si.caster, nLevel);
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE){
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else{
                spellsDispelMagic(oTarget, nLevel, eVis, eImpact, FALSE, bBreach);
            }

            oTarget = GetNextObjectInShape(nShape, fRadius, lLocal, !bStorm, nMask);
        }
    }
}
