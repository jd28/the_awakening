////////////////////////////////////////////////////////////////////////////////
// gsp_cone
//
// originally by acaos, posted by funkyswerve on the bio boards.
//
// Spells: Cone of Cold,
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;
    struct SpellImpact impact = CreateSpellImpact();
    int nCap;

    impact.nShape = SHAPE_SPELLCONE;
    impact.fRadius = 11.0f;
    impact.bStorm = FALSE;

    switch(si.id){
        case SPELL_BURNING_HANDS:
            nCap = 15;
            impact.nDamType = DAMAGE_TYPE_FIRE;
            impact.nImpact  = VFX_IMP_FLAME_S; 
        break;
        case SPELL_MESTILS_ACID_BREATH:
            nCap = 20;
            impact.nDamType = DAMAGE_TYPE_ACID;
            impact.nImpact  = VFX_IMP_ACID_L;
        break;
        case SPELL_CONE_OF_COLD:
        case SPELL_SHADES_CONE_OF_COLD:
            impact.nDamSides = 8;
            nCap = 40;
            impact.nDamType = DAMAGE_TYPE_COLD;
            impact.nImpact  = VFX_IMP_FROST_L;
        break;
        case SPELLABILITY_CONE_ACID:
            impact.nDamType = DAMAGE_TYPE_ACID;
            si.clevel       = GetHitDice(si.caster);
            impact.nImpact  = VFX_IMP_ACID_S;
        break;
        case SPELLABILITY_CONE_COLD:
            impact.nDamType = DAMAGE_TYPE_COLD;
            si.clevel       = GetHitDice(si.caster);
            impact.nImpact  = VFX_IMP_FROST_S;
        break;
        case SPELLABILITY_CONE_DISEASE:
            si.clevel      = GetHitDice(si.caster);
            impact.nImpact = VFX_IMP_DISEASE_S;
        break;
        case SPELLABILITY_CONE_LIGHTNING:
            impact.nDamType = DAMAGE_TYPE_ELECTRICAL;
            si.clevel       = GetHitDice(si.caster);
            impact.nImpact  = VFX_IMP_LIGHTNING_S;
        break;
        case SPELLABILITY_CONE_FIRE:
            impact.nDamType = DAMAGE_TYPE_FIRE;
            si.clevel       = GetHitDice(si.caster);
            impact.nImpact  = VFX_IMP_FLAME_S;
        break;
        case SPELLABILITY_CONE_POISON:
            impact.nImpact = VFX_IMP_POISON_S;
        break;
        case SPELLABILITY_CONE_SONIC:
            impact.nDamType = DAMAGE_TYPE_SONIC;
            si.clevel = GetHitDice(si.caster);
            impact.nImpact = VFX_IMP_SONIC;
        break;
    }
    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    impact.nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplySpellImpactToShape(si, impact, fb);
}
