#include "x0_i0_partywide"

void main(){
    object oPC = GetPCSpeaker();
    object oGak = GetItemPossessedBy(oPC, "pl_kuatoa_gak");
    if(oGak == OBJECT_INVALID){
        SpeakString("Wait!  You have no proof!!");
        return;
    }

    DestroyObject(oGak);
    CreateItemOnObject("pl_water_helm", oPC);
    GiveXPToAll(oPC, 3000);
    GiveGoldToAll(oPC, 10000);
}
