////////////////////////////////////////////////////////////////////////////////
// gsp_ray
//
// Spells: Destruction, Slay Living, Finger of Death
//
// TODO: deal with undeads...
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    struct SpellImpact impact = CreateSpellImpact();
    int nCap;

    impact.nDeath    = GSP_IMPACT_DEATH_NORMAL;
    impact.nMask     = OBJECT_TYPE_CREATURE;
    impact.nSave     = SAVING_THROW_FORT;
    impact.nSaveType = SAVING_THROW_TYPE_DEATH;
    impact.nImpact   = VFX_IMP_NEGATIVE_ENERGY;

    switch(si.id){
        case SPELL_DESTRUCTION:
            nCap                = 50;
            impact.nImpact      = 234;
            impact.nDamType     = DAMAGE_TYPE_DIVINE;
            impact.nDamSides    = 6;
        break;
        case SPELL_SLAY_LIVING:
            nCap             = 50;
            impact.nDamType  = DAMAGE_TYPE_NEGATIVE;
            impact.nDamSides = 6;
        break;
        case SPELL_FINGER_OF_DEATH:
            nCap             = 50;
            impact.nDamType  = DAMAGE_TYPE_NEGATIVE;
            impact.nDamSides = 6;
        break;
        case SPELL_PHANTASMAL_KILLER:
            nCap             = 40;
            impact.nDamType  = DAMAGE_TYPE_POSITIVE;
            impact.nDamSides = 6;
        break;
        case 1507:
            if(!GetIsObjectValid(GetLocalObject(si.target, "pl_pdk_vengeance"))
                    || GetLocalInt(si.target, "Boss")
                    || GetLocalInt(GetModule(), "uptime") - GetLocalInt(si.target, "pl_pdk_vengeance") > 30)
                return;

            nCap             = 60;
            si.clevel        = 0;
            impact.nDamType  = DAMAGE_TYPE_POSITIVE;
            impact.nDamSides = 0;
            impact.nImpact   = 234;
            impact.nDamBonus = GetCurrentHitPoints(si.target) - d4();
        break;
    }
    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    impact.nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplySpellImpactToTarget(si, impact, fb);
}
