#include "item_func_inc"
#include "mon_func_inc"

int GetAppearanceIsDynamic(int appear){
	if(appear < 7)
		return TRUE;
	else if (appear == 1002)
		return TRUE;
	else if (appear == 1000)
		return TRUE;

	return FALSE;
}

void CopyEquipAppearance(object self, object pc);

void CopyEquipAppearance(object self, object pc){
	object temp;
	int slot;
	
	slot = INVENTORY_SLOT_CLOAK;
	temp = GetItemInSlot(slot, pc);
	if(temp != OBJECT_INVALID){
		temp = CopyItem(temp, self);
		SetDroppableFlag(temp, FALSE);
		IPRemoveAllItemProperties(temp, DURATION_TYPE_PERMANENT);
		ActionEquipItem(temp, slot);
	}
	slot = INVENTORY_SLOT_CHEST;
	temp = GetItemInSlot(slot, pc);
	if(temp != OBJECT_INVALID){
		temp = CopyItem(temp, self);
		SetDroppableFlag(temp, FALSE);
		IPRemoveAllItemProperties(temp, DURATION_TYPE_PERMANENT);
		ClearAllActions(TRUE);
		ActionEquipItem(temp, slot);
	}
    ActionDoCommand(SetCommandable(TRUE));
    //ActionDoCommand(DetermineCombatRound());
    SetCommandable(FALSE);

}

void main() {
	object self = OBJECT_SELF;
	object pc = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
	int appear = GetAppearanceType(pc);

	SetGender(self, GetGender(pc));
	if(GetAppearanceIsDynamic(appear))
		CopyEquipAppearance(self, pc);
	
	SetCreatureAppearanceType(self, appear);
	SetColor(self, COLOR_CHANNEL_HAIR, GetColor(pc, COLOR_CHANNEL_HAIR));
	SetColor(self, COLOR_CHANNEL_SKIN, GetColor(pc, COLOR_CHANNEL_SKIN));
	SetColor(self, COLOR_CHANNEL_TATTOO_1, GetColor(pc, COLOR_CHANNEL_TATTOO_1));
	SetColor(self, COLOR_CHANNEL_TATTOO_2, GetColor(pc, COLOR_CHANNEL_TATTOO_2));
	SetCreatureBodyPart(CREATURE_PART_HEAD, GetCreatureBodyPart(CREATURE_PART_HEAD, pc), self);


	DetermineCombatRound(pc);
}
