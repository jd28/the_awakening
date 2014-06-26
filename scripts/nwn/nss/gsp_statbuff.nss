////////////////////////////////////////////////////////////////////////////////
// gsp_statbuf
//
// Spells: Bull Strength, Endurance, Cat's Grace, Owl's Wisdom, Eagle's Splendor,
//         Fox's Cunning, the "Greater" versions of those spells, and Owl's Insight
//
// Notes: Updated to TA2
//
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDuration, fDelay;
    int nAbility, nBuffDice = 1, nBuffSides = 4, nAmount, bSingleTarget = TRUE, bExtra = FALSE;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE),
           eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eBuff;

    if(GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION))
        nBuffDice = 2;

    if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION))
        bExtra = TRUE;

    if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION)){
        bSingleTarget = FALSE;
        // TODO Some impact script
    }

    switch(si.id){
        case SPELLABILITY_BG_BULLS_STRENGTH:
            nAbility = ABILITY_STRENGTH;
            nAmount = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF) / 6;
            eDur = EffectLinkEffects(eDur, EffectAttackIncrease(nAmount));
        break;
        case SPELL_BULLS_STRENGTH:
        case SPELL_GREATER_BULLS_STRENGTH:
            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_009"){
                si.clevel = GetLevelIncludingLL(si.caster);
                nAmount = si.clevel / 10;
                eDur = EffectLinkEffects(eDur, EffectAttackIncrease(nAmount));
            }
            nAbility = ABILITY_STRENGTH;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_SLASHING));
        break;
        case SPELL_CATS_GRACE:
        case SPELL_GREATER_CATS_GRACE:
            nAbility = ABILITY_DEXTERITY;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2));
        break;
        case SPELL_EAGLE_SPLEDOR:
        case SPELL_GREATER_EAGLE_SPLENDOR:
            nAbility = ABILITY_CHARISMA;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectAttackIncrease(2));
        break;
        case SPELL_ENDURANCE:
        case SPELL_GREATER_ENDURANCE:
            nAbility = ABILITY_CONSTITUTION;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_FORT, 2));
        break;
        case SPELL_FOXS_CUNNING:
        case SPELL_GREATER_FOXS_CUNNING:
            nAbility = ABILITY_INTELLIGENCE;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
        break;
        case SPELL_OWLS_WISDOM:
        case SPELL_GREATER_OWLS_WISDOM:
        case SPELL_OWLS_INSIGHT:
            nAbility = ABILITY_WISDOM;
            if(bExtra)
                eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_WILL, 2));
        break;
    }

    // Stacking code according to original script is handled by engine.

    if(si.id == SPELL_OWLS_INSIGHT) nAmount = si.clevel / 2;
    else nAmount = MetaPower(si, nBuffDice, nBuffSides, 1, 0);

    eBuff = EffectAbilityIncrease(nAbility, nAmount);
    effect eLink = EffectLinkEffects(eBuff, eDur);

    fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Ability Buff: Ability: " + IntToString(nAbility) +
            ", Roll: " + IntToString(nBuffDice) + "d" + IntToString(nBuffSides) +
            "+ 1, Result: " + IntToString(nAmount);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
		GZRemoveSpellEffects(si.id, si.target);

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
        DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration));

    }
    else{
        //Get the first target in the radius around the caster
        for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
            si.target != OBJECT_INVALID;
            si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc)){

            if(!GetIsReactionTypeFriendly(si.target) && !GetFactionEqual(si.target))
                continue;

			GZRemoveSpellEffects(si.id, si.target);

            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
            //Apply VFX impact and bonus effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration));
        }
    }
}
