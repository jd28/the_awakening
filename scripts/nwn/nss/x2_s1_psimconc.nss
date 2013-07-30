//::///////////////////////////////////////////////
//:: Psionics: Mass Concussion
//:: x2_s1_psimconc
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Mindflayer Power
   Cause hit dice / 2 points of damage to hostile creatures
   and objects in a RADIUS_SIZE_MEDIUM area around the caster

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;
   
    int type = d2();
    si.clevel= GetHitDice(OBJECT_SELF);

    float fDelay, fRadius = RADIUS_SIZE_HUGE;
    int nBaseDamage, nDamage, nDamage2, bStorm = FALSE, bImm = FALSE, bKnockdown = FALSE;
    int nMask = OBJECT_TYPE_CREATURE;
    int nSave = SAVING_THROW_REFLEX, nSaveType = SAVING_THROW_TYPE_NONE;
    int nDamType, nDamDice, nDamSides = 6, nDamBonus, nDamBonus2, nDamType2, nDamDice2 = 0, nDamVuln = 0;
    effect eVis, eDam, eImpact;

    switch (type) {
        case 1: // Mass Concussion
            eImpact = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
            eImpact = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), eImpact);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);
            
            eVis = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
            
            nDamSides = 10;
            nDamDice = si.clevel;

            for (si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
                 GetIsObjectValid(si.target);
                 si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask)) {

                if (!GetIsSpellTarget(si, si.target))
                    continue;
                SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
                
                nBaseDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, 0);
                fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(si.target)) / 20;
                eDam = EffectDamage(nBaseDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY);
                
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));              
            }

        break;
        case 2: // Mass Ability Drain
            SpeakString("TODO: CHANGE EFFECTS");

            eImpact = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
            eImpact = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_10), eImpact);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);

            eDam = ExtraordinaryEffect(EffectAbilityDecrease(d6() - 1, 3));
            eVis = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
            si.dc = 60;

            for (si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
                 GetIsObjectValid(si.target);
                 si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask)) {
                
                if (!GetIsSpellTarget(si, si.target))
                    continue;

                SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
                
                fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(si.target)) / 20;
                
                if (!GetSpellSaved(si, SAVING_THROW_WILL, si.target, nSaveType, fDelay)){ 
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));              
                }
            }           
        break;
    }
}
