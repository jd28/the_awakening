#include "mod_funcs_inc"

void main(){
    object oPC     = GetPCSpeaker();
    object oConv;

    int bItem      = GetLocalInt(oPC, "CON_ITEM");
    int nCurrent   = IncrementLocalInt(oPC, "CON_CYCLE_CURRENT");

    if(bItem) oConv = GetLocalObject(oPC, "ITEM_TALK_TO");
    else      oConv = OBJECT_SELF;

    int nCount     = GetLocalInt(oConv, "CON_CYCLE_COUNT");
    string sScript = GetLocalString(oConv, "CON_CYCLE_NEXT_SCRIPT");

    if(nCurrent > nCount)
        SetLocalInt(oPC, "CON_CYCLE_CURRENT", 1);

    ExecuteScript(sScript, oPC);
}
