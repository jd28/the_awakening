#include "pc_funcs_inc"
#include "x2_inc_switches"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if (nEvent != X2_ITEM_EVENT_EQUIP) return;
    object oPC   = GetPCItemLastEquippedBy();
    object ring1 = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
    object ring2 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);

    if(GetResRef(ring1) == "dno_div_ring_1"
       && GetResRef(ring2) == "dno_div_ring_1" ){
        DelayCommand(0.5f, ForceUnequipItem(oPC, GetPCItemLastEquipped()));
        ErrorMessage(oPC, "You may only wear one these rings at once.");
    }
}
