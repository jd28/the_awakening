#include "mod_funcs_inc"
#include "vfx_inc"



void ResetObelisks(object oObelisk){
    int i;
    object oPortal = GetNearestObjectByTag("pl_valedead_port", oObelisk);
    DeleteLocalInt(oPortal, "Active");

    DeleteLocalInt(oObelisk, "Used");
    RemoveAllVisuals(oObelisk);

    for(i = 1; i < 4; i++){
        oObelisk = GetNearestObjectByTag("pl_valedead_obelisk", oObelisk, i);
        DeleteLocalInt(oObelisk, "Used");
        RemoveAllVisuals(oObelisk);
    }
}

void main(){
    object oObelisk;
    float fDelay = 1800.0;
    int i;

    if(GetLocalInt(OBJECT_SELF, "Used")) return;

    SetLocalInt(OBJECT_SELF, "Used", TRUE);
    ApplyVisualToObject(VFX_DUR_AURA_PULSE_RED_GREEN, OBJECT_SELF, fDelay);
    DelayCommand(fDelay, ResetObelisks(OBJECT_SELF));

    for(i = 1; i < 4; i++){
        oObelisk = GetNearestObjectByTag("pl_valedead_obelisk", OBJECT_SELF, i);
        if(!GetLocalInt(oObelisk, "Used")) return;
    }

    object oPortal = GetNearestObjectByTag("pl_valedead_port", oObelisk);
    SetLocalInt(oPortal, "Active", 1);

}
