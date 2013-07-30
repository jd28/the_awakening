#include "item_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);

    if(oWeapon == OBJECT_INVALID){
        SpeakString("You must have Mithril Guantlets equipped.");
        return;
    }

    if(GetGold(oPC) < 1000000){
        SpeakString("You haven't the gold.");
        return;
    }
    if(GetTag(oWeapon) != "pl_mithral_weap"){
        SpeakString("Wait, these aren't Mithril Guants.");
        return;
    }

    TakeGoldFromCreature(1000000, oPC, TRUE);

    itemproperty ip;

    int nDamage = GetLocalInt(OBJECT_SELF, "MithDam1") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d8, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam2") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d8, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam3") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d8, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam4") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d8, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam5") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d12, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam6") - 1;
    ip = ItemPropertyDamageBonus(IP_CONST_DAMAGEBONUS_2d12, GetIPDamageConst(nDamage));
    IPSafeAddItemProperty(oWeapon, ip);

    //Keen
    ip = ItemPropertyKeen();
    IPSafeAddItemProperty(oWeapon, ip);

    //Massive Criticals
    ip = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
    IPSafeAddItemProperty(oWeapon, ip);

}
