////////////////////////////////////////
#include "mod_funcs_inc"
#include "x2_inc_switches"
#include "dip_func_inc"
#include "vfx_inc"

//Main Script
void main(){

    int nEvent = GetUserDefinedItemEventNumber();
    object oPC = GetItemActivator(), oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();

    //Set the return value for the item event script
    // * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed script is done
    // * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
    int nResult = X2_EXECUTE_SCRIPT_END;
    if(nEvent != X2_ITEM_EVENT_ACTIVATE) return;

	int type = GetLocalInt(oItem, "PL_ENCHANT_TYPE") - 1;

    if(GetIsMeleeWeapon(oTarget)){
        FloatingTextStringOnCreature(C_RED+"This item may not be used on weapons!"+C_END, oPC, FALSE);
    }
	else if(type > 0 && type != GetBaseItemType(oTarget)) {
        FloatingTextStringOnCreature(C_RED+"This item may not be used on item type!  See description for details."+C_END, oPC, FALSE);
	}
    else{
        ApplyLocalsToItem(oItem, oTarget, OBJECT_INVALID, OBJECT_INVALID);
        AssignCommand(oItem, SetIsDestroyable(TRUE));
        DestroyObject(oItem, 0.2);
        ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


