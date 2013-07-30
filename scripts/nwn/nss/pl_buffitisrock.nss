//Script Name: buffitisrock
////////////////////////////////////////
#include "mod_funcs_inc"
#include "x2_inc_switches"

//Main Script
void main(){

    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    object oPC;                                   //The player character using the item
    object oItem;                                //The item being used
    object oSpellOrigin;                        //The origin of the spell
    object oSpellTarget;                       //The target of the spell
    int iSpell;                               //The Spell ID number
    int nMeta = GetMetaMagicFeat();
    object oTarget;     //Define oTarget below
    object oObject;     //Define oObject below
    int nInt;           //Often used for visual effects (define below)
    int nLvl;           //Often used to define user or target's level (HD
  //Set the return value for the item event script
  // * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed script is done
  // * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
  int nResult = X2_EXECUTE_SCRIPT_END;

  int bSuccess = FALSE;
  int nNumSpells, nHostile, nNumberOfTriggers;
  int i;

    switch (nEvent){

//////////////////////////////////////////////////////////////////////////////
      case X2_ITEM_EVENT_ACTIVATE:
        // * This code runs when the Unique Power property of the item is used or the item
        // * is activated. Note that this event fires for PCs only

        oPC = GetItemActivator();        // The player who activated the item
        oItem = GetItemActivated();      // The item that was activated
        oTarget = GetItemActivatedTarget();

        nNumSpells = GetLocalInt(oItem, VAR_BUFF_ROCK_NUM_SPELLS);

        if(nNumSpells > 0){
            if(!GetLocalInt(oItem, "PL_BUFF_COMBAT") && GetIsInCombat(oPC)){
                FloatingTextStringOnCreature(C_RED+"You cannot use this item in combat!"+C_END, oPC, FALSE);
                return;
            }

            AssignCommand(oPC, ClearAllActions());
            for (i = 1; i <= nNumSpells; i++){
                iSpell = GetLocalInt(oItem, VAR_BUFF_ROCK_SPELL + IntToString(i));
                nMeta = GetLocalInt(oItem, VAR_BUFF_ROCK_META + IntToString(i));
                if (iSpell > 0){
                    bSuccess = TRUE;
                    iSpell--; // I added +1 to the spellID when the sequencer was created, so I have to remove it here

                    SetLocalInt(oPC, "PL_BUFFITIS_META_" + IntToString(iSpell), nMeta);
                    AssignCommand(oPC, ActionCastSpellAtObject(iSpell, oPC, nMeta, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                }
            }
            if (!bSuccess) FloatingTextStrRefOnCreature(83886,OBJECT_SELF); // no spells stored
        }
        else FloatingTextStrRefOnCreature(83886,OBJECT_SELF); // no spells stored
        break;
////////////////////////////////////////////////////////////////////////////

    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

