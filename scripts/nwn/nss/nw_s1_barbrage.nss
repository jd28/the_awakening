//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the Barbarian increases,
    Will Save are +2, AC -2.
    Greater Rage starts at level 15.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    if(GetHasFeatEffect(FEAT_BARBARIAN_RAGE))
        return;

    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN);
    effect eDmg, eHP;
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nHP, nAB, nSave, nAbil, nHeal;

    if (GetHasFeat(FEAT_MIGHTY_RAGE, si.caster)){
        nAbil = 8;
        nAB = 6;

        // Permenant Hitpoints DO go in the link.
        eLink = EffectLinkEffects(eLink, EffectPermenantHitpoints(nLevel * 10));
        nHeal = nLevel * 10;

        int nDamage = nLevel / 5;
        if(nDamage > 0){
            eDmg = EffectDamageIncrease(GetDamageBonus(nDamage), DAMAGE_TYPE_ELECTRICAL);
            eLink = EffectLinkEffects(eLink, eDmg);
        }   
    }
    else if (nLevel >= 15){
        nAbil = 6;
        nSave = 3;
        nAB = 4;
        nHP = nLevel * 4;

        eDmg = EffectDamageIncrease(DAMAGE_BONUS_6, DAMAGE_TYPE_BLUDGEONING);
    }
    else{
        nAbil = 4;
        nSave = 2;
        nAB = 2;
        nHP = nLevel * 3;
        eDmg = EffectDamageIncrease(DAMAGE_BONUS_4, DAMAGE_TYPE_BLUDGEONING);
    }

    switch(d6()){
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
        case 4: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 5: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 6: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    //Determine the duration by getting the con modifier after being modified
    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION) + nLevel;

    eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, nAbil));
    eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, nAbil));
    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave));
    eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nAB));
    eLink = EffectLinkEffects(eLink, eDmg);

    // Thundering Rage
    if (GetHasFeat(988, si.caster)){
        int nDamage = d6() + (GetLevelByClass(CLASS_TYPE_BARBARIAN, si.caster)/2);
        struct EquippedWeapons ew = GetTargetedOrEquippedWeapon(si.caster, TRUE, TRUE);
        
        AddOnHitDamageToEquippedWeapons(si, ew, DAMAGE_TYPE_SONIC, nDamage, IntToFloat(nCon)); 
    }

    // Terrifying Rage
    if (GetHasFeat(989, si.caster)){
        effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR,"x2_s2_terrage_A", "","");
        eLink = EffectLinkEffects(eLink, eAOE);
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_TAUNT, 20));
    }

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));

    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    if (nCon > 0){
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        
        if(nHeal){
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), OBJECT_SELF);
        }
        
        if(nHP){
            eHP = EffectTemporaryHitpoints(nHP);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nCon));
        }
    }
}
