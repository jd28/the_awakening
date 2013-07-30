////////////////////////////////////////////////////////////////////////////////
// gsp_dmgshield
//
// Spells: Death Armor, Elemental Shield, Aura vs Alignment, Wounding Whispers,
//         Mestil's Acid Sheath.
//
// TODO: Mestil's acid sheath, Auras...
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nDam = si.clevel, nDamBonus = DAMAGE_BONUS_1d6;
    int nDamType, bDebug = FALSE;
    effect eShield = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    switch(si.id){
        case SPELL_DEATH_ARMOR:
            nDamType = DAMAGE_TYPE_MAGICAL;
            nDam /= 2;
            nDam = nDam > 10 ? 10 : nDam;
            eShield = EffectVisualEffect(463);
        break;
        case SPELL_WOUNDING_WHISPERS:
            nDamBonus = DAMAGE_BONUS_2d6;
            nDamType = DAMAGE_TYPE_SONIC;
            eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE));
        break;
        case SPELL_ELEMENTAL_SHIELD:
            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_005"){
                si.clevel = GetLevelIncludingLL(si.caster);
                RemoveEffectsOfSpells(si.caster, SPELL_MESTILS_ACID_SHEATH, SPELL_WOUNDING_WHISPERS, SPELL_DEATH_ARMOR);
                if(si.clevel >= 38)
                    nDamBonus = DAMAGE_BONUS_2d10;
                else if(si.clevel >= 28)
                    nDamBonus = DAMAGE_BONUS_2d8;
                else if(si.clevel >= 18)
                    nDamBonus = DAMAGE_BONUS_2d6;
                else
                    nDamBonus = DAMAGE_BONUS_2d4;

                nDamType = DAMAGE_TYPE_COLD;
                eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_ICESKIN));
            }else{
                nDamType = DAMAGE_TYPE_FIRE;
                nDamBonus = DAMAGE_BONUS_2d6;
                eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
            }
        break;
        case SPELL_MESTILS_ACID_SHEATH:
            nDamBonus = d6(3);
            nDamType = DAMAGE_TYPE_ACID;
            eShield = EffectLinkEffects(eShield, EffectVisualEffect(448));
        break;
        case SPELL_HOLY_AURA:
        case SPELL_UNHOLY_AURA: // The Only Difference is what damage the shields are now...
            nDam /= 2;
            if(si.id == SPELL_HOLY_AURA){
                nDamBonus = DAMAGE_BONUS_2d6;
                nDamType = DAMAGE_TYPE_DIVINE;
                eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
            }
            else{
                nDamBonus = DAMAGE_BONUS_2d6;
                nDamType = DAMAGE_TYPE_NEGATIVE;
                eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR));
            }
            // Consider what else should be here of the orginal spells...
        break;
    }

    Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Generic Damage Shield: Damage: %s (Bonus: %s); " +
           "of %s; Duration: %s rounds", IntToString(nDam), IntToString(nDamBonus), GetDamageTypeName(nDamType),
           IntToString(si.clevel));

    //Fire Event
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
    //Stacking Spellpass, 2003-07-07, Georg
    RemoveEffectsFromSpell(si.target, si.id);

    eShield = EffectLinkEffects(eShield, EffectDamageShield(nDam, nDamBonus, nDamType));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, si.target, MetaDuration(si, si.clevel));
}
