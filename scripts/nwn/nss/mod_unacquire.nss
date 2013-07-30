//::///////////////////////////////////////////////
//:: Example XP2 OnItemUnAcquireScript
//:: x2_mod_def_unaqu
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemUnAcquire Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "mod_funcs_inc"
#include "pc_funcs_inc"
#include "pl_pvp_inc"

void main(){

    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
    object oReceiver = GetModuleItemAcquiredBy();

    Logger(oPC, "DebugModEvents", LOGLEVEL_NONE, "UNACQUIRE: Item: %s, Tag: %s, Resref: %s",
           GetName(oItem), GetTag(oItem), GetResRef(oItem));

    if(GetIsPC(oPC) && !(GetIsDM(oPC) || GetIsDMPossessed(oPC))){
        // Non-drop items are destroyed if unaquired.
        if(GetItemCursedFlag(oItem)){
            DestroyObject(oItem);
            FloatingTextStringOnCreature(C_RED+"You are unable to drop non-drop items.  The item has been destroyed."+C_END, oPC, FALSE);
        }

        if(GetHasInventory(oItem)){
            object oStorage = GetFirstItemInInventory(oItem);
            while(oStorage != OBJECT_INVALID){
                // Non-drop items are destroyed if unaquired.
                if(GetItemCursedFlag(oStorage)){
                    DestroyObject(oStorage);
                    FloatingTextStringOnCreature(C_RED+"You are unable to drop non-drop items.  The item has been destroyed."+C_END, oPC, FALSE);
                }
                oStorage = GetNextItemInInventory(oItem);
            }
        }

        //Traps
        //if(GetLocalInt(oPC,"DebugEvents")){
            if(GetSkillRank(SKILL_SET_TRAP,oPC,TRUE)>0 && GetItemHasItemProperty(oItem,ITEM_PROPERTY_TRAP)){
                object oTrapped = GetNearestTrapToObject(oPC,FALSE);
                SetTrapCreator(oTrapped, oPC);

                // Set variables trap_dc, trap_dice, trap_sides
                int nLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
                int nSetTrap = GetSkillRank(SKILL_SET_TRAP, oPC) / 2;
                if(nSetTrap > nLevel)
                    nSetTrap = nLevel;

                SetLocalInt(oTrapped, "trap_dc", nSetTrap);
                SetLocalInt(oTrapped, "trap_dice", nLevel);
                SetLocalInt(oTrapped, "trap_sides", 10);

                Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "Trap Valid: %s, Set: %s, Level: %s, DC: %s, Dice: %s, Sides: 10",
                    IntToString(GetIsObjectValid(oTrapped)), GetTag(oTrapped), IntToString(nLevel), IntToString(nSetTrap), IntToString(nSetTrap));

            }
        //}

        // -------------------------------------------------------------------------
        // Save character
        // -------------------------------------------------------------------------
        if(GetIsObjectValid(GetItemPossessor(oItem)) || GetIsLocationValid(GetLocation(oItem))){ // Filter out barters.
            if(!GetLocalInt(oPC, VAR_PC_ACQUIRE_SAVE)){
                SetLocalInt(oPC, VAR_PC_ACQUIRE_SAVE, TRUE);
                DelayCommand(ONACQUIRE_SAVE_DELAY, PCOnAcquireSave(oPC));
            }
        }

        // CODE, if oReceiver is a merchant, delete object?
    }


    // PICK OBJECT BACK UP IF YOU PUT IT ON THE GROUND
    if ((GetTag(oItem) == "pvp_team1_flag"
         && GetLocalInt(oPC, "PVP_SIDE") == PVP_TEAM_2
         && GetLocalInt(oReceiver, "PVP_SIDE") != PVP_TEAM_2) ||
        (GetTag(oItem) == "pvp_team2_flag"
         && GetLocalInt(oPC, "PVP_SIDE") == PVP_TEAM_1
         && GetLocalInt(oReceiver, "PVP_SIDE") != PVP_TEAM_1))
    {
        FloatingTextStringOnCreature("You cannot drop this item.  You can only hand it to another team member.", oPC, FALSE);
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        CreateItemOnObject(GetResRef(oItem), oPC, 1);
        return;
    }

    // * Generic Item Script Execution Code
    // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // * it will execute a script that has the same name as the item's tag
    // * inside this script you can manage scripts for all events by checking against
    // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }
} // void main()
