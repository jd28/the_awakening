// tall_start_dlg
//
// Description: 
//
// Credits: Code originally derived from Higher Ground Legendary Leveler by FunkySwerve.  <LINK>

#include "pl_dlg_include_i"
#include "pl_pclevel_inc"
#include "x2_inc_switches"

// This script fires off the leveling conversation, if the PC meets certain requirements.
// It goes onused of a placeable.
void main() {
    int nEvent      = GetUserDefinedItemEventNumber();
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	int level       = GetLevelIncludingLL(oPC);
	int xp          = GetXPNeededForNextLevel(oPC);
    int nResult     = X2_EXECUTE_SCRIPT_END;

    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    ExportSingleCharacter(oPC); //save the character here for future Leto edits

    //Check level
    if(level == 60){
        ErrorMessage(oPC, "You are already level 60 and cannot advance any further.");
    }
    else if(level < 40){
        ErrorMessage(oPC, "You must be level 40 to gain legendary levels.");
    }
	else if(xp > 0){
		ErrorMessage(oPC, "You still need " + IntToString(xp) + " experience points before you can gain another level.");	
	}
	else if(GetCanGainLL(oPC)) {
		// Force rest, so we remove, effects, polymorphs, replenish spent feats...if still necessary.
		ForceRest(oPC);
		
		// Initialize LL local ints.
		LegendaryLevelLoad(oPC);

     	// Start up the LL conversation.
        StartDlg( oPC, oItem, "tall2_dlg_levele", TRUE, FALSE );
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
