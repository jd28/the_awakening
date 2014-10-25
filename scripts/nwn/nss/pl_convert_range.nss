#include "dip_func_inc"
#include "vfx_inc"

void main(){
	object oPC = GetPCSpeaker();
	string sb = "nw_wbwsh001";
	string lb = "nw_wbwln001";

    object oForge = GetNearestObjectByTag("Forge");

    object oItem = GetFirstItemInInventory(oForge);

	if(oItem == OBJECT_INVALID) {
		SpeakString("You haven't put an item on the workbench!");
	}
    else if(GetNextItemInInventory(oForge) != OBJECT_INVALID){
        SpeakString("You can only put one bow on the workbench at a time!");
        return;
    }
	else if (GetBaseItemType(oItem) != BASE_ITEM_LONGBOW
			 && GetBaseItemType(oItem) != BASE_ITEM_SHORTBOW ){
		SpeakString("Sorry I can't do anything with that weapon, it isn't a bow.");
		return;
	}
	else if(GetGold(oPC) < 5000000) {
		SpeakString("You don't have enough gold!");
		return;
	}

	SetLocked(oForge, TRUE);
	TakeGoldFromCreature(5000000, oPC, TRUE);
	string resref;
	if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW)
		resref = sb;
	else
		resref = lb;

	object obj = CreateItemOnObject(resref, oForge);
    SetName(obj, GetName(oItem));
	SetLocalString(obj, "ilr_tagged", GetLocalString(oItem, "ilr_tagged"));

    itemproperty ipProp;
    for(ipProp = GetFirstItemProperty(oItem);
        GetIsItemPropertyValid(ipProp);
        ipProp = GetNextItemProperty(oItem))
    {
        if(GetItemPropertyDurationType(ipProp) != DURATION_TYPE_PERMANENT)
            continue;

        IPSafeAddItemProperty(obj, ipProp, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
    }

    DestroyObject(oItem);
    ApplyVisualToObject(VFX_FNF_SOUND_BURST, oForge);
    SetLocked(oForge, FALSE);
    SpeakString("There you go.");
}
