////////////////////////////////////////////////////////////////////////////////
// gsp_arrow
//
// Spells: Ice Dagger, Melf's Acid Arrow, Quillfire
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDelay, fDist = GetDistanceBetween(si.caster, si.target);
    int nBaseDamage, nDamage, nSave = -1, nSaveType;
    int nDamType, nDamDice, nDamSides = 6, nDamBonus;
    int bImm = FALSE, bPoison = FALSE, bDebug = FALSE, nCap;

    effect eVis, eDam, eArrow;

    switch(si.id){
        case SPELL_ICE_DAGGER:
            nCap = 10;
            nDamSides = 4;
            nDamType = DAMAGE_TYPE_COLD;
            nSave = SAVING_THROW_REFLEX;
            fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(si.target))/20;
        break;
        case SPELL_MELFS_ACID_ARROW:
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:
            fDelay = fDist/(3.0 * log(fDist) + 2.0);
            nCap = 15; 
            nDamType = DAMAGE_TYPE_ACID;
            eArrow = EffectVisualEffect(245);
            bPoison = TRUE;
        break;
        case SPELL_QUILLFIRE:
            nCap = 40; 
            nDamSides = 8;
            bImm = TRUE;
            bPoison = TRUE;
            nDamType = DAMAGE_TYPE_MAGICAL;
        break;
    }

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    if (nSaveType == SAVING_THROW_TYPE_NONE)
        nSaveType = GetSaveType(nDamType);

    Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Generic Death Arrow: " +
           "Damage: %sd%s + %s of %s; Save: %s; Poison: %s", IntToString(nDamDice),
           IntToString(nDamSides), IntToString(nDamBonus), GetDamageTypeName(nDamType), GetSaveName(nSave, TRUE) + "/" + GetSaveTypeName(nSaveType, TRUE),
           IntToString(bPoison));

    if(GetIsReactionTypeFriendly(si.target))
        return;

    if (GetIsHealDamage(si.target, nDamType)){
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
        nDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, fb.dmg);
        eDam    = EffectHeal(nDamage);
        ApplyVisualToObject(VFX_IMP_HEALING_G, si.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);

        return;
    }
    
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
    if (GetSpellResisted(si, si.target, fDelay) &&
        (bImm && GetHasSpellImmunity(si.id, si.target)))
        return;
    
    nBaseDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, fb.dmg);

    if (nSave == SAVING_THROW_REFLEX){
        nDamage = GetReflexAdjustedDamage(nBaseDamage, si.target, si.dc, nSaveType);
    } else if (nSave > 0) {
        if (GetSpellSaved(si, nSave, si.target, nSaveType, fDelay))
            nDamage = nBaseDamage / 2;
        else
            nDamage = nBaseDamage;
    } else
        nDamage = nBaseDamage;

    eDam = EffectDamage(nDamage, nDamType);

    //Apply vfx and damage
    if(nDamage > 0){
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, si.target));
    }
    //Apply poison
    if(bPoison){
        // * also applies poison damage
        effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, si.target));
    }
    
    //Arrow if any
    if(GetEffectType(eArrow) != EFFECT_TYPE_INVALIDEFFECT)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, si.target);
}
