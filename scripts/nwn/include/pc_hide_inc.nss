#include "item_func_inc"
#include "mod_funcs_inc"
// Create Player Hide, handle subraces eventually...
object PCCreateSkin(object oPC);
void SetHideString(object oPlayer, string sVarName, string sValue);
string GetHideString(object oPlayer, string sVarName);
void DeleteHideString(object oPlayer, string sVarName);
int GetHideInt(object oPlayer, string sVarName);
void SetHideInt(object oPlayer, string sVarName, int nValue);
void DeleteHideInt(object oPlayer, string sVarName);

object PCCreateSkin(object oPC){
    object oSkin = CreateItemOnObject("pchide", oPC);
//    itemproperty ipProp;

    //Add General Class Props
/*    if(!GetLevelByClass(CLASS_TYPE_WIZARD) > 0 && // << The already have Scribe Scroll.
       (GetLevelByClass(CLASS_TYPE_SORCERER) > 0 ||
        GetLevelByClass(CLASS_TYPE_BARD) > 0 ||
        GetLevelByClass(CLASS_TYPE_CLERIC) > 0 ||
        GetLevelByClass(CLASS_TYPE_DRUID)))
    {
*/
//        ipProp = ItemPropertyBonusFeat(IP_CONST_FEAT_SCRIBE_SCROLL);
//        IPSafeAddItemProperty(oSkin, ipProp);
//    }

    return oSkin;
}

void DeleteHideString(object oPlayer, string sVarName){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return;
    }
    DeleteLocalString(oHide, sVarName);
}

void SetHideString(object oPlayer, string sVarName, string sValue){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return;
    }
    SetLocalString(oHide, sVarName, sValue);
}
string GetHideString(object oPlayer, string sVarName){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return "";
    }

    return GetLocalString(oHide, sVarName);
}
int GetHideInt(object oPlayer, string sVarName){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return -1;
    }
    return GetLocalInt(oHide, sVarName);
}
void SetHideInt(object oPlayer, string sVarName, int nValue){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return;
    }
    SetLocalInt(oHide, sVarName, nValue);
}
void DeleteHideInt(object oPlayer, string sVarName){
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPlayer);
    if(!GetIsObjectValid(oHide)){
        Logger(oPlayer, VAR_DEBUG_LOGS, LOGLEVEL_NONE, "No hide!!");
        return;
    }
    DeleteLocalInt(oHide, sVarName);
}
