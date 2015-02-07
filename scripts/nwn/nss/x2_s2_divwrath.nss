//::///////////////////////////////////////////////
//:: Divine Wrath
//:: x2_s2_DivWrath
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Divine Champion is able to channel a portion
    of their gods power once per day giving them a +3
    bonus on attack rolls, damage, and saving throws
    for a number of rounds equal to their Charisma
    bonus. They also gain damage reduction of +1/5.
    At 10th level, an additional +2 is granted to
    attack rolls and saving throws.

    Epic Progression
    Every five levels past 10 an additional +2
    on attack rolls, damage and saving throws is added. As well the damage
    reduction increases by 5 and the damage power required to penetrate
    damage reduction raises by +1 (to a maximum of /+5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: Jul 21, 2003 Georg Zoeller -
//                            Epic Level progession
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Check that if nDuration is not above 0, make it 1.
    if(GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF) <= 0){
        FloatingTextStrRefOnCreature(100967,OBJECT_SELF);
        return;
    }

    si.clevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, si.target);

    int nBonus = (GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, si.target) / 5) - 1;
    if(nBonus < 0) nBonus = 0;

    int nAttackBonus = 5 + (2 * nBonus);
    int nSaveBonus = nAttackBonus;
    int nDamBonus = IPGetDamageBonusConstantFromNumber(5 + (2 * nBonus));
    int nDamType = DAMAGE_TYPE_POSITIVE;
    int nHPBonus = si.clevel * 4;

    int nDuration = GetAbilityModifier(ABILITY_CHARISMA, si.caster);
    float fDuration = RoundsToSeconds(nDuration);
    if(si.clevel == 30) fDuration *= 4;
    else if(si.clevel >= 20) fDuration *= 3;
    else if(si.clevel >= 10) fDuration *= 2;

    Logger(si.caster, "DebugSpells", LOGLEVEL_DEBUG, "Divine Wrath: Bonus: %s, HP: %s, Duration: %s",
        IntToString(nAttackBonus), IntToString(nHPBonus), FloatToString(fDuration, 4, 0));

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_GOOD_HELP),eVis);
    effect eAttack, eDamage, eSaving;
    //Fire cast spell at event for the specified target
    SignalEvent(si.caster, EventSpellCastAt(si.caster, si.id, FALSE));

    eAttack = EffectAttackIncrease(nAttackBonus,ATTACK_BONUS_MISC);
    eDamage = ExpandedEffectDamageIncrease(nDamBonus, nDamType, FALSE, TRUE);
    eSaving = EffectSavingThrowIncrease(SAVING_THROW_ALL,nSaveBonus, SAVING_THROW_TYPE_ALL);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eSaving,eLink);
    eLink = EffectLinkEffects(eDur,eLink);
    eLink = SupernaturalEffect(eLink);

    // prevent stacking with self
    RemoveEffectsFromSpell(si.caster, si.id);
    RemoveTempHitPoints();

    if(nHPBonus > 0){
        DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPBonus), si.target, fDuration));
    }

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.caster, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.caster);
}
