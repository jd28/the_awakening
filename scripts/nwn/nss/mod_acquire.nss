//::///////////////////////////////////////////////
//:: Example XP2 OnItemAcquireScript
//:: x2_mod_def_aqu
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemAcquire Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "item_func_inc"
#include "mod_funcs_inc"
#include "pc_funcs_inc"
#include "pl_pcinvo_inc"
#include "srv_funcs_inc"
#include "pc_persist"

void SetReturning(){
    SetIsDestroyable(FALSE);
}

void FixItem(object oItem){
    string sTag = GetTag(oItem);
    if(sTag == "pl_convert_gaunt"){ //Dedlock Staff
        IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, DURATION_TYPE_PERMANENT);
    }
    else if (sTag == "nr_drowslave_sh"){
        SetLocalString(oItem, "ilr_tagged", "pl_drow_slaver");
    }
}

void TooManyItems(object oPC, object oItem){
    string sResref = GetResRef(oItem);
    SetPlotFlag(oItem, FALSE);
    DestroyObject(oItem);
    DelayCommand(1.0, ObjectToVoid(CreateObject(OBJECT_TYPE_ITEM, sResref, GetLocation(oPC))));
}

void main(){

    object oPC     = GetModuleItemAcquiredBy();
    object oItem   = GetModuleItemAcquired();
    object oSource = GetModuleItemAcquiredFrom();
    int bDrop      = FALSE;

    Logger(oPC, "DebugModEvents", LOGLEVEL_NONE, "ACQUIRE: Item: %s, Tag: %s, Resref: %s",
           GetName(oItem), GetTag(oItem), GetResRef(oItem));

    if(GetStringLeft(GetTag(oPC), 7) == "SDCLONE" &&
       GetBaseItemType(oItem) == BASE_ITEM_POTIONS){
        DestroyObject(oItem);
        return;
    }

    //PC Stuff
    if(GetIsPC(oPC) && !(GetIsDM(oPC) || GetIsDMPossessed(oPC))){
        // Kill variables.
        if(VerifyAdminKey(oSource) || VerifyDMKey(oSource)){
            string tag = GetLocalString(oItem, VAR_ILR_TAGGED);
            if(tag != "" && GetIsDM(oSource)){
                SetPersistantInt(oPC, "killtag:"+tag, 1);
                SendMessageToPC(oPC, C_GREEN+"You have received the necessary kill to use "
                                + GetName(oItem));
                SendMessageToPC(oSource, C_GREEN+GetName(oPC)+" has received the necessary kill to use "
                                + GetName(oItem));
                Logger(oPC, "DebugModEvents", LOGLEVEL_NOTICE, "ACQUIRE: Kill Given. DM: %s PC: %s Player: %s Item: %s",
                    GetName(oSource), GetName(oPC), GetPCPlayerName(oPC), GetName(oItem));
            }
        }

        // ---------------------------------------------------------------------
        // Remove all temporary effects when an item is aquired.
        // ---------------------------------------------------------------------
        IPRemoveAllItemProperties(oItem, DURATION_TYPE_TEMPORARY);
        RemoveOnHitSpell(oItem, SPELL_DARKFIRE);
        RemoveOnHitSpell(oItem, SPELL_FLAME_WEAPON);
        RemoveOnHitSpell(oItem, SPELL_BLADE_THIRST);

        DelayCommand(1.0f, FixItem(oItem));

        // ---------------------------------------------------------------------
        // Loot Notification.
        // ---------------------------------------------------------------------

        // ---------------------------------------------------------------------
        // Save character
        // ---------------------------------------------------------------------
        if(!GetLocalInt(oPC, VAR_PC_ACQUIRE_SAVE)){
            SetLocalInt(oPC, VAR_PC_ACQUIRE_SAVE, TRUE);
            DelayCommand(ONACQUIRE_SAVE_DELAY, PCOnAcquireSave(oPC));
        }

        string sTag = GetLocalString(oItem, "pc_tag");
        if(sTag != "" && sTag != GetTag(oPC)){
            bDrop = TRUE;
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, TooManyItems(oPC, oItem));
            AssignCommand(oPC, SetCommandable(FALSE));
            DelayCommand(2.0f, AssignCommand(oPC, SetCommandable(TRUE)));
            ErrorMessage(oPC, "This item does not belong to you!");
            return;
        }

        // ---------------------------------------------------------------------
        //CODE for item restrictions...
        // ---------------------------------------------------------------------
        int nLimit = GetLocalInt(oItem, VAR_ILR_ONLY_ONE);
        if(nLimit > 0 && CountItemByTag(oPC, GetTag(oItem)) > nLimit){
            bDrop = TRUE;
            AssignCommand(oPC, ClearAllActions());
            AssignCommand(oPC, TooManyItems(oPC, oItem));
            AssignCommand(oPC, SetCommandable(FALSE));
            DelayCommand(2.0f, AssignCommand(oPC, SetCommandable(TRUE)));
            ErrorMessage(oPC, "Only " + IntToString(nLimit) + " "+ GetName(oItem) + "(s) may be in your possession.");
            return;
        }
        if(!bDrop && GetLocalInt(oItem, "NoDrop") && GetIsObjectValid(GetItemPossessor(oItem))){
            DelayCommand(5.0, SetItemCursedFlag(oItem, TRUE));
        }
        if(GetLocalInt(oItem, "NoDestroy") && GetIsObjectValid(GetItemPossessor(oItem))){
            AssignCommand(oItem, SetIsDestroyable(FALSE));
        }
        if(GetIsTestCharacter(oPC))
            DelayCommand(5.0, SetItemCursedFlag(oItem, TRUE));

    }



    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE){
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END){
           return;
        }
     }
} // void main()
