#include "item_func_inc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oMith; // = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if(GetLocalInt(OBJECT_SELF, "MithrilType")){ // Guant
        oMith = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    }
    else{
        oMith = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    }

    return(GetItemEnhancementBonus(oMith) > 0);
}
