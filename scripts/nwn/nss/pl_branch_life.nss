#include "x2_inc_switches"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    object oPC, oItem;                                //The item being used

    int nResult = X2_EXECUTE_SCRIPT_END, nCharges;

    switch (nEvent){

//////////////////////////////////////////////////////////////////////////////
      case X2_ITEM_EVENT_ACTIVATE:
        // * This code runs when the Unique Power property of the item is used or the item
        // * is activated. Note that this event fires for PCs only

        oPC = GetItemActivator();        // The player who activated the item
        oItem = GetItemActivated();      // The item that was activated
        nCharges = GetLocalInt(oItem, "PL_BRANCH_CHARGES");
        FloatingTextStringOnCreature("You have " + IntToString(nCharges) + " charge(s) remaining.", oPC, FALSE);
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
