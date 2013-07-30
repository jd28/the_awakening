//::///////////////////////////////////////////////
//:: Cone: Mindflayer Mind Blast
//:: x2_m1_mindblast
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Anyone caught in the cone must make a
    Will save (DC 17) or be stunned for 3d4 rounds
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    int nBaseDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC), eDam;

    for(si.target = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0f, si.loc, TRUE);
        GetIsObjectValid(si.target);
        si.target = GetNextObjectInShape(SHAPE_SPELLCONE, 15.0f, si.loc, TRUE)) {
        if (!GetIsSpellTarget(si, si.target))
            continue;
        
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
            

        si.meta = (d2() == 1) ? METAMAGIC_EMPOWER : METAMAGIC_MAXIMIZE;
        nBaseDamage = MetaPower(si, GetHitDice(OBJECT_SELF), 12, 0, 0);
        eDam = EffectDamage(nBaseDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
                
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);              

        si.dc = 60;
        if(GetSpellSaved(si, SAVING_THROW_WILL, si.target, -1) && d10() != 1)
            continue;

        FadeToBlack(si.target);
        AssignCommand(si.target, ClearAllActions());
        DelayCommand(4.0f, FadeFromBlack(si.target));
    }
}

