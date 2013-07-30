////////////////////////////////////////////////////////////////////////////////
// gsp_deathsphere
//
// Spells: Implosion, Wail of Banshee, Circle of death
//
// TODO: Seperate Damage and save...
//
////////////////////////////////////////////////////////////////////////////////
//#include "hg_inc"
//#include "ac_spell_inc"

#include "gsp_func_inc"


void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    struct SpellImpact impact = CreateSpellImpact();
    int nCap;

    impact.nDeath        = GSP_IMPACT_DEATH_NORMAL;
    impact.nMask         = OBJECT_TYPE_CREATURE;
    impact.nSave         = SAVING_THROW_FORT;
    impact.nSaveType     = SAVING_THROW_TYPE_DEATH;

    switch (si.id) {
        case SPELL_CIRCLE_OF_DEATH:
            nCap = 20;
            impact.nImpact = VFX_IMP_NEGATIVE_ENERGY;
            impact.fRadius = RADIUS_SIZE_LARGE;
            impact.nDamSides = 8;
            impact.nDamType  = DAMAGE_TYPE_NEGATIVE;
            ApplyVisualAtLocation(VFX_FNF_LOS_EVIL_20, si.loc);
        break;
        case SPELL_IMPLOSION:
            nCap                = 60;
            impact.nImpact      = VFX_IMP_NEGATIVE_ENERGY;
            impact.fRadius      = RADIUS_SIZE_MEDIUM;
            impact.nDamSides    = 10;
            impact.nDamType     = DAMAGE_TYPE_MAGICAL;
            ApplyVisualAtLocation(VFX_FNF_IMPLOSION, si.loc);
        break;
        case SPELL_WAIL_OF_THE_BANSHEE:
            impact.fDelayBase   = 3.0;
            nCap                = 60;
            impact.bStorm       = TRUE;
            impact.fRadius      = RADIUS_SIZE_COLOSSAL;
            impact.nDamSides    = 6;
            impact.nDamType     = DAMAGE_TYPE_DIVINE;
            ApplyVisualAtLocation(VFX_FNF_WAIL_O_BANSHEES, si.loc);
        break;
    }
    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    impact.nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplySpellImpactToShape(si, impact, fb);
}
