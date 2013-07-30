//::///////////////////////////////////////////////
//:: War Cry
//:: NW_S0_WarCry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The bard lets out a terrible shout that gives
    him a +2 bonus to attack and damage and causes
    fear in all enemies that hear the cry
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
    effect eFear = EffectFrightened();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eVisFear = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eLOS;
    int bWemic;
    float fDuration;

    if(GetGender(OBJECT_SELF) == GENDER_FEMALE)
    {
        eLOS = EffectVisualEffect(290);
    }
    else
    {
        eLOS = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    }

    if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_015"){
        bWemic = TRUE;
        si.clevel = GetLevelIncludingLL(si.caster);
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eDur2);

    effect eLink2 = EffectLinkEffects(eVisFear, eFear);
    eLink = EffectLinkEffects(eLink, eDur);

    fDuration = MetaDuration(si, si.clevel);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
    //Determine enemies in the radius around the bard
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY));
           //Make SR and Will saves
           if(!MyResistSpell(OBJECT_SELF, oTarget)  && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
            {
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(4)));
            }

            if(bWemic){
                effect eDam1 = EffectDamage(d6(si.clevel / 2), DAMAGE_TYPE_SONIC);
                effect eDam2 = EffectDamage(d6(si.clevel / 2), DAMAGE_TYPE_DIVINE);

                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget));
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                DelayCommand(0.01, ApplyVisualToObject(VFX_IMP_SONIC, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    //Apply bonus and VFX effects to bard.
    RemoveSpellEffects(GetSpellId(),OBJECT_SELF, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration));
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY, FALSE));
}
