#include "nwnx_inc"
#include "item_func_inc"

int StartingConditional(){
    object oPC = GetPCSpeaker();
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if(!GetIsObjectValid(oArmor)) return FALSE;

    int nBaseAC = GetBaseArmorACBonus(oArmor);
    return (nBaseAC >= 6);
}
