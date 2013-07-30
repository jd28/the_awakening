////////////////////////////////////////////////////////////////////////////////
// gsp_defbuff
//
// Spells: Resistence, Virtue
//
// TODO: Fix bonus hit points.  Add debuging. Aura of glory, Shadow Evade,
//       Fix damage reduction power, add Shield
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

effect GetASImprovedInvisEffect();
effect GetEmptyBodyEffect(struct SpellInfo si);

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nShape = SHAPE_SPHERE;
    int nSaveBonus, nHPBonus, nDamRed, nDamRedPower, nDamRedLimit, nSpellAbsorb, nSpellAbsorbMax,
        nSpellAbsorbSchool = SPELL_SCHOOL_GENERAL, nConceal, nSpellImm, nDamImm, nDamImmType, nRegen, nSR;
    int nACNatural, nACDodge, nACDeflect, nACArmor;
    int bInvis, nInvisType = INVISIBILITY_TYPE_NORMAL, bDeathImm, bExtraordinary = FALSE, bSupernatural = FALSE, bSingleTarget = TRUE;
    float fDuration, fRadius = RADIUS_SIZE_COLOSSAL, fDelay;
    effect eImpact, eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eLink;

    int nVis;
    object oTemp;
    int bRemove = TRUE;
    struct FocusBonus fb;

    switch(si.id){
        // Spells
        case SPELL_BARKSKIN:
            nACNatural = (si.clevel / 6) + 1;
            fDuration = MetaDuration(si, si.clevel * 2, DURATION_IN_HOURS);

            eImpact = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
        break;
        case SPELL_DEATH_WARD:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_DEATH));
            eImpact = EffectVisualEffect(VFX_IMP_DEATH_WARD);
        break;
        case SPELL_DISPLACEMENT:
            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_007"){
                si.clevel = GetLevelIncludingLL(si.caster);
                nConceal = 10 + GetSkillRank(SKILL_HIDE, si.caster, TRUE);
                if(nConceal > 50)
                    nConceal = 50;
            }
            else{
                nConceal = 50;
            }
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_INVISIBILITY));
            fDuration = MetaDuration(si, si.clevel);
        break;
        case SPELL_ENTROPIC_SHIELD: //Special Case
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eDur = EffectLinkEffects(eDur, EffectConcealment(40, MISS_CHANCE_TYPE_VS_RANGED));
        break;
        case SPELL_ETHEREAL_VISAGE:
            fDuration = MetaDuration(si, si.clevel);
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE));
            nSpellAbsorb = 3;
            nDamRed = 15;

            if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, si.caster))
                nDamRed += 5;

            nDamRedPower = (si.clevel / 5)+1;
            nDamRedPower = clamp(nDamRedPower, 3, GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, si.caster) ? 8 : 7);
            nDamRedPower = GetDamagePower(nDamRedPower);

            nConceal = 25;
        break;
        case SPELLABILITY_AS_GHOSTLY_VISAGE:
            fDuration = MetaDuration(si, si.clevel * 2);
            if(GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF) > 10){
                eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE));
                nSpellAbsorb = 3;
                nDamRed = 15;
                nDamRedPower = (si.clevel / 6)+1;
                if(nDamRedPower < 3) nDamRedPower = 3;
                if(nDamRedPower > 7) nDamRedPower = 7;
                nDamRedPower = GetDamagePower(nDamRedPower);
                nConceal = 25;
            }
            else{
                eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
                nSpellAbsorb = 2;
                nDamRed = 10;
                nDamRedPower = (si.clevel / 6)+1;
                if(nDamRedPower < 3) nDamRedPower = 3;
                if(nDamRedPower > 7) nDamRedPower = 7;
                nDamRedPower = GetDamagePower(nDamRedPower);
                nConceal = 10;
            }
        break;
        case SPELL_GHOSTLY_VISAGE:
        case 351: // Greater Shadow Conjuration
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nSpellAbsorb = 2;
            nDamRed = 10;
            nDamRedPower = (si.clevel / 6)+1;
            if(nDamRedPower < 3) nDamRedPower = 3;
            if(nDamRedPower > 7) nDamRedPower = 7;
            nDamRedPower = GetDamagePower(nDamRedPower);
            nConceal = 10;
        break;
        case SPELLABILITY_AS_IMPROVED_INVISIBLITY:
            // No stacking
            RemoveEffectsFromSpell(OBJECT_SELF, si.id);
            si.target = si.caster;

            fDuration = MetaDuration(si, si.clevel * 2, DURATION_IN_ROUNDS);
            eDur = EffectLinkEffects(eDur, ExtraordinaryEffect(GetASImprovedInvisEffect()));
            bInvis = TRUE;
            //nInvisType = INVISIBILITY_TYPE_IMPROVED;
        break;
        case SPELL_INVISIBILITY_SPHERE:
            fRadius = RADIUS_SIZE_LARGE;
            bSingleTarget = FALSE;
            //TODO: Need Impact
        case SPELL_INVISIBILITY: // Special Case.
        case SPELLABILITY_AS_INVISIBILITY:
        case SPELL_IMPROVED_INVISIBILITY:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            bInvis = TRUE;
            //eImpact = EffectVisualEffect(VFX_DUR_INVISIBILITY);

            if(si.id == SPELL_IMPROVED_INVISIBILITY){
                ApplyVisualToObject(VFX_IMP_HEAD_MIND, si.target);
                nConceal = 50;
            }
        break;
        case SPELL_MAGE_ARMOR:
        case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:
            // prevent stacking with self
            RemoveEffectsFromSpell(si.caster, si.id);
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
            nACNatural = 1;
            nACDodge = 1;
            nACDeflect = 1;
            nACArmor = 1;
            eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);
        break;
        case SPELL_MONSTROUS_REGENERATION:
            RemoveEffectsFromSpell(si.caster, si.id);
            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_017"){
                si.clevel = GetLevelIncludingLL(si.caster);
                nRegen = (si.clevel / 10) * 5;
                if(nRegen <= 0) nRegen = 5;
                else if(nRegen > 30) nRegen = 30;

                eDur = EffectLinkEffects(eDur, EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, 5));
                eDur = EffectLinkEffects(eDur, EffectDamageImmunityDecrease(DAMAGE_TYPE_ELECTRICAL, 5));
            }else{
                nRegen = 6;
            }

            fDuration = MetaDuration(si, (si.clevel / 2) + 1);

            eImpact = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        break;
        case SPELL_NEGATIVE_ENERGY_PROTECTION:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nDamImm = 100;
            nDamImmType = DAMAGE_TYPE_NEGATIVE;
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
        break;
        case SPELL_REGENERATE:
            RemoveEffectsFromSpell(si.caster, si.id);
            fDuration = MetaDuration(si, 5);
            nRegen = si.clevel * 4;
            if(GetHasFeat(FEAT_HEALING_DOMAIN_POWER, si.caster))
                nRegen += 20;
            eImpact = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        break;
        case SPELL_RESISTANCE:
            nSaveBonus = 1;
            fDuration = MetaDuration(si, si.clevel);
            ApplyVisualToObject(VFX_IMP_HEAD_HOLY, si.target); // Impact
        break;
        case SPELL_SHADOW_SHIELD:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nACNatural = (si.clevel / 6) + 1;
            nDamImm = 100;
            nDamImmType = DAMAGE_TYPE_NEGATIVE;
            nDamRed = 10;
            nDamRedPower = (si.clevel / 6)+1;
            if(nDamRedPower < 3) nDamRedPower = 3;
            if(nDamRedPower > 7) nDamRedPower = 7;
            nDamRedPower = GetDamagePower(nDamRedPower);
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_DEATH));

            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
            eImpact = EffectVisualEffect(VFX_IMP_DEATH_WARD);
        break;
        case SPELL_SHIELD_OF_FAITH:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nACDeflect = (si.clevel / 6) + 1;
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
            eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);
        break;
        case SPELL_SPELL_RESISTANCE:
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nSR = 12 + si.clevel;

            eDur = EffectLinkEffects(eDur, EffectVisualEffect(249));
            eImpact = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        break;
        case SPELL_UNDEATHS_ETERNAL_FOE:
            nDamImm = 100;
            nDamImmType = DAMAGE_TYPE_NEGATIVE;

            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_POISON));
            eDur = EffectLinkEffects(eDur, EffectImmunity(IMMUNITY_TYPE_DISEASE));

            eImpact = EffectVisualEffect(VFX_IMP_HOLY_AID);

            bSingleTarget = FALSE;
            fRadius = RADIUS_SIZE_MEDIUM;
            fDuration = MetaDuration(si, si.clevel);
            //Apply Area Impact
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);
        break;
        case SPELL_VIRTUE:
            RemoveTempHitPoints();
            nHPBonus = MetaPower(si, 1, 4, si.clevel, 0);
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            ApplyVisualToObject(VFX_IMP_HOLY_AID, si.target); // Impact
        break;

        // Feats
        case SPELLABILITY_EMPTY_BODY:
            // Return if already under the effect.
            if(GetHasFeatEffect(FEAT_EMPTY_BODY)) return;
            bRemove = FALSE;
            bExtraordinary = TRUE;
            fDuration = RoundsToSeconds(GetLevelByClass(CLASS_TYPE_MONK) * 2);
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_INVISIBILITY));
            eDur = EffectLinkEffects(eDur, GetEmptyBodyEffect(si));
        break;

        case 807: // Heroic Shield
            eImpact = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            bSingleTarget = FALSE;
            fDuration = RoundsToSeconds(si.clevel/2);
            nACDodge = si.clevel / 5;
            if(nACDodge == 0) nACDodge = 1;
        break;
        case TASPELL_PDK_VIRTUE:
            eImpact = EffectVisualEffect(VFX_IMP_PDK_HEROIC_SHIELD);
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            eImpact = EffectVisualEffect(VFX_IMP_DESTRUCTION);
            fDuration = RoundsToSeconds(20);
            bExtraordinary = TRUE;
            bSingleTarget = FALSE;

            if(GetAbilityScore(si.caster, ABILITY_STRENGTH, TRUE) >= 40)
                eDur = EffectLinkEffects(eDur, EffectDamageIncrease(DAMAGE_BONUS_2d12, DAMAGE_TYPE_SONIC));

            if(GetAbilityScore(si.caster, ABILITY_DEXTERITY, TRUE) >= 40)
                eDur = EffectLinkEffects(eDur, EffectConcealment(60));

            if(GetAbilityScore(si.caster, ABILITY_CONSTITUTION, TRUE) >= 40){
                eDur = EffectLinkEffects(eDur, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5));
                eDur = EffectLinkEffects(eDur, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5));
                eDur = EffectLinkEffects(eDur, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5));
            }
            
            if(GetAbilityScore(si.caster, ABILITY_WISDOM, TRUE) >= 40){
                eDur = EffectLinkEffects(eDur, EffectSavingThrowIncrease(SAVING_THROW_ALL, 12));
            }

            if(GetAbilityScore(si.caster, ABILITY_INTELLIGENCE, TRUE) >= 40){
                eDur = EffectLinkEffects(eDur, EffectACIncrease(12, AC_ARMOUR_ENCHANTMENT_BONUS));
            }

            if(GetAbilityScore(si.caster, ABILITY_CHARISMA, TRUE) >= 40){
                eDur = EffectLinkEffects(eDur, EffectAttackIncrease(5));
            }
        break;
        case 806: // rallying
            ApplyVisualAtLocation(VFX_IMP_PDK_GENERIC_PULSE, si.loc);

            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            fRadius = 20.0f;
            bSingleTarget = FALSE;
            fDuration = MetaDuration(si, si.clevel);
            nSR = si.clevel / 2;

            if(nSR <= 0)      nSR = 1;
            else if(nSR > 20) nSR = 20;

            eDur = EffectLinkEffects(eDur, EffectVisualEffect(249));
            eImpact = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        break;
    }

    eLink = eDur;

    if(nSaveBonus > 0)
        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus));

    if(nACNatural > 0)
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nACNatural, AC_NATURAL_BONUS));

    if(nACDodge > 0)
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nACDodge, AC_DODGE_BONUS));

    if(nACDeflect > 0)
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nACDeflect, AC_DEFLECTION_BONUS));

    if(nACArmor > 0)
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nACArmor, AC_ARMOUR_ENCHANTMENT_BONUS));

    if(nDamRed > 0)
        eLink = EffectLinkEffects(eLink, EffectDamageReduction(nDamRed, nDamRedPower, nDamRedLimit));

    if(nConceal > 0)
        eLink = EffectLinkEffects(eLink, EffectConcealment(nConceal));

    if(nSpellAbsorb > 0)
        eLink = EffectLinkEffects(eLink, EffectSpellLevelAbsorption(nSpellAbsorb, nSpellAbsorbMax, nSpellAbsorbSchool));

    if(nDamImm > 0)
        eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(nDamImmType, nDamImm));

    if(nSpellImm > 0)
        eLink = EffectLinkEffects(eLink, EffectSpellImmunity(nSpellImm));

    if(nRegen > 0)
        eLink = EffectLinkEffects(eLink, EffectRegenerate(nRegen, 6.0f));

    if(nSR > 0)
        eLink = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(nSR));

    if(bExtraordinary)
        eLink = ExtraordinaryEffect(eLink);

    if(bSupernatural)
        eLink = SupernaturalEffect(eLink);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        if(bRemove)
            RemoveEffectsOfSpells(si.target, si.id);

        if(bInvis)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(nInvisType), si.target, fDuration);

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
        if(nHPBonus > 0) // Most not be linked but applied seperately!!!
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPBonus), si.target, fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, si.loc);
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
                //Apply VFX impact and bonus effects
                RemoveEffectsOfSpells(oTarget, si.id);

                if(bInvis)
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(nInvisType), si.target, fDuration);

                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                if(nHPBonus > 0) // Most not be linked but applied seperately!!!
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPBonus), si.target, fDuration));

            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, si.loc);
        }
    }
}

