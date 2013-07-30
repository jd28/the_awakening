#include "nwnx_inc"

void main(){
	object oPC = GetPCSpeaker();
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if(oItem == OBJECT_INVALID || GetBaseItemType(oItem) != BASE_ITEM_LONGBOW){
		SpeakString("Sorry I can't do anything with that weapon.");
		return;
	}
	if(GetGold(oPC) > 5000000){
		TakeGoldFromCreature(5000000, oPC, TRUE);
		SetBaseItemType(oItem, BASE_ITEM_SHORTBOW);
		return;
	}

	SpeakString("You don't have enough gold!");

}
