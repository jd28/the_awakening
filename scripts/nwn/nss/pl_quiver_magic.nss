//Script Name: pl_quiver_magic
////////////////////////////////////////
#include "mod_funcs_inc"
#include "x2_inc_switches"
#include "pc_funcs_inc"

//Main Script
void main(){

    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    object oPC, oItem;
    int nInt, nLevel, nStack, nGold;
    string sResref;

  //Set the return value for the item event script
  // * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed script is done
  // * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
  int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

//////////////////////////////////////////////////////////////////////////////
      case X2_ITEM_EVENT_ACTIVATE:
        // * This code runs when the Unique Power property of the item is used or the item
        // * is activated. Note that this event fires for PCs only

        oPC = GetItemActivator();        // The player who activated the item
        oItem = GetItemActivated();      // The item that was activated
        nLevel = GetLocalInt(oItem, "Level");
        sResref = GetLocalString(oItem, "Resref");
        nStack = GetLocalInt(oItem, "StackSize");
        nGold = GetLocalInt(oItem, "nGold");
        if(nStack == 0) nStack = 500;

        Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Magic Quiver: %s, Resref: %s, Level: %s, Stack Size: %s, Gold: %s.",
            GetName(oItem), sResref, IntToString(nLevel), IntToString(nStack), IntToString(nGold));

        if(sResref == ""){
            SendMessageToPC(oPC, C_RED+"No arrow resref!"+C_END);
            return;
        }
        if(nLevel > GetLevelIncludingLL(oPC)){
            SendMessageToPC(oPC, C_RED+"You are not high enough level to use this item!"+C_RED);
            return;
        }
        if(nGold > 0 && nGold > GetGold(oPC)){
            SendMessageToPC(oPC, C_RED+"You need " + IntToString(nGold)+ "gp to use this item!"+C_RED);
            return;
        }

        object oArrow = CreateItemOnObject(sResref, oPC, nStack);
        SetIdentified(oArrow, TRUE);

        break;
////////////////////////////////////////////////////////////////////////////

    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

