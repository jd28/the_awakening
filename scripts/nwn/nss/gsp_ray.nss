////////////////////////////////////////////////////////////////////////////////
// gsp_ray
//
// Spells: Ray of Frost, Searing Light, Negative Energy Ray, Flam Lash.
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDelay;
    int nBaseDamage, nDamage, nDamage2, bStorm = FALSE, bImm = FALSE, bKnockdown = FALSE;
    int nSave = SAVING_THROW_REFLEX, nSaveType = SAVING_THROW_TYPE_NONE, nRay, nCap;
    int nDamType, nDamDice, nDamSides = 6, nDamBonus, nDamBonus2, nDamType2, nDamDice2 = 0, nDamVuln = 0;
    effect eVis, eDam;

    switch(si.id){
        case SPELL_RAY_OF_FROST:
            nRay = VFX_BEAM_COLD;
            nDamType = DAMAGE_TYPE_COLD;
            nDamSides = 4;
            nCap = 10;
            nSave = 0;
            eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        break;
        case SPELL_SEARING_LIGHT:
            nRay = VFX_BEAM_HOLY;
            nDamType = DAMAGE_TYPE_DIVINE;
            nCap = 40;
            nDamSides = 8;
            nSave = 0;
            eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            if (GetRacialType(si.target) != RACIAL_TYPE_UNDEAD){
                nDamDice /= 2;
                if(nDamDice == 0) nDamDice = 1;

                if (GetRacialType(si.target) != RACIAL_TYPE_CONSTRUCT)
                    nDamSides = 6;
            }
        break;
        case SPELL_NEGATIVE_ENERGY_RAY:
            nRay = VFX_BEAM_EVIL;
            nDamType = DAMAGE_TYPE_NEGATIVE;
            nCap = 15;
            nSave = SAVING_THROW_WILL;
            eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        break;
        case SPELL_FLAME_LASH:
            nRay = VFX_BEAM_FIRE_LASH;
            nDamType = DAMAGE_TYPE_FIRE;
            nCap = 25;
            nSave = SAVING_THROW_REFLEX;
            eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        break;
    }

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    if (nSaveType == SAVING_THROW_TYPE_NONE) {
        switch (nDamType) {
            case DAMAGE_TYPE_ACID:       nSaveType = SAVING_THROW_TYPE_ACID;        break;
            case DAMAGE_TYPE_COLD:       nSaveType = SAVING_THROW_TYPE_COLD;        break;
            case DAMAGE_TYPE_ELECTRICAL: nSaveType = SAVING_THROW_TYPE_ELECTRICITY; break;
            case DAMAGE_TYPE_FIRE:       nSaveType = SAVING_THROW_TYPE_FIRE;        break;
            case DAMAGE_TYPE_SONIC:      nSaveType = SAVING_THROW_TYPE_SONIC;       break;
            case DAMAGE_TYPE_DIVINE:     nSaveType = SAVING_THROW_TYPE_DIVINE;      break;
            case DAMAGE_TYPE_MAGICAL:    nSaveType = SAVING_THROW_TYPE_SPELL;       break;
            case DAMAGE_TYPE_NEGATIVE:   nSaveType = SAVING_THROW_TYPE_NEGATIVE;    break;
            case DAMAGE_TYPE_POSITIVE:   nSaveType = SAVING_THROW_TYPE_POSITIVE;    break;
        }
    }

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Ray: " +
            ", Damage: " + IntToString(nDamDice) + "d" + IntToString(nDamSides) +
            "+" + IntToString(nDamBonus) + " " + GetDamageTypeName(nDamType);
        if (nDamVuln > 0)
            sMessage += " (" + IntToString(nDamVuln) + "% vuln)";
        if (nDamDice2 < 0) {
            sMessage += " (1/" + IntToString(-nDamDice2) + " " + GetDamageTypeName(nDamType2) + ")";
        } else if (nDamDice2 > 0) {
            sMessage += " / " + IntToString(nDamDice2) + "d" +
                IntToString(nDamSides) + "+" + IntToString(nDamBonus2) +
                " " + GetDamageTypeName(nDamType2);
        }
        sMessage += ", Save: " + GetSaveName(nSave, TRUE) + "/" + GetSaveTypeName(nSaveType, TRUE);
        sMessage += ", Storm: " + IntToString(bStorm);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    if (GetIsHealDamage(si.target, nDamType)){
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        if (bStorm)
            fDelay = GetRandomDelay(0.4, 1.2);
        else
            fDelay = GetSpellEffectDelay(si.loc, si.target);

        nDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, fb.dmg);
        eDam    = EffectHeal(nDamage);
        DelayCommand(fDelay, ApplyVisualToObject(VFX_IMP_HEALING_G, si.target));
        //DelayCommand(fDelay, ApplyVisualToObject(CEPVFX_IMP_HEALING_G_ORANGE | HGVFX_ALTERNATE, si.target));
        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
        return;
    }

    if (!GetIsSpellTarget(si, si.target)) return;

    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    if (bStorm)
    fDelay = GetRandomDelay(0.4, 1.2);
    else
    fDelay = GetSpellEffectDelay(si.loc, si.target);

    if (!GetSpellResisted(si, si.target, fDelay) &&
    (!bImm || !GetHasSpellImmunity(si.id, si.target))) {
        nBaseDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, fb.dmg);
        if (nSave == SAVING_THROW_REFLEX) {
            nDamage = GetReflexAdjustedDamage(nBaseDamage, si.target, si.dc, nSaveType);
        } else if (nSave > 0) {
            if (GetSpellSaved(si, nSave, si.target, nSaveType, fDelay))
            nDamage = nBaseDamage / 2;
            else
            nDamage = nBaseDamage;
        } else
        nDamage = nBaseDamage;
        if (nDamage > 0) {
            if (nDamVuln > 0) {
                effect eVuln = EffectDamageImmunityDecrease(nDamType, nDamVuln);
                DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVuln, si.target, 6.0));
            }
            if (nDamDice2 != 0) {
                if (nDamDice2 > 0) {
                    nDamage2 = MetaPower(si, nDamDice2, nDamSides, nDamBonus2, fb.dmg);
                    if (nDamage < nBaseDamage)
                    nDamage2 /= 2;
                } else if (nDamDice2 < 0) {
                    nDamage2 = nDamage / -nDamDice2;
                    nDamage -= nDamage2;
                }
                eDam = EffectDamage(nDamage2, nDamType2);
                DelayCommand(fDelay + 0.05, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
            }
            eDam = EffectDamage(nDamage, nDamType);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
            if (bKnockdown && !GetHasEffectOfTrueType(EFFECT_TRUETYPE_KNOCKDOWN, si.target)) {
                if (!GetSpellSaved(si, SAVING_THROW_REFLEX, si.target, nSaveType, fDelay))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), si.target, RoundsToSeconds(d3() + 1));
            }
        }
    }
    ApplyRayToObject(nRay, si.target);
}
