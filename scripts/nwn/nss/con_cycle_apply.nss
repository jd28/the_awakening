#include "mod_funcs_inc"

void main(){
    object oPC     = GetPCSpeaker();
    object oConv;

    int bItem      = GetLocalInt(oPC, "CON_ITEM");

    if(bItem) oConv = GetLocalObject(oPC, "ITEM_TALK_TO");
    else      oConv = OBJECT_INVALID;

    string sScript = GetLocalString(oConv, "CON_CYCLE_APPLY_SCRIPT");

    ExecuteScript(sScript, oPC);
}
