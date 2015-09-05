//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_equ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnEquip Event
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
#include "pc_funcs_inc"
#include "pl_pcstyle_inc"
#include "pl_pcinvo_inc"
#include "info_inc"
#include "x0_i0_spells"
#include "nwnx_inc"

// -----------------------------------------------------------------------------
//  PROTOTYPES - Item Level Restrictions
// -----------------------------------------------------------------------------

void ApplyFeatSuperNaturalEffectsOnEquip(object oPC, object oItem){
    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) >= 40 && GetIsMeleeWeapon(oItem))
        AddDmgBonusToWeapon(oItem, 18000.0f, CEP_IP_CONST_DAMAGEBONUS_3d6, DAMAGE_TYPE_FIRE);

}

void main(){

    object oItem = GetPCItemLastEquipped();
    object oPC   = GetPCItemLastEquippedBy();
    int bUnequip = FALSE;
    int nBase = GetBaseItemType(oItem);

    Logger(oPC, "DebugModEvents", LOGLEVEL_DEBUG, "EQUIP: Item: %s, Tag: %s, Resref: %s",
           GetName(oItem), GetTag(oItem), GetResRef(oItem));

    // -------------------------------------------------------------------------
    // Item Level Restrictions.
    // -------------------------------------------------------------------------
    if(GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)
            && !GetIsTestCharacter(oPC) && GetisILRItem(oItem))
        bUnequip = CheckILR(oPC, oItem);

    if((IPGetWeaponEnhancementBonus(oItem, ITEM_PROPERTY_ATTACK_BONUS) == 2 ||
        IPGetWeaponEnhancementBonus(oItem) == 2)
       && GetGoldPieceValue(oItem) > 400000)
    {
        ErrorMessage(oPC, "Sorry this weapon is not valid, if you believe it is contact a DM."
                          + "  If you used One Up to skirt the item level restrictions, then "
                          + "please dispose of the item.");
        bUnequip = TRUE;
    }

    if(!CheckStyleItemRequirement(oPC, oItem))
        bUnequip = TRUE;

    if(bUnequip){
        DelayCommand(0.5f, ForceUnequipItem(oPC, oItem));
        return;
    }

    // Super Natural Effects.
    ApplyFeatSuperNaturalEffectsOnEquip(oPC, oItem);

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
            return;
        }
    }

    // 3.0.6.3 - Added fix by MetaPhaze
    if(!GetHasEffect(EFFECT_TYPE_POLYMORPH, GetPCItemLastEquippedBy())) return;
}
