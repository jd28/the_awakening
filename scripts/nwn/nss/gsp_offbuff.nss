////////////////////////////////////////////////////////////////////////////////
// gsp_offbuff
//
// Spells:
//
// TODO: Fix Temp Hit Points
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"
int DumpCombatInformation(object oCreature) {
    SetLocalString(oCreature, "NWNX!FUNCS!DUMPCOMBATINFORMATION", ".....");
    return StringToInt(GetLocalString(oCreature, "NWNX!FUNCS!DUMPCOMBATINFORMATION"));
}
void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nShape = SHAPE_SPHERE;
    int nSaveBonus, nHPBonus, nAttackBonus, nDamBonus, nDamType, nExtraAttacks, nACDodge, nACDecrease;
    int nTotalCharacterLevel, nBAB, nEpicPortionOfBAB;
    int bSingleTarget = TRUE, bSupernatural = FALSE, bExtraordinary = FALSE;
    float fDuration, fRadius = RADIUS_SIZE_COLOSSAL, fDelay;
    effect eVis;
    effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    switch(si.id){
        // 1st
        case SPELL_BLESS:
            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);
            si.target = si.caster;
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            nAttackBonus = 1;
            nSaveBonus = 1;
            bSingleTarget = FALSE;
        break;
        case SPELL_DIVINE_FAVOR:
            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);
            nAttackBonus = 1;

            fDuration = MetaDuration(si, si.clevel, DURATION_IN_ROUNDS);
            nAttackBonus = si.clevel / 3;
            if (nAttackBonus < 1) nAttackBonus = 1;
            if (nAttackBonus > 6) nAttackBonus = 6;
            si.target = si.caster;
            nDamBonus = nAttackBonus;
            nDamType = DAMAGE_TYPE_MAGICAL;
        break;

        case SPELL_TRUE_STRIKE:
            si.target = si.caster;
            nAttackBonus = 20;
            fDuration = 18.0f;
            eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        break;

        // 2nd
        case SPELL_AID:
            RemoveTempHitPoints();
            nAttackBonus = 2;
            nSaveBonus = 1;
            nHPBonus = MetaPower(si, 2, 8, 0, 0);
            fDuration = MetaDuration(si, si.clevel, DURATION_IN_TURNS);
            eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
        break;
        case SPELL_BLOOD_FRENZY:
            // If already has effect return.
            if(GetHasSpellEffect(si.id)) return;

            PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

            fDuration = MetaDuration(si, si.clevel);
            nAttackBonus = 2;
            nHPBonus = si.clevel * 2;
            nSaveBonus = 1;
            eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        break;

        // 4th
        case SPELL_TENSERS_TRANSFORMATION:
        case SPELL_DIVINE_POWER:
            eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOW_RED));
            // No Stacking
            if (GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION, si.caster) == TRUE)
                RemoveSpellEffects(SPELL_TENSERS_TRANSFORMATION, si.caster, si.caster);

            if (GetHasSpellEffect(SPELL_DIVINE_POWER, si.caster) == TRUE)
                RemoveSpellEffects(SPELL_DIVINE_POWER, si.caster, si.caster);

            RemoveTempHitPoints();

            nTotalCharacterLevel = GetHitDice(OBJECT_SELF);
            nBAB = GetBaseAttackBonus(OBJECT_SELF);
            nEpicPortionOfBAB = ( nTotalCharacterLevel - 19 ) / 2;
            if ( nEpicPortionOfBAB < 0 ) nEpicPortionOfBAB = 0;
            nExtraAttacks = 0;

            if ( nTotalCharacterLevel > 20 ){
                nAttackBonus = 20 + nEpicPortionOfBAB;
                if( nBAB - nEpicPortionOfBAB < 11 )
                    nExtraAttacks = 2;
                else if( nBAB - nEpicPortionOfBAB > 10 && nBAB - nEpicPortionOfBAB < 16)
                    nExtraAttacks = 1;
            }
            else{
                nAttackBonus = nTotalCharacterLevel;
                nExtraAttacks = ( ( nTotalCharacterLevel - 1 ) / 5 ) - ( ( nBAB - 1 ) / 5 );
            }
            nAttackBonus -= nBAB;

            if ( nAttackBonus < 0 ) nAttackBonus = 0;

            nHPBonus = si.clevel;
            fDuration = MetaDuration(si, si.clevel);
        break;
        case TASPELL_PDK_SACRED_RITE:
            ApplyVisualAtLocation(VFX_IMP_PDK_GENERIC_PULSE, si.loc);
            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            bSingleTarget = FALSE;
            bExtraordinary = TRUE;
            fRadius = 20.0f;
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            fDuration = RoundsToSeconds(si.clevel / 2);
            eLink = EffectLinkEffects(eLink, EffectDCIncrease(si.clevel / 8));
        break;
        case 811: // PDK Inspire Courage
            ApplyVisualAtLocation(VFX_IMP_PDK_GENERIC_PULSE, si.loc);
            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            bSingleTarget = FALSE;
            bExtraordinary = TRUE;
            fRadius = 20.0f;
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            fDuration = RoundsToSeconds(si.clevel / 2);
            nAttackBonus = si.clevel / 10;
            if(nAttackBonus == 0) nAttackBonus = 1;
            nDamBonus = nAttackBonus * 2;
        break;
        case SPELL_TYMORAS_SMILE:
            eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);
            nAttackBonus = 1;

            si.clevel = GetLevelByClass(CLASS_TYPE_HARPER, si.caster);
            fDuration = MetaDuration(si, nAttackBonus, DURATION_IN_TURNS);
            nAttackBonus = (si.clevel - 20) / 5;
            if (nAttackBonus < 1) nAttackBonus = 1;
            if (nAttackBonus > 5) nAttackBonus = 5;
            si.target = si.caster;
            nDamBonus = nAttackBonus;
            nDamType = DAMAGE_TYPE_MAGICAL;
        break;
    }

    //eLink = eDur;

    if(nSaveBonus > 0){
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSaveBonus);
        eLink = EffectLinkEffects(eLink, eSave);
    }

    if(nAttackBonus > 0){
        effect eAB = EffectAttackIncrease(nAttackBonus);
        eLink = EffectLinkEffects(eLink, eAB);
    }

    if(nExtraAttacks > 0){
        effect eExtraAttack = EffectAdditionalAttacks(nExtraAttacks);
        eLink = EffectLinkEffects(eLink, eExtraAttack);
    }

    if(nDamBonus > 0){
        effect eDamBonus = EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nDamBonus), nDamType);
        eLink = EffectLinkEffects(eLink, eDamBonus);
    }

    if(nACDodge > 0){
        effect eDodge = EffectACIncrease(nACDodge, AC_DODGE_BONUS);
        eLink = EffectLinkEffects(eLink, eDodge);
    }

    if(nACDecrease > 0){
        effect eDodgeDec = EffectACDecrease(nACDecrease, AC_DODGE_BONUS);
        eLink = EffectLinkEffects(eLink, eDodgeDec);
    }
    if(bExtraordinary)
        eLink = ExtraordinaryEffect(eLink);
    else if(bSupernatural)
        eLink = SupernaturalEffect(eLink);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
		GZRemoveSpellEffects(si.id, si.target);
        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
        DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration));
        if(nHPBonus > 0){
            DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPBonus), si.target, fDuration));
        }

    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, GetLocation(si.caster));
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                //Fire spell cast at event for target
                SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
				GZRemoveSpellEffects(si.id, si.target);
                //Apply VFX impact and bonus effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                if(nHPBonus > 0){
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nHPBonus), si.target, fDuration));
                }
            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, GetLocation(si.caster));
        }
    }

    //DumpCombatInformation(si.target);

	Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Generic Offensive Buff: Attack: %s, " +
           "Hitpoints: %s; Save: %s; Extra Attacks: %s; Damage Bonus: %s of %s; Dodge Bonus: %s;" +
           "AC Decrease: %s;", IntToString(nAttackBonus), IntToString(nHPBonus), IntToString(nSaveBonus),
           IntToString(nExtraAttacks), IntToString(nDamBonus), GetDamageTypeName(nDamType), IntToString(nACDodge),
           IntToString(nACDecrease));
}
