//::///////////////////////////////////////////////
//:: Bard Song
//:: NW_S2_BardSong
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for a set duration of
    10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller Oct 1, 2003
/*
bugfix by Kovi 2002.07.30
- loosing temporary hp resulted in loosing the other bonuses
*/

#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF)){
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    int bCurse      = (si.id == 644);
    int bBreach     = FALSE;
    int bKnockdown  = FALSE;
    int nLevel      = GetLevelByClass(CLASS_TYPE_BARD);
    int nPerform    = GetSkillRank(SKILL_PERFORM);
    int nChr        = GetAbilityModifier(ABILITY_CHARISMA);
    int nDuration   = 10;
    effect eImpact  = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    float fDelay;
    effect eAttack, eDamage, eWill, eFort, eReflex, eHP, eAC, eSkill, eLink, eFNF, eVis;
    int nAttack, nDamage, nWill, nFort, nReflex, nHP, nAC, nSkill;
    int bWound = FALSE;

    effect eWound;

    if(bCurse)
        eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    else
        eLink  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // lingering song
    if(GetHasFeat(424)) nDuration += 5;
    //Lasting Impression and increase duration.
    if(GetHasFeat(870)) nDuration *= 10;
    // Artist feat adds +1 to perform per Bard level.
    if(GetHasFeat(FEAT_ARTIST)) nPerform += nLevel;

    if(nPerform >= 100 && nLevel >= 40){
        nAttack     = 5;
        nDamage     = DAMAGE_BONUS_7;
        nWill       = 4;
        nFort       = 4;
        nReflex     = 4;
        nHP         = 80;
        nAC         = 8;
        nSkill      = 20;

        if(nPerform >= 125 && nLevel == 60){
            if(bCurse)
                bBreach = TRUE;
            else {
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 50));
                eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
                eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
            }
        }

        // In this case, no stack.
        if(nPerform >= 120 && nLevel >= 56){
            if(bCurse){
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, 10));
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 10));
            }
            else {
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 10));
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 10));
            }
        }
        else if(nPerform >= 105 && nLevel >= 44){
            if(bCurse){
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_MAGICAL, 5));
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityDecrease(DAMAGE_TYPE_SONIC, 5));
            }
            else {
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 5));
                eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 5));
            }
        }

        if(nPerform >= 115 && nLevel >= 52){
            if(bCurse)  bKnockdown = TRUE;
            else        eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_10, DAMAGE_TYPE_SLASHING));
        }
        if(nPerform >= 110 && nLevel >= 48){
            bWound = TRUE;
            if(bCurse)  eWound = EffectMovementSpeedDecrease(25);
            else        eWound = EffectRegenerate(10, 6.0f);
        }
    }
    else if(nPerform >= 90 && nLevel >= 39){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_7;
        nWill       = 4;
        nFort       = 4;
        nReflex     = 4;
        nHP         = 75;
        nAC         = 8;
        nSkill      = 19;
    }
    else if(nPerform >= 90 && nLevel >= 38){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_7;
        nWill       = 4;
        nFort       = 4;
        nReflex     = 4;
        nHP         = 70;
        nAC         = 8;
        nSkill      = 19;
    }
    else if(nPerform >= 85 && nLevel >= 37){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 4;
        nFort       = 4;
        nReflex     = 4;
        nHP         = 65;
        nAC         = 7;
        nSkill      = 18;
    }
    else if(nPerform >= 85 && nLevel >= 36){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 4;
        nFort       = 4;
        nReflex     = 3;
        nHP         = 65;
        nAC         = 7;
        nSkill      = 18;
    }
    else if(nPerform >= 80 && nLevel >= 35){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 4;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 60;
        nAC         = 6;
        nSkill      = 17;
    }
    else if(nPerform >= 80 && nLevel >= 34){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 60;
        nAC         = 6;
        nSkill      = 17;
    }
    else if(nPerform >= 70 && nLevel >= 33){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 60;
        nAC         = 6;
        nSkill      = 16;
    }
    else if(nPerform >= 70 && nLevel >= 32){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 55;
        nAC         = 6;
        nSkill      = 16;
    }
    else if(nPerform >= 65 && nLevel >= 31){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_6;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 55;
        nAC         = 6;
        nSkill      = 15;
    }
    else if(nPerform >= 65 && nLevel >= 30){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_5;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 55;
        nAC         = 5;
        nSkill      = 14;
    }
    else if(nPerform >= 60 && nLevel >= 29){
        nAttack     = 4;
        nDamage     = DAMAGE_BONUS_5;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 50;
        nAC         = 5;
        nSkill      = 14;
    }
    else if(nPerform >= 60 && nLevel >= 28){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_5;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 50;
        nAC         = 5;
        nSkill      = 14;
    }
    else if(nPerform >= 55 && nLevel >= 27){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 3;
        nHP         = 50;
        nAC         = 5;
        nSkill      = 13;
    }
    else if(nPerform >= 55 && nLevel >= 26){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 2;
        nHP         = 45;
        nAC         = 5;
        nSkill      = 13;
    }
    else if(nPerform >= 50 && nLevel >= 25){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 3;
        nFort       = 3;
        nReflex     = 2;
        nHP         = 45;
        nAC         = 5;
        nSkill      = 12;
    }
    else if(nPerform >= 50 && nLevel >= 24){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 3;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 40;
        nAC         = 4;
        nSkill      = 12;
    }
    else if(nPerform >= 45 && nLevel >= 23){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 3;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 40;
        nAC         = 4;
        nSkill      = 11;
    }
    else if(nPerform >= 45 && nLevel >= 22){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 40;
        nAC         = 4;
        nSkill      = 11;
    }
    else if(nPerform >= 40 && nLevel >= 21){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_4;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 40;
        nAC         = 4;
        nSkill      = 10;
    }
    else if(nPerform >= 40 && nLevel >= 20){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 35;
        nAC         = 4;
        nSkill      = 10;
    }
    else if(nPerform >= 35 && nLevel >= 19){
        nAttack     = 3;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 35;
        nAC         = 3;
        nSkill      = 9;
    }
    else if(nPerform >= 35 && nLevel >= 18){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 35;
        nAC         = 3;
        nSkill      = 9;
    }
    else if(nPerform >= 30 && nLevel >= 17){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 30;
        nAC         = 3;
        nSkill      = 8;
    }
    else if(nPerform >= 30 && nLevel >= 16){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 30;
        nAC         = 3;
        nSkill      = 8;
    }
    else if(nPerform >= 25 && nLevel >= 15){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 2;
        nHP         = 30;
        nAC         = 3;
        nSkill      = 7;
    }
    else if(nPerform >= 25 && nLevel >= 14){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_3;
        nWill       = 2;
        nFort       = 2;
        nReflex     = 1;
        nHP         = 25;
        nAC         = 2;
        nSkill      = 7;
    }
    else if(nPerform >= 20 && nLevel >= 13){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 2;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 25;
        nAC         = 2;
        nSkill      = 6;
    }
    else if(nPerform >= 20 && nLevel >= 12){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 25;
        nAC         = 2;
        nSkill      = 6;
    }
    else if(nPerform >= 15 && nLevel >= 11){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 20;
        nAC         = 2;
        nSkill      = 5;
    }
    else if(nPerform >= 15 && nLevel >= 11){
        nAttack     = 2;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 20;
        nAC         = 2;
        nSkill      = 5;
    }
    else if(nPerform >= 15 && nLevel >= 10){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 20;
        nAC         = 2;
        nSkill      = 5;
    }
    else if(nPerform >= 12 && nLevel >= 9){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 20;
        nAC         = 1;
        nSkill      = 4;
    }
    else if(nPerform >= 10 && nLevel >= 8){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 15;
        nAC         = 1;
        nSkill      = 4;
    }
    else if(nPerform >= 9 && nLevel >= 7){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_2;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 15;
        nAC         = 1;
        nSkill      = 3;
    }
    else if(nPerform >= 8 && nLevel >= 6){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 15;
        nAC         = 1;
        nSkill      = 3;
    }
    else if(nPerform >= 7 && nLevel >= 5){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 10;
        nAC         = 0;
        nSkill      = 2;
    }
    else if(nPerform >= 6 && nLevel >= 4){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 10;
        nAC         = 0;
        nSkill      = 2;
    }
    else if(nPerform >= 5 && nLevel >= 3){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 1;
        nFort       = 1;
        nReflex     = 1;
        nHP         = 5;
        nAC         = 0;
        nSkill      = 1;
    }
    else if(nPerform >= 4 && nLevel >= 2){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 1;
        nFort       = 0;
        nReflex     = 0;
        nHP         = 0;
        nAC         = 0;
        nSkill      = 0;
    }
    else if(nPerform >= 3 && nLevel >= 1){
        nAttack     = 1;
        nDamage     = DAMAGE_BONUS_1;
        nWill       = 0;
        nFort       = 0;
        nReflex     = 0;
        nHP         = 0;
        nAC         = 0;
        nSkill      = 0;
    }



    Logger(si.caster, "DebugSpells", LOGLEVEL_DEBUG,
        "Bard/Curse Song: Type: %s, Attack: %s, Damage: %s, W/F/R: %s/%s/%s, HP/Dmg: %s, AC: %s, Skills: %s, Duration: %s",
        IntToString(bCurse), IntToString(nAttack), IntToString(nDamage) , IntToString(nWill), IntToString(nFort),
        IntToString(nReflex), IntToString(nHP), IntToString(nAC), IntToString(nSkill), IntToString(nDuration));

    if(bCurse){
        eVis = EffectVisualEffect(VFX_IMP_DOOM);
        nHP = MetaPower(si, GetAbilityScore(si.caster, ABILITY_CHARISMA), 6, nHP, 0);
    }
    else{
        nHP += GetAbilityScore(si.caster, ABILITY_CHARISMA) * 6;
        eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
    }

    if(bCurse){
        eAttack = EffectAttackDecrease(nAttack);
        eDamage = EffectDamageDecrease(nDamage, DAMAGE_TYPE_SLASHING);
    }
    else {
        eAttack = EffectAttackIncrease(nAttack);
        eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
    }

    eLink = EffectLinkEffects(eLink, eAttack);
    eLink = EffectLinkEffects(eLink, eDamage);

    if(nWill > 0){
        if(bCurse)  eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, nWill);
        else        eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, nWill);
        eLink = EffectLinkEffects(eLink, eWill);
    }

    if(nFort > 0){
        if(bCurse)  eFort = EffectSavingThrowDecrease(SAVING_THROW_FORT, nFort);
        else        eFort = EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort);
        eLink = EffectLinkEffects(eLink, eFort);
    }

    if(nReflex > 0){
        if(bCurse)  eReflex = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nReflex);
        else        eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflex);
        eLink = EffectLinkEffects(eLink, eReflex);
    }

    if(nHP > 0){
        if(bCurse)  eHP = EffectDamage(nHP, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL);
        else        eHP = ExtraordinaryEffect(EffectTemporaryHitpoints(nHP));
    }
    if(nAC > 0){
        if(bCurse)  eAC = EffectACDecrease(nAC, AC_DODGE_BONUS);
        else        eAC = EffectACIncrease(nAC, AC_DODGE_BONUS);
        eLink = EffectLinkEffects(eLink, eAC);
    }

    if(nSkill > 0){
        if(bCurse){
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_CONCENTRATION, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_DISCIPLINE, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_LISTEN, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_PARRY, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SEARCH, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SPOT, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_TUMBLE, nSkill));
            eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SPELLCRAFT, nSkill));
        }
        else eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill);
        eLink = EffectLinkEffects(eLink, eSkill);
    }

    if(bCurse)  eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    else        eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    eLink = ExtraordinaryEffect(eLink);

    if(bCurse){
        if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF)){
            FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
            return;
        }

        for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
            si.target != OBJECT_INVALID;
            si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster))){

            if(!GetIsSpellTarget(si, si.target))
                continue;

            fDelay = GetSpellEffectDelay(si.loc, si.target);

            if(GetHasFeatEffect(871, si.target)                     ||
                    GetHasSpellEffect(si.id, si.target)             ||
                    GetHasEffect(EFFECT_TYPE_DEAF, si.target)       ||
                    GetIsDead(si.target))
                continue;

            if (nHP > 0){
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SONIC), si.target);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHP, si.target));
            }

            if(bKnockdown && !GetLocalInt(si.target, "Boss") && GetCreatureSize(si.target) != CREATURE_SIZE_HUGE){
                effect eKD = EffectImmunityDecrease(IMMUNITY_TYPE_KNOCKDOWN, 10);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKD, si.target, RoundsToSeconds(5)));
            }

            if(bWound){
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWound, si.target, RoundsToSeconds(nDuration)));
            }

            if(bBreach){
                DelayCommand(fDelay, DoSpellBreach(si.target, 3, 5, SPELL_LESSER_SPELL_BREACH));
            }

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
        }
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
    else {
        for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
            si.target != OBJECT_INVALID;
            si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster))){

            if(GetHasFeatEffect(FEAT_BARD_SONGS, si.target)         ||
                    GetHasSpellEffect(si.id, si.target)             ||
                    GetHasEffect(EFFECT_TYPE_SILENCE, si.target)    ||
                    GetHasEffect(EFFECT_TYPE_DEAF, si.target))
                continue;

            fDelay = GetSpellEffectDelay(si.loc, si.target);

            if(si.target == si.caster){
                effect eLinkBard = EffectLinkEffects(eLink, eVis);
                eLinkBard = ExtraordinaryEffect(eLinkBard);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, si.target, RoundsToSeconds(nDuration)));

                if(bWound)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWound, si.target, RoundsToSeconds(nDuration)));
                if (nHP > 0)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, si.target, RoundsToSeconds(nDuration)));
            }
            else if(GetIsFriend(si.target)){
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, RoundsToSeconds(nDuration)));

                if(bWound)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWound, si.target, RoundsToSeconds(nDuration)));
                if (nHP > 0)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, si.target, RoundsToSeconds(nDuration)));
            }
        }
    }
}
