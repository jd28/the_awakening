////////////////////////////////////////////////////////////////////////////////
// gsp_sphere
//
// originally by acaos, posted by funkyswerve on the bio boards.
//
// Spells: Bombardment, Meteor Swarm, Earthquake, Scinitillating Sphere,
//         Fire Storm, Ice Storm, Flame Strike, Fireball
//         Grenades: AcidBomb, FireBomb, Fire
#include "gsp_func_inc"
void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    struct SpellImpact impact = CreateSpellImpact();
    int nCap;
    effect eEff;

    switch (si.id) {
        /* Meteor Swarm and Bombardment have the same basic effects */
        case SPELL_METEOR_SWARM:
            impact.nMask  = OBJECT_TYPE_CREATURE;
        case SPELL_BOMBARDMENT:
            impact.nImpact = VFX_IMP_FLAME_M;
            impact.bStorm  = TRUE;
            impact.fRadius = RADIUS_SIZE_COLOSSAL;
            nCap           = 60;

            if (si.id == SPELL_BOMBARDMENT) {
                impact.nDamSides = 10;
                impact.nDamType  = DAMAGE_TYPE_BLUDGEONING;
            } else {
                impact.nDamSides = 12;
                impact.nDamType  = DAMAGE_TYPE_FIRE;
            }

            ApplyVisualAtLocation(VFX_FNF_METEOR_SWARM, si.loc);
        break;
        case SPELL_CALL_LIGHTNING:
            impact.nImpact  = VFX_IMP_LIGHTNING_M;
            impact.nDamType = DAMAGE_TYPE_ELECTRICAL; 
            nCap            = 30;
        break;

        case SPELL_DELAYED_BLAST_FIREBALL:
            impact.nImpact  = VFX_IMP_FLAME_M;
            impact.nDamType = DAMAGE_TYPE_FIRE; 
            nCap            = 60;
            ApplyVisualAtLocation(VFX_FNF_FIREBALL, si.loc);
        break;
        case SPELL_DIRGE:
            impact.nImpact   = VFX_IMP_NEGATIVE_ENERGY;
            impact.nDamType  = DAMAGE_TYPE_NEGATIVE; 
            impact.fRadius   = RADIUS_SIZE_HUGE;
            impact.nDamSides = 8;
            nCap             = 40;
    
            
            ApplyVisualAtLocation(VFX_FNF_LOS_EVIL_20, si.loc);
        break;
        case SPELL_EARTHQUAKE:
            si.sp           = -1;
            impact.nImpact  = VFX_IMP_HEAD_NATURE;
            impact.bImm     = TRUE;
            impact.bStorm   = TRUE;
            impact.fRadius  = RADIUS_SIZE_COLOSSAL;
            impact.nSave    = SAVING_THROW_FORT;
            nCap            = 60;
            impact.nDamType = DAMAGE_TYPE_BLUDGEONING;

            if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_subitem_006"){
                si.clevel = GetLevelIncludingLL(si.caster);
                si.dc = GetSubraceSpellDC(si.clevel);
            }

            ApplyVisualToObject(VFX_FNF_SCREEN_SHAKE, si.caster);
            break;
        case SPELL_FIRE_STORM:
            impact.nImpact   = VFX_IMP_FLAME_M;
            impact.bStorm    = TRUE;
            impact.fRadius   = RADIUS_SIZE_COLOSSAL;
            impact.nMask     = OBJECT_TYPE_CREATURE;
            impact.nDamType  = DAMAGE_TYPE_FIRE;
            impact.nDamType2 = DAMAGE_TYPE_DIVINE;
            nCap             = 60;
            impact.nDamDice2 = -2;
            ApplyVisualToObject(VFX_FNF_FIRESTORM, si.caster);
        break;
        case SPELL_HORRID_WILTING:
            nCap              = 60;
            impact.nImpact    = VFX_IMP_NEGATIVE_ENERGY;
            impact.nDamType   = DAMAGE_TYPE_MAGICAL;
            impact.nDamDice   = 8;
            impact.fDelayBase = 1.5;
            impact.fRadius    = RADIUS_SIZE_HUGE;
            impact.nSave      = SAVING_THROW_FORT;

            ApplyVisualAtLocation(VFX_FNF_HORRID_WILTING, si.loc);
        break;
        /* Ice Storm and Flame Strike have the same basic effects */
        case SPELL_ICE_STORM:
        case SPELL_FLAME_STRIKE:
            nCap              = 40;
            impact.bStorm     = TRUE;
            impact.nSave      = 0;
            impact.nDamDice2  = -2;

            if (si.id == SPELL_FLAME_STRIKE) {
                impact.fRadius   = RADIUS_SIZE_MEDIUM;
                impact.nDamType  = DAMAGE_TYPE_FIRE;
                impact.nDamType2 = DAMAGE_TYPE_SLASHING;
                impact.nImpact   = VFX_IMP_FLAME_M;

                ApplyVisualAtLocation(VFX_IMP_DIVINE_STRIKE_FIRE, si.loc);
            } else {
                if(si.class == CLASS_TYPE_BARD)
                    impact.nDamSides = 8;

                impact.nDamType  = DAMAGE_TYPE_COLD;
                impact.nDamType2 = DAMAGE_TYPE_BLUDGEONING;
                impact.nImpact   = VFX_IMP_FROST_S;

                ApplyVisualAtLocation(VFX_FNF_ICESTORM, si.loc);
            }
        break;
        case SPELL_NATURES_BALANCE:
            si.loc = GetLocation(si.caster);

            impact.nDamType  = -1;
            impact.fDuration = MetaDuration(si, si.clevel / 3);
            impact.nDurType  = EFFECT_TRUETYPE_SPELL_RESISTANCE_DECREASE;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.eDur      = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
                                                 EffectSpellResistanceDecrease(si.clevel/6));
            impact.nDurVis   = VFX_IMP_BREACH;

            ApplyVisualAtLocation(VFX_FNF_NATURES_BALANCE, si.loc);
        break;
        case SPELL_SCINTILLATING_SPHERE:
            impact.nImpact   = VFX_IMP_LIGHTNING_S;
            impact.nDamType  = DAMAGE_TYPE_ELECTRICAL;
            nCap             = 20;

            ApplyVisualAtLocation(VFX_FNF_ELECTRIC_EXPLOSION, si.loc);
        break;
        case SPELL_SOUND_BURST:
            nCap             = 20;
            impact.nDamType  = DAMAGE_TYPE_SONIC;
            
            impact.fDuration = RoundsToSeconds(d4()); 
            impact.nDurType  = -1;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.eDur      = EffectStunned();
            impact.nDurVis   = VFX_DUR_MIND_AFFECTING_NEGATIVE;
            ApplyVisualAtLocation(VFX_FNF_SOUND_BURST, si.loc);
        break;
        case SPELLABILITY_AA_IMBUE_ARROW:
            si.clevel        = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, si.caster);
            si.dc            = 10 + max(GetAbilityModifier(ABILITY_WISDOM, si.caster),
                                        GetAbilityModifier(ABILITY_DEXTERITY, si.caster));
            si.dc            += (si.clevel / 5);
            impact.nDamType  = DAMAGE_TYPE_FIRE;
            impact.nImpact   = VFX_IMP_FLAME_M;
            impact.nDamSides = 10;
            impact.nDamBonus = si.clevel;
            nCap             = 60;

            ApplyVisualAtLocation(VFX_FNF_FIREBALL, si.loc);
        break;
        case TASPELL_DENEIRS_EYE:
            si.clevel = GetLevelByClass(CLASS_TYPE_HARPER, si.caster);
            si.dc     = 5 + si.clevel + GetAbilityModifier(ABILITY_CHARISMA, si.caster);
            ApplyVisualAtLocation(VFX_FNF_SOUND_BURST, si.loc);
            
            impact.nDamType  = DAMAGE_TYPE_SONIC;
            impact.nImpact   = VFX_IMP_CONFUSION_S;
            impact.nDamDice  = si.clevel / 2;
            impact.nDamSides = 6;
            impact.nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;  

            impact.fDuration = RoundsToSeconds(2);
            impact.nDurType  = EFFECT_TRUETYPE_LIMIT_MOVEMENT_SPEED;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.eDur      = EffectLinkEffects(EffectConfused(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
        break;
        default: /* Fireball */
            impact.nImpact   = VFX_IMP_FLAME_M;
            impact.nDamType  = DAMAGE_TYPE_FIRE;
            nCap             = 30;
            
            ApplyVisualAtLocation(VFX_FNF_FIREBALL, si.loc);
        break;
    }

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    impact.nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplySpellImpactToShape(si, impact, fb);
}

