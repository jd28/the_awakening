//::///////////////////////////////////////////////
//:: Name Strength check on door
//:: FileName  se_door_str
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Description: Calculates D20 + STR Mod against Locked DC of door
     Place in the OnPhysicalAttacked event and make the door plot
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Elric
//:: Created On: 3rd March, 2004
//:://////////////////////////////////////////////
#include "mod_const_inc"

void main(){

    if(!GetLocalInt(OBJECT_SELF, "Bashable"))
        return;

    object oPC = GetLastAttacker();
    object oDoor = OBJECT_SELF;
    if (!GetPlotFlag(oDoor)) { return; }

    int iBashDC = GetMaxHitPoints(OBJECT_SELF);  // need to sanity check this
    int iMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int iRoll = d20();

    if(iRoll + iMod > iBashDC )
      {
        FloatingTextStringOnCreature(C_GREEN+"You have forced the door open."+C_END, oPC, TRUE);

        // effects
        PlaySound("as_sw_metalop1");
        effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oDoor);

        // open the door
        SetLocked(oDoor, FALSE);
        ActionOpenDoor(oDoor);

        // the pc stops bashing
        DelayCommand(0.5, AssignCommand(oPC, PlayAnimation (ANIMATION_FIREFORGET_VICTORY1, 1.0, 2.0)));
      }
      else if(20 + iMod < iBashDC )
      {
        FloatingTextStringOnCreature(C_RED+"You will never bash this door open."+C_END, oPC, TRUE);
        DelayCommand(0.5, AssignCommand(oPC, PlayAnimation (ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0, 2.0)));
      }
      else
      {
        FloatingTextStringOnCreature("The door creaks under the force of the blow but holds fast.", oPC, TRUE);
        DelayCommand(0.5, AssignCommand(oPC, PlayAnimation (ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 2.0)));
      }
}
