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

    if(GetIsMeleeWeapon(oTarget) || GetIsRangedWeapon2(oTarget)){
        if(GetResRef(oItem) == "pl_no_ilr_weap"){
            SetLocalInt(oTarget, "ilr_off", 1);
            SetItemCursedFlag(oTarget, TRUE);
            SendMessageToPC(oPC, C_GREEN+"Your item no longer has item level restrictions.  It is now non-transferable"+C_END);
        }
        else if (GetLocalInt(oItem, "HolyAvenger")){
            IPSafeAddItemProperty(oTarget, ItemPropertyHolyAvenger());
            IPSafeAddItemProperty(oTarget, ItemPropertyLimitUseByClass(CLASS_TYPE_BLACKGUARD));
            IPSafeAddItemProperty(oTarget, ItemPropertyLimitUseByClass(CLASS_TYPE_PALADIN));
        }
        else
            ApplyLocalsToWeapon(oItem, oTarget, OBJECT_INVALID, OBJECT_INVALID);

        AssignCommand(oItem, SetIsDestroyable(TRUE));
        DestroyObject(oItem, 0.2);

        ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
    }
    else{
        FloatingTextStringOnCreature(C_RED+"This item may only be used on a melee weapon!"+C_END, oPC, FALSE);
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