effect GetASImprovedInvisEffect(){
    effect eLink;
    int nLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);

    // +1 concealment per hide skill over 20
    int nConceal = 20, nCap;
    int nHide = GetSkillRank(SKILL_MOVE_SILENTLY, OBJECT_SELF, TRUE) - 20;
    if(nHide < 0) nHide = 0;
    if(nHide > 40) nHide = 40;
    nConceal += nHide;

    if(nLevel >= 20) nCap = 60;
    else if(nLevel >= 15) nCap = 50;
    else nCap = 40;

    if(nConceal > nCap)
        nConceal = nCap;

    eLink = EffectConcealment(nConceal);

    // +1 AC per 5 levels above 5th.
    int nAC = (nLevel - 5) / 5;
    if(nAC > 10) nAC = 10;
    if(nAC > 0)
        eLink = EffectLinkEffects(eLink, EffectACIncrease(nAC));

    return eLink;
}

effect GetEmptyBodyEffect(struct SpellInfo si){
    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_MONK, si.caster);
    int nDuration = nLevel * 2;

    effect eLink;

    // +1 concealment per hide skill over 20
    int nConceal = 20, nCap;
    int nHide = GetSkillRank(SKILL_CONCENTRATION, si.caster, TRUE) - 20;
    if(nHide < 0) nHide = 0;
    if(nHide > 40) nHide = 40;
    nConceal += nHide;

    if(nLevel >= 20) nCap = 60;
    else if(nLevel >= 15) nCap = 50;
    else nCap = 40;

    if(nConceal > nCap)
        nConceal = nCap;

    eLink = EffectConcealment(nConceal);

    // Immune to 1 level of spells per 5 above 20.
    int nSpellLevel = (nLevel - 20) / 5;
    if(nSpellLevel > 0){
        eLink = EffectLinkEffects(eLink, EffectSpellLevelAbsorption(nSpellLevel));
        //eLink = EffectLinkEffects(eLink, EffectACIncrease(nSpellLevel));
    }
    // Grants damage reduction with a power of +5 plus 1 per 6 SD levels, an amount of
    // +1 per SD level, and collapses after 5 * base lore skill points of melee damage.
    int nDRAmount = (nLevel - 20) / 2;
    int nDRMax = 5 * GetSkillRank(SKILL_LORE, si.caster, TRUE);
    int nDRPower = IPGetDamagePowerConstantFromNumber(5 + (nDRAmount / 4));

    if(nDRAmount > 0){
        // DR Effects, not in Link
        effect eDR = EffectDamageReduction(nDRAmount, nDRPower, nDRMax);
        effect eVis3 = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
        effect eLink2 = EffectLinkEffects(eDR, eVis3);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, si.caster, RoundsToSeconds(nDuration));
    }

    return eLink;
}
