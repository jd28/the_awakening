#include "pc_funcs_inc"

void main() {
    object oPC = GetLastUsedBy();

    if(GetItemPossessedBy(oPC, "tall2_start_dlg") != OBJECT_INVALID
       || GetLootable(oPC) > 40){
        ErrorMessage(oPC, "Either you have taken LLs or you have a token.");
        return;
    }
         
    CreateItemOnObject("tall2_start_dlg", oPC);
}
