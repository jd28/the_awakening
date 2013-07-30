#include "vfx_inc"
#include "item_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oBow = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nCost = 10000000;
    int nGold = GetGold(oPC);
    int nBaseType = GetBaseItemType(oBow);

    if(nGold < nCost){
        SpeakString("You don't have enough money!");
        return;
    }
    else if(nBaseType != BASE_ITEM_HEAVYCROSSBOW &&
            nBaseType != BASE_ITEM_LIGHTCROSSBOW &&
            nBaseType != BASE_ITEM_LONGBOW &&
            nBaseType != BASE_ITEM_SHORTBOW &&
            nBaseType != BASE_ITEM_SLING)
    {
        SpeakString("I can't work with that type of item!");
        return;
    }

    TakeGoldFromCreature(nCost, oPC, TRUE);

    itemproperty ip = ItemPropertyAttackBonus(8);
    IPSafeAddItemProperty(oBow, ip);
    ip = ItemPropertyMaxRangeStrengthMod(8);
    IPSafeAddItemProperty(oBow, ip);

    ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
    SpeakString("There you go.");
}
