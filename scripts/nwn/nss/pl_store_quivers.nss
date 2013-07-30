#include "pl_pcinvo_inc"
#include "mod_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE");
    string sResref = GetWeaponResref(nCode);
    int nGold = GetLocalInt(OBJECT_SELF,"QuiverCost");

    Logger(oPC, "DebugLogs", LOGLEVEL_DEBUG, "Code: " + IntToString(nCode) +", Resref: "+ sResref+", Gold: " + IntToString(nGold) );

    if(GetGold(oPC) > nGold){
        TakeGoldFromCreature(nGold, oPC, TRUE);
        object oWeap = CreateItemOnObject(sResref, oPC);
        ApplyQuiverVariables(oWeap, GetTag(OBJECT_SELF), nCode);
    }
    else{
        SpeakString("You haven't got "+IntToString(nGold)+" gold!");
    }

}
