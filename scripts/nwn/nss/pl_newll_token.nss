#include "pc_funcs_inc"

void main() {
    object oPC = GetLastUsedBy();

    if(GetItemPossessedBy(oPC, "tall2_start_dlg") == OBJECT_INVALID)
		CreateItemOnObject("tall2_start_dlg", oPC);

	if(GetItemPossessedBy(oPC, "pl_ll3_conv") == OBJECT_INVALID)
		CreateItemOnObject("pl_ll3_conv", oPC);
}
