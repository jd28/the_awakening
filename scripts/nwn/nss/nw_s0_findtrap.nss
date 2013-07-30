//::////////////////////////////////////////////////////////////////////////////
//:: Find Traps
//:: NW_S0_FindTrap
//:: Copyright (c) 2001 Bioware Corp.
//::////////////////////////////////////////////////////////////////////////////
/*
    - Finds and removes all traps within 30m.
    - Caster level + d20 vs the trap disarm

      Fail    - Trap detected
      Success - Trap disabled
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created By : Preston Watamaniuk
//:: Created On : Oct 29, 2001
//:: Modified By: Sir Elric
//:: Modified On: 15th April, 2006
//::////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) <= 30.0)
    {
        if(GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, OBJECT_SELF);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTrap));

            object oCaster = OBJECT_SELF;
            int nDC = GetTrapDisarmDC(oTrap);
            int nLevel = GetCasterLevel(oCaster);
            int nRandom = d20()+ nLevel;
            string sTrap = GetName(oTrap);

            if(nDC <= 30)
            {
                if(GetObjectType(oTrap) == OBJECT_TYPE_TRIGGER)
                   SendMessageToPC(oCaster, "You have successfully disabled the " + sTrap + "");
                else
                   SendMessageToPC(oCaster, "You have successfully disabled the trap on the " + sTrap + "");

                // For respawning trap code...
                SetLocalInt(oTrap, "DISARMED_BY_SPELL", TRUE);
                DelayCommand(2.0, SetTrapDisabled(oTrap));
            }
            else
            {
                if(GetObjectType(oTrap) == OBJECT_TYPE_TRIGGER)
                   SendMessageToPC(oCaster, "You have detected " + sTrap + " but are unable to disable it");
                else
                   SendMessageToPC(oCaster, "You have detected the trap on the " + sTrap + " but are unable to disable it");
            }
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}
