#include "pc_funcs_inc"
#include "x2_inc_switches"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if (nEvent != X2_ITEM_EVENT_EQUIP) return;
    object oPC   = GetPCItemLastEquippedBy();
    object ring1 = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);    
    object ring2 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);    

    if(GetResRef(ring1) == "ms_ringofchristm"
       && GetResRef(ring2) == "ms_ringofchristm" ){
        DelayCommand(0.5f, ForceUnequipItem(oPC, GetPCItemLastEquipped()));
        ErrorMessage(oPC, "You may only wear one Ring of Christmas at once.");
    }
}
