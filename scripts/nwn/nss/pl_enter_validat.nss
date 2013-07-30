#include "pc_validate_inc"
#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker(), oItem;
    AssignCommand(oPC, ActionPauseConversation());

    if(GetHitDice(oPC) == 1){ //Only validate if 1st Level...
        // Strip All Items and Gold
        if(PC_STRIP_ALL_GOLD)
            AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));

        if(PC_STRIP_ALL_ITEMS){
            // Destroy Inventory
            oItem = GetFirstItemInInventory(oPC);
            while(GetIsObjectValid(oItem)){
                SetPlotFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, FALSE);
                DestroyObject(oItem);
                oItem = GetNextItemInInventory(oPC);
            }
            // Destroy Equipped Items.
            int i;
            for(i = 0; i < NUM_INVENTORY_SLOTS; i++){
                oItem = GetItemInSlot(i, oPC);
                SetPlotFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, FALSE);
                DestroyObject(oItem);
            }
        }

        //Check if PC isn't Hacked
        DelayCommand(1.0f,  GetIsPCValid(oPC));
    }
    DelayCommand(6.0f, AssignCommand(oPC, ActionResumeConversation()));
}
