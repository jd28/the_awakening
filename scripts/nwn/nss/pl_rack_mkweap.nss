#include "dip_func_inc"
#include "pl_pcinvo_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE");
    string sResref;

    if(nCode == 700) // Monk Guants
        sResref = "pl_mithral_guants";
    else
        sResref = GetWeaponResref(nCode);

    if(sResref == ""){
        SendMessageToPC(oPC, "Error no weapon resref.  Please inform a DM.");
    }
    object oWeap = CreateItemOnObject(sResref, oPC);
    if(nCode >= 800 && nCode < 900){
        ApplyQuiverVariables(oWeap, GetTag(OBJECT_SELF), nCode);
    }
    else
        ApplyLocalsToWeapon(OBJECT_SELF, oWeap, OBJECT_INVALID, OBJECT_INVALID);

    DeleteLocalInt(oPC, GetTag(OBJECT_SELF));
}
