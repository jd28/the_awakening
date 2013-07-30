#include "pc_funcs_inc"
#include "gsp_func_inc"

void main(){
    object oPC = GetClickingObject();
    int nDoor = GetLocalInt(GetArea(OBJECT_SELF), "CorrectDoor");
    int nThisDoor = StringToInt(GetStringRight(GetTag(OBJECT_SELF), 1));

    if(nDoor == nThisDoor){
        JumpSafeToWaypoint("WP_BeStr02_right", oPC);
        ApplyVisualToObject(VFX_FNF_SOUND_BURST, oPC);
        return;
    }

    effect eDam = EffectDamage(GetCurrentHitPoints(oPC) - d4(), DAMAGE_TYPE_MAGICAL);
    //Apply the VFX impact and effects
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
    ApplyVisualToObject(246, oPC);
    DelayCommand(2.0, JumpSafeToWaypoint("WP_BeStr02_wrong", oPC));
}
