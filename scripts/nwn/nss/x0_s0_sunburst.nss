//::///////////////////////////////////////////////
//:: Sunburst
//:: X0_S0_Sunburst
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Brilliant globe of heat
// All creatures in the globe are blinded and
// take 6d6 damage
// Undead creatures take 1d6 damage (max 25d6)
// The blindness is permanent unless cast to remove it
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 23 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 14, 2003
//:: Notes: Changed damage to non-undead to 6d6
//:: 2003-10-09: GZ Added Subrace check for vampire special case, bugfix

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    int nDamage = 0, nBaseDamage, bStorm = TRUE, nMask = OBJECT_TYPE_CREATURE, nSave = SAVING_THROW_REFLEX;
    float fDelay, fRadius = RADIUS_SIZE_COLOSSAL;
    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
    effect eDam;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);

    ApplyVisualAtLocation(VFX_FNF_LOS_HOLY_30, si.loc);
    ApplyVisualToObject(VFX_IMP_HEAD_HOLY, si.caster);

    for (si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
         GetIsObjectValid(si.target);
         si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask)) {
        if (GetIsHealDamage(si.target, DAMAGE_TYPE_MAGICAL)){
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
            if (bStorm)
                fDelay = GetRandomDelay(0.4, 1.2);
            else
                fDelay = GetSpellEffectDelay(si.loc, si.target);
            nDamage = MetaPower(si, si.clevel / 2, 6, 0, fb.dmg);
            eDam    = EffectHeal(nDamage);
            DelayCommand(fDelay, ApplyVisualToObject(VFX_IMP_HEALING_G, si.target));
            //DelayCommand(fDelay, ApplyVisualToObject(CEPVFX_IMP_HEALING_G_ORANGE | HGVFX_ALTERNATE, si.target));
            DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
            continue;
        }

        if (!GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE))
            continue;

        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

        if (bStorm)
            fDelay = GetRandomDelay(0.4, 1.2);
        else
            fDelay = GetSpellEffectDelay(si.loc, si.target);

        if (!GetSpellResisted(si, si.target, fDelay)) {
            if (GetRacialType(si.target) == RACIAL_TYPE_UNDEAD ||
                GetLevelByClass(CLASS_TYPE_PALE_MASTER, si.target) > 0)
            {
                nBaseDamage = MetaPower(si, si.clevel, 6, 0, fb.dmg);
            }
            else{
                nBaseDamage = MetaPower(si, si.clevel / 2, 6, 0, fb.dmg);
            }

            if (nSave == SAVING_THROW_REFLEX) {
                nDamage = GetReflexAdjustedDamage(nBaseDamage, si.target, si.dc, SAVING_THROW_TYPE_SPELL);
            } else if (nSave > 0) {
                if (GetSpellSaved(si, nSave, si.target, SAVING_THROW_TYPE_SPELL, fDelay))
                    nDamage = nBaseDamage / 2;
                else
                    nDamage = nBaseDamage;
            } else
                nDamage = nBaseDamage;
            if (nDamage > 0) {
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
                if (!GetSpellSaved(si, SAVING_THROW_REFLEX, si.target, SAVING_THROW_TYPE_SPELL, fDelay))
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), si.target);
            }
        }
    }
}

