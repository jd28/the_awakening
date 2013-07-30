#include "area_inc"

void main(){

    object oPC = GetEnteringObject();
    if(GetItemPossessedBy(oPC, "pl_krook_bag") == OBJECT_INVALID)
        ExploreAreaForPlayer(OBJECT_SELF, oPC, FALSE);

    AreaSpawnsActivate(OBJECT_SELF);
}
