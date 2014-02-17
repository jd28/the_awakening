#include "mod_funcs_inc"

void main(){

    object oPC = GetEnteringObject();
    string sConv = "pl_instance";
    SetLocalObject(oPC, "PL_CONV_WITH", OBJECT_SELF);
    if (!GetIsPC(oPC)) return;

    //SendMessageToPC(oPC, "Trigger Conversation: "+sConv+" with "+ GetName(GetLocalObject(oPC, "PL_CONV_WITH")) );

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionStartConversation(oPC, sConv, TRUE, FALSE));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}
