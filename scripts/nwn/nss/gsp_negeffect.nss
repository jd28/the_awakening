#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int bDominate = FALSE;
    int bCharm    = FALSE;

    struct SpellImpact impact = CreateSpellImpact();
    int nCap;
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    struct FocusBonus fb;

    impact.nDurType = -1;

    switch(si.id){
        case SPELL_CHARM_PERSON_OR_ANIMAL:
            if (!GetIsPlayableRacialType(si.target) ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_GOBLINOID ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_MONSTROUS ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_ORC ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_REPTILIAN ||
                GetRacialType(si.target) != RACIAL_TYPE_ANIMAL)
                return;
            bCharm = TRUE;
        break;
        case SPELL_CHARM_PERSON:
            if (!GetIsPlayableRacialType(si.target) ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_GOBLINOID ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_MONSTROUS ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_ORC ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_REPTILIAN)
                return;
            bCharm = TRUE;
        break;
        case SPELL_CHARM_MONSTER:
            bCharm = TRUE;
        break;
        case SPELL_CONFUSION:
            ApplyVisualToObject(VFX_FNF_LOS_NORMAL_20, si.target);
            impact.fDuration = MetaDuration(si, 2);
            impact.nDurVis   = VFX_IMP_CONFUSION_S;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
            eLink = EffectLinkEffects(eLink, EffectConfused());
        break;
        case SPELL_CONTAGION:
            switch (d6()){
                case 1: nCap = ABILITY_STRENGTH;     break;
                case 2: nCap = ABILITY_DEXTERITY;    break;
                case 3: nCap = ABILITY_CONSTITUTION; break;
                case 4: nCap = ABILITY_INTELLIGENCE; break;
                case 5: nCap = ABILITY_WISDOM;       break;
                case 6: nCap = ABILITY_CHARISMA;     break;
            }
            impact.fDuration = MetaDuration(si, si.clevel);
            impact.nDurVis   = VFX_IMP_DISEASE_S;
            impact.nDurSave  = SAVING_THROW_FORT;
            impact.nSaveType = SAVING_THROW_TYPE_DISEASE;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FLIES));
            eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(nCap, d4()));

        break;
        case SPELL_DAZE:
            impact.fDuration = MetaDuration(si, 2);
            impact.nDurVis   = VFX_IMP_DAZED_S;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
            eLink = EffectLinkEffects(eLink, EffectDazed());
        break;
        case SPELL_SHADOW_DAZE:
            impact.nDurVis   = VFX_IMP_DAZED_S;
            impact.fDuration = MetaDuration(si, 5);
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
            eLink = EffectLinkEffects(eLink, EffectDazed());
        break;
        case SPELL_DOMINATE_ANIMAL:
            bDominate = TRUE;
            if(GetRacialType(si.target) != RACIAL_TYPE_ANIMAL)
                return;
        break;
        case SPELL_DOMINATE_MONSTER:
            bDominate = TRUE;
            // Nothing to be done
        break;
        case SPELL_DOMINATE_PERSON:
            if (!GetIsPlayableRacialType(si.target) ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_GOBLINOID ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_MONSTROUS ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_ORC ||
                GetRacialType(si.target) != RACIAL_TYPE_HUMANOID_REPTILIAN)
                return;
            bDominate = TRUE;
        break;
        case SPELL_CONTROL_UNDEAD:
            if(GetRacialType(si.target) != RACIAL_TYPE_UNDEAD) return;
            bDominate = TRUE;
        break;
        case SPELLABILITY_PM_UNDEAD_GRAFT_1:
        case SPELLABILITY_PM_UNDEAD_GRAFT_2:
        case SPELL_ENERVATION:
            si.dc = 10 + GetLevelByClass(CLASS_TYPE_PALEMASTER, si.caster);

            impact.fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
            impact.nDurType  = EFFECT_TRUETYPE_NEGATIVE_LEVEL;
            impact.nDurSave  = SAVING_THROW_FORT;
            impact.nDurVis   = VFX_IMP_REDUCE_ABILITY_SCORE;
            impact.nSaveType = SAVING_THROW_TYPE_NEGATIVE;

            eLink = EffectLinkEffects(eLink, EffectNegativeLevel(MetaPower(si, 2, 4, 0, 0)));
        break;
        case SPELL_FEAR:
            ApplyVisualToObject(VFX_IMP_FEAR_S, si.target);
            ApplyVisualToObject(VFX_FNF_LOS_NORMAL_20, si.target);

            impact.fDuration = MetaDuration(si, d4());
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_FEAR;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
            eLink = EffectLinkEffects(eLink, EffectFrightened());
        break;

        case SPELL_POISON:
            impact.fDuration = MetaDuration(si, d4(), DURATION_IN_HOURS);
            impact.nDurType  = EFFECT_TRUETYPE_POISON;

            eLink = EffectLinkEffects(eLink, EffectPoison(POISON_LARGE_SCORPION_VENOM));
        break;
        case SPELL_SCARE:
            impact.fDuration = MetaDuration(si, d4());
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_FEAR;

            eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2));
            eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
            eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS));
        break;
        case 808: // PDK FEAR
            ApplyVisualToObject(VFX_FNF_LOS_NORMAL_20, si.target);
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            si.dc = 10 + si.clevel + GetAbilityModifier(ABILITY_CHARISMA, si.caster);
            impact.fDuration = MetaDuration(si, si.clevel / 2);
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nSaveType = SAVING_THROW_TYPE_FEAR;
            nCap = si.clevel / 8;
            if (nCap > 6)       nCap = 6;
            else if (nCap <= 0) nCap = 1;

            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
            eLink = EffectLinkEffects(eLink, EffectDCDecrease(si.clevel/8));
        break;
        case 809: // PDK OATH OF WRATH
            if (si.target == si.caster){
                FloatingTextStringOnCreature("You cannot target yourself using this ability", si.caster, FALSE);
                return;
            }
            else if (GetIsFriend(si.target)){
                 FloatingTextStringOnCreature("You cannot target an ally using this ability", si.caster, FALSE);
                 return;
            }
            else if(GetIsPC(si.target)){
                 FloatingTextStringOnCreature("You cannot target other players with this ability!", si.caster, FALSE);
                 return;
            }
			return;
			/*
            ApplyVisualToObject(VFX_IMP_PDK_OATH, si.caster);

            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            impact.nDurVis   = VFX_IMP_PDK_WRATH;
            impact.fDuration = MetaDuration(si, si.clevel / 2);

            eLink = EffectLinkEffects(eLink, EffectOathOfWrath(si.clevel/8));
			*/
        break;
        case 1506: // PDK VALIANCE
            ApplyVisualToObject(VFX_FNF_LOS_NORMAL_20, si.target);
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            si.dc = 10 + si.clevel;

            impact.fRadius   = 5.0f;
            impact.fDuration = MetaDuration(si, si.clevel / 2);
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.nDurVis   = VFX_IMP_BLIND_DEAF_M;

            eLink = EffectLinkEffects(eLink, EffectBlindness());
        break;
    }

    if(bCharm){
        if(GetChallengeRating(si.target) >= 38.0f)
            return;

        impact.fDuration = RoundsToSeconds(d6());
        impact.nDurSave  = SAVING_THROW_WILL;
        impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;
        eLink            = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
        eLink            = EffectLinkEffects(eLink, EffectCharmed());
    }
    else if(bDominate){
        if(GetChallengeRating(si.target) >= 38.0f)
            return;

        impact.fDuration = RoundsToSeconds(d6());
        impact.nDurSave  = SAVING_THROW_WILL;
        impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;
        impact.nDurVis   = VFX_IMP_DOMINATE_S;

        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED));
        eLink = EffectLinkEffects(eLink, EffectDominated());
    }

    impact.eDur = eLink;
    ApplySpellImpactToTarget(si, impact, fb);
}
