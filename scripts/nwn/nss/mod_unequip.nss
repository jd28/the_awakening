//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 15th, 2008
//:: Added Support for Mounted Archery Feat penalties
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "mod_funcs_inc"
#include "gsp_func_inc"

void RemoveFeatSuperNaturalEffectsOnUnequip(object oPC, object oItem){
    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) >= 40 && GetIsMeleeWeapon(oItem))
        IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY);
}


void main(){

    object oItem = GetPCItemLastUnequipped();
    object oPC   = GetPCItemLastUnequippedBy();

    if (!GetIsPC(oPC)) return;

    Logger(oPC, "DebugModEvents", LOGLEVEL_NONE, "UNEQUIP: Item: %s, Tag: %s, Resref: %s",
           GetName(oItem), GetTag(oItem), GetResRef(oItem));

    // -------------------------------------------------------------------------
    // Weapon swap exploit fix
    // -------------------------------------------------------------------------
    if(GetIsInCombat(oPC)){
        if(GetBaseItemType(oItem) != BASE_ITEM_AMULET  &&
            GetBaseItemType(oItem) != BASE_ITEM_ARROW  &&
            GetBaseItemType(oItem) != BASE_ITEM_BELT   &&
            GetBaseItemType(oItem) != BASE_ITEM_BOLT   &&
            GetBaseItemType(oItem) != BASE_ITEM_BOOTS  &&
            GetBaseItemType(oItem) != BASE_ITEM_BRACER &&
            GetBaseItemType(oItem) != BASE_ITEM_CLOAK  &&
            GetBaseItemType(oItem) != BASE_ITEM_HELMET &&
            GetBaseItemType(oItem) != BASE_ITEM_BULLET &&
            GetBaseItemType(oItem) != BASE_ITEM_RING){

            effect eMiss = EffectMissChance(100);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMiss, oPC, 1.5);
        }
    }

    if(GetLocalInt(oItem, "RemoveSpellEffect")){
        RemoveEffectsOfSpells(oPC, GetLocalInt(oItem, "RemoveSpellEffect") - 1);
    }

    RemoveFeatSuperNaturalEffectsOnUnequip(oPC, oItem);

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
    }
}
