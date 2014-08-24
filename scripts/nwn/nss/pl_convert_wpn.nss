#include "dip_func_inc"
#include "vfx_inc"
#include "x2_inc_switches"

void main(){
    object oPC = GetPCSpeaker();
    object oForge = GetNearestObjectByTag("Forge");
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE");
    string sResref;

    if(nCode == 700) // Monk Guants
        sResref = "pl_convert_gaunt";
    else
        sResref = GetWeaponResref(nCode);

    if(sResref == ""){
        SendMessageToPC(oPC, "Error no weapon resref.  Please inform a DM.");
        return;
    }

    object oOriginal = GetFirstItemInInventory(oForge);

    if(oOriginal == OBJECT_INVALID){
        SpeakString("Ye need to put a weapon in the forge!");
        return;
    }
    else if(GetNextItemInInventory(oForge) != OBJECT_INVALID){
        SpeakString("Ye can only put one weapon in the forge at a time!");
        return;
    }
    else if(!GetIsMeleeWeapon(oOriginal)){
        SpeakString("Ye can only put melee weapons and gaunts in the forge!");
        return;
    }
    else if(GetLocalInt(oOriginal, "NoConvert")){
        SpeakString("Ye can't convert this weapon!");
        return;
    }
    else if(GetItemEnhancementBonus(oOriginal) > 6){
        SpeakString("Ye can only weapons less than +6!");
        return;
    }
    else if(GetGold(oPC) < 500000){
        SpeakString("Ye ain't got the gold!");
        return;
    }

    TakeGoldFromCreature(500000, oPC, TRUE);
    SetLocked(oForge, TRUE);

    object oWeap = CreateItemOnObject(sResref, oForge, 1, "pl_convert_weap");
    SetName(oWeap, GetName(oPC)+"'s " + GetName(oWeap));

    itemproperty ipProp;
    for(ipProp = GetFirstItemProperty(oOriginal);
        GetIsItemPropertyValid(ipProp);
        ipProp = GetNextItemProperty(oOriginal))
    {
        if(GetItemPropertyDurationType(ipProp) != DURATION_TYPE_PERMANENT)
            continue;

        if(GetItemPropertyType(ipProp) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE ||
           GetItemPropertyType(ipProp) == ITEM_PROPERTY_BONUS_FEAT)
            continue;

        IPSafeAddItemProperty(oWeap, ipProp, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
    }

    ApplyVisualToObject(VFX_FNF_SOUND_BURST, oForge);
    DestroyObject(oOriginal);
    SetLocked(oForge, FALSE);
    SpeakString("There ye be.");

}
