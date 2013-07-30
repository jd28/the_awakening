#include "NW_I0_GENERIC"

void main(){
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "CON_ITEM");
    DeleteLocalObject(oPC, "ITEM_TALK_TO");

    WalkWayPoints();
}
