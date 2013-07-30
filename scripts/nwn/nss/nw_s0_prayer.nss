//::///////////////////////////////////////////////
//:: Prayer
//:: NW_S0_Prayer.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allies gain +1 Attack, damage, saves, skill checks
    Enemies gain -1 to these stats
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    float fDuration = MetaDuration(si, si.clevel);

    effect ePosVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eNegVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    int nBonus = 2;
    effect eBonAttack = EffectAttackIncrease(nBonus);
    effect eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eBonDam = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
    effect eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
    effect ePosDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
    ePosLink = EffectLinkEffects(ePosLink, eBonDam);
    ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
    ePosLink = EffectLinkEffects(ePosLink, ePosDur);

    effect eNegAttack = EffectAttackDecrease(nBonus);
    effect eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nBonus);
    effect eNegDam = EffectDamageDecrease(nBonus, DAMAGE_TYPE_SLASHING);
    effect eNegSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nBonus);
    effect eNegDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eNegLink = EffectLinkEffects(eNegAttack, eNegSave);
    eNegLink = EffectLinkEffects(eNegLink, eNegDam);
    eNegLink = EffectLinkEffects(eNegLink, eNegSkill);
    eNegLink = EffectLinkEffects(eNegLink, eNegDur);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);

    //Get the first target in the radius around the caster
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
    while(GetIsObjectValid(oTarget)){
        if(GetIsFriend(oTarget)){
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
            //Apply VFX impact and bonus effects
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePosVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePosLink, oTarget, fDuration);
        }
        else if (GetIsSpellTarget(si, si.target, TARGET_TYPE_STANDARD)){
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, SPELL_PRAYER));
            if(!GetSpellResisted(si, oTarget)){
                //Apply VFX impact and negative effects
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eNegVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegLink, oTarget, fDuration);
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
    }
}


