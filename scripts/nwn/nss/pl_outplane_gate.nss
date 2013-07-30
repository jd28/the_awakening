#include "quest_func_inc"
#include "x2_inc_toollib"
#include "mod_funcs_inc"

void main(){
    object oPC = GetLastUsedBy();
    object oGate = GetNearestObjectByTag("ms_outplane_gate");

    // If it's open already forget the rest.
    if(GetLocalInt(oGate, "Opened")) return;

    if(HasItem(oPC, "pl_key_astral")){
        SetLocalInt(oGate, "Opened", TRUE);
        AssignCommand(oGate, SpeakString("[The gate activates, but does not look like it will remain open for long.]"));
        //ApplyVisualToObject(VFX_DUR_GLOW_LIGHT_BLUE, oGate, 30.0);
        DelayCommand(30.0, DeleteLocalInt(oGate, "Opened"));
    }
    else{
        SendMessageToPC(oPC, "The Outer Planes Gate control looks as though it has no power source.");
    }

}
