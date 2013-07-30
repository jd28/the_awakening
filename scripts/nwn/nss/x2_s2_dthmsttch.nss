//::///////////////////////////////////////////////
//:: Deathless Master Touch
//:: X2_S2_dthmsttch
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Pale Master may use their undead arm to
    kill their foes.

    -Requires melee Touch attack
    -Save vs DC 17 to resist

    Epic:
    -SaveDC raised by +1 for each 2 levels past 10th
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 24, 2003
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;
    si.dc = 10 + GetLevelByClass(CLASS_TYPE_PALEMASTER, si.caster);

    if(!GetIsEnemy(si.target, si.caster)
            || TouchAttackMelee(si.target, TRUE) == 0)
        return;
    
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
    int nDamage = GetCurrentHitPoints(si.target) - d4();
    if(MySavingThrow(SAVING_THROW_FORT, si.target, si.dc, SAVING_THROW_TYPE_NEGATIVE))
        nDamage /= 2;

    //Apply effects to target and caster
    Harm(si, nDamage, 246, VFX_IMP_HEALING_G);
}
