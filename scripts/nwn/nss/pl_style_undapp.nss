#include "pl_pcstyle_inc"
#include "mod_funcs_inc"

void main(){
    object oPC     = GetPCSpeaker();

    int bItem    = GetLocalInt(oPC, "CON_ITEM");
    int nCurrent = GetLocalInt(oPC, "CON_CYCLE_CURRENT");
    int nCode    = GetUndeadStyleAppearance(nCurrent);
    
    SendMessageToPC(oPC, "Current: "+IntToString(nCurrent)+"Appearance: "+IntToString(nCode));

    if(nCode >= 0)
        SetCreatureAppearanceType(oPC, nCode);
    else
        ErrorMessage(oPC, "Something terrible happened!");
}

