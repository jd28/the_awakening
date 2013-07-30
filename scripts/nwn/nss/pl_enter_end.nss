// No Aborting this conversation...

#include "pc_funcs_inc"
#include "mod_const_inc"

void main(){
    object oPC = GetPCSpeaker();
//    if (!(GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) )
//        return;

    // If we know what to do with them, do it.
    if(GetLocalInt(oPC, "boot")){
        DelayCommand(4.0, AssignCommand(GetModule(), BootPlayer(oPC)));
    }
    else if(GetLocalInt(oPC, "delete") || GetLocalInt(GetPCSpeaker(), "Hacker")){
        DelayCommand(4.0, AssignCommand(GetModule(), BootPlayer(oPC)));
        //SetLocalInt(oPC, VAR_PC_DELETED, TRUE);
        //DelayCommand(4.0, AssignCommand(GetModule(), DeleteBic(oPC)));
    }
}
