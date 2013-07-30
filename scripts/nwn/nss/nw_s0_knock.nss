//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens doors not locked by magical means.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    float fDelay;
    int nResist;

    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
        fDelay = GetRandomDelay(0.5, 2.5);
        if(!GetLockKeyRequired(oTarget) && GetLocked(oTarget))
        {
            nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
            if (nResist == 0 && GetLockLockDC(oTarget) <= 30)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                AssignCommand(oTarget, ActionUnlockObject(oTarget));
            }
            else if  (nResist == 1)
            {
                FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
