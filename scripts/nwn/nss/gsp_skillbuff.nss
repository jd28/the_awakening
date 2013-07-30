////////////////////////////////////////////////////////////////////////////////
// gsp_skillbuff
//
// Spells:
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nShape = SHAPE_SPHERE, nBonus, nSkill1 = -1, nSkill2 = -1, nSkill3 = -1, nSkill4 = -1;
    int bSingleTarget = TRUE;
    float fDuration, fRadius = RADIUS_SIZE_COLOSSAL, fDelay;
    effect eVis, eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eLink, eSkill1, eSkill2,
        eSkill3, eSkill4;

    switch(si.id){
        case SPELL_MASS_CAMOFLAGE:
            bSingleTarget = FALSE;
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);
        case SPELL_CAMOFLAGE:
            nSkill1 = SKILL_HIDE;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_ROUNDS);
            eSkill1 = EffectSkillIncrease(SKILL_HIDE, 10);
            if(si.id == SPELL_MASS_CAMOFLAGE){
                eSkill2 = EffectConcealment(20);
            }
            else{
                eSkill2 = EffectConcealment(40);
            }
            eSkill1 = EffectLinkEffects(eSkill2, eSkill1);
            eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        break;
        case SPELL_IDENTIFY:
        case SPELL_LEGEND_LORE:
            // Don't allow stacking.
            if(GetHasSpellEffect(SPELL_IDENTIFY, OBJECT_SELF) || GetHasSpellEffect(SPELL_LEGEND_LORE, OBJECT_SELF))
                return;
            nSkill1 = SKILL_LORE;
            if(si.id == SPELL_IDENTIFY){
                nBonus = 10 + si.clevel;
                fDuration = MetaDuration(si, 2);
            }
            else{
                fDuration = MetaDuration(si, si.clevel);
                nBonus = 10 + (si.clevel / 2);
            }
            eSkill1 = EffectSkillIncrease(nSkill1, nBonus);
            eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        break;
        case SPELL_AMPLIFY:
            fDuration = MetaDuration(si, si.clevel);
            nSkill1 = SKILL_LISTEN;
            eSkill1 = EffectSkillIncrease(nSkill1, 20);
            eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        break;
        case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE:
            // No stacking
            if(GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, si.target))
                return;

            fDuration = MetaDuration(si, si.clevel);
            nSkill1 = SKILL_LISTEN;
            eSkill1 = EffectSkillIncrease(nSkill1, 10);
            nSkill2 = SKILL_SPOT;
            eSkill2 = EffectSkillIncrease(nSkill2, 10);
            eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
        break;
        case SPELL_ONE_WITH_THE_LAND:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_ROUNDS);
            nSkill1 = 1;
            eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
            eSkill1 = EffectSanctuary(si.dc);

        break;
        // TODO Cleric Domains
    }

    eLink = eDur;

    if(nSkill1 > 0)
        eLink = EffectLinkEffects(eLink, eSkill1);
    if(nSkill2 > 0)
        eLink = EffectLinkEffects(eLink, eSkill2);
    if(nSkill3 > 0)
        eLink = EffectLinkEffects(eLink, eSkill3);
    if(nSkill4 > 0)
        eLink = EffectLinkEffects(eLink, eSkill4);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, GetLocation(si.caster));
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                //Fire spell cast at event for target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
                //Apply VFX impact and bonus effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, GetLocation(si.caster));
        }
    }
}
