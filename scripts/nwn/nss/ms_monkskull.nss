#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;

    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACQUIRE:

            oPC = GetModuleItemAcquiredBy();
            oItem  = GetModuleItemAcquired();

AddJournalQuestEntry("ms_JE_TMonks", 3, oPC, FALSE, FALSE);


            break;

        case X2_ITEM_EVENT_UNACQUIRE:


            oPC = GetModuleItemLostBy();
            oItem  = GetModuleItemLost();


            break;

    }

    SetExecutedScriptReturnValue(nResult);
}

