#include "gsp_func_inc"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item
    object oDoor = GetItemActivatedTarget();

    if(GetObjectType(oDoor) != OBJECT_TYPE_DOOR){
        ErrorMessage(oPC, "You may only use this item on doors!");
        return;
    }

    if(GetLockKeyRequired(oDoor)){
        ErrorMessage(oPC, "A specific key is required to open that door!");
        return;
    }

    SetLocked(oDoor, FALSE);
}
