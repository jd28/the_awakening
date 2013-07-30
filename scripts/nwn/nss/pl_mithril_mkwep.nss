#include "item_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oWeapon;
    int nType = GetLocalInt(OBJECT_SELF, "MithrilType");
    DeleteLocalInt(OBJECT_SELF, "MithrilType");

    if(nType == 1){ // Guants
        oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
        if(oWeapon == OBJECT_INVALID){
            SpeakString("You must have Mithril Guantlets equipped.");
            return;
        }
        if(GetTag(oWeapon) != "pl_mithral_weap"){
            SpeakString("Wait, these aren't Mithril Guants.");
            return;
        }
        if(GetItemEnhancementBonus(oWeapon) > 0 ||
           GetLocalInt(oWeapon, "MithEnchanted")){
            SpeakString("You may only enchant a Mithril item once.");
            return;
        }
    }
    else{
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(oWeapon == OBJECT_INVALID){
            SpeakString("You must have Mithril Guantlets equipped.");
            return;
        }

        if(GetTag(oWeapon) != "pl_mithral_weap"){
            SpeakString("Wait, this isn't a Mithril weapon.");
            return;
        }
        if(GetItemEnhancementBonus(oWeapon) > 0 ||
           GetLocalInt(oWeapon, "MithEnchanted")){
            SpeakString("You may only enchant a Mithril item once.");
            return;
        }

    }


    if(GetGold(oPC) < 1000000){
        SpeakString("You haven't the gold.");
        return;
    }
    TakeGoldFromCreature(1000000, oPC, TRUE);

    itemproperty ip;

    int nDamage = GetLocalInt(OBJECT_SELF, "MithDam1") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d8);
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam2") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d8);
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam3") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d8);
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam4") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d8);
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam5") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d12);
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam6") - 1;
    ip = ItemPropertyDamageBonus(GetIPDamageConst(nDamage), IP_CONST_DAMAGEBONUS_2d12);
    IPSafeAddItemProperty(oWeapon, ip);

    //Enhancement Bonus
    ip = ItemPropertyEnhancementBonus(8);
    IPSafeAddItemProperty(oWeapon, ip);
    if(nType == 1){
        //Keen
        ip = ItemPropertyKeen();
        IPSafeAddItemProperty(oWeapon, ip);
        //Massive Criticals
        ip = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
        IPSafeAddItemProperty(oWeapon, ip);
    }

    SetItemCursedFlag(oWeapon, TRUE);
    SetLocalInt(oWeapon, "MithEnchanted", 1);
}
