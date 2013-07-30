////////////////////////////////////////////////////////////////////////////////
// gsp_sphere
//
// originally by acaos, posted by funkyswerve on the bio boards.
//
// Spells: Bombardment, Meteor Swarm, Earthquake, Scinitillating Sphere,
//         Fire Storm, Ice Storm, Flame Strike, Fireball
//         Grenades: AcidBomb, FireBomb, Fire
////////////////////////////////////////////////////////////////////////////////
//#include "hg_inc"
//#include "ac_spell_inc"

#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    float fDelay, fRadius = RADIUS_SIZE_HUGE;
    int nBaseDamage, nDamage, nDamage2, bStorm = TRUE, bImm = FALSE, bKnockdown = FALSE;
    int nMask = OBJECT_TYPE_CREATURE;
    int nSave = SAVING_THROW_FORT, nSaveType = SAVING_THROW_TYPE_NONE;
    int nDamType, nDamDice, nDamSides = 10, nDamBonus, nDamBonus2, nDamType2, nDamDice2 = 0, nDamVuln = 0;
    effect eVis, eDam;

    nDamType = GetLocalInt(si.caster, "PL_ELE_SWARM");
    if(nDamType == 0)
        nDamType = DAMAGE_TYPE_ACID;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 60);
    nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;


    int nVFX;
    switch (nDamType) {
        case DAMAGE_TYPE_ACID:
            ApplyVisualAtLocation(VFX_FNF_HORRID_WILTING, si.loc);
            nVFX = VFX_FNF_GAS_EXPLOSION_ACID;
            break;
        case DAMAGE_TYPE_COLD:
            ApplyVisualAtLocation(VFX_FNF_HOWL_MIND, si.loc);
            nVFX = VFX_FNF_GAS_EXPLOSION_NATURE;
            break;
        case DAMAGE_TYPE_ELECTRICAL:
            ApplyVisualAtLocation(VFX_FNF_MYSTICAL_EXPLOSION, si.loc);
            nVFX = VFX_FNF_GAS_EXPLOSION_GREASE;
            break;
        case DAMAGE_TYPE_FIRE:
            ApplyVisualAtLocation(494, si.loc);
            nVFX = VFX_FNF_GAS_EXPLOSION_FIRE;
            break;
        case DAMAGE_TYPE_SONIC:
            ApplyVisualAtLocation(VFX_FNF_SOUND_BURST, si.loc);
            nVFX = VFX_FNF_GAS_EXPLOSION_MIND;
            break;
    }
    ApplyVisualAtLocation(nVFX, si.loc);

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
        string sMessage = "Generic Sphere: Radius: " + FloatToString(fRadius, 1, 1) +
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
        sMessage += ", Mask: " + IntToHexString(nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }

    for (si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
         GetIsObjectValid(si.target);
         si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask)) {
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
            continue;
        }
        if (!GetIsSpellTarget(si, si.target))
            continue;
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
    }
}

