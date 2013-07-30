#include "mod_funcs_inc"

void main(){
    object oPC     = GetPCSpeaker();
    object oConv;

    int bItem      = GetLocalInt(oPC, "CON_ITEM");
    int nCurrent   = DecrementLocalInt(oPC, "CON_CYCLE_CURRENT");

    if(bItem) oConv = GetLocalObject(oPC, "ITEM_TALK_TO");
    else      oConv = OBJECT_INVALID;

    int nCount     = GetLocalInt(oConv, "CON_CYCLE_COUNT");
    string sScript = GetLocalString(oConv, "CON_CYCLE_PREV_SCRIPT");

    if(nCurrent < 1)
        SetLocalInt(oPC, "CON_CYCLE_CURRENT", nCount);

    ExecuteScript(sScript, oPC);
}
