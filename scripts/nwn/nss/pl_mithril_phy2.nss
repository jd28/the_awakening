#include "nwnx_inc"
#include "info_inc"

void main(){
    int nNode = GetSelectedNodeID(), nDamType;
    switch(nNode){
        case 0: nDamType = DAMAGE_TYPE_BLUDGEONING; break;
        case 1: nDamType = DAMAGE_TYPE_PIERCING; break;
        case 2: nDamType = DAMAGE_TYPE_SLASHING; break;
    }
    SetLocalInt(OBJECT_SELF, "MithDam6", nDamType+1);

    string sWeapon;
    int i = 1, nDamage;

    nDamage = GetLocalInt(OBJECT_SELF, "MithDam1");
    sWeapon = "2d8 of " + GetDamageTypeName(nDamage-1) +"\n";
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam2");
    sWeapon += "2d8 of " + GetDamageTypeName(nDamage-1) +"\n";
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam3");
    sWeapon += "2d8 of " + GetDamageTypeName(nDamage-1) +"\n";
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam4");
    sWeapon += "2d8 of " + GetDamageTypeName(nDamage-1) +"\n";
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam5");
    sWeapon += "2d12 of " + GetDamageTypeName(nDamage-1) +"\n";
    nDamage = GetLocalInt(OBJECT_SELF, "MithDam6");
    sWeapon += "2d12 of " + GetDamageTypeName(nDamage-1) +"\n";

    SetCustomToken(7777, sWeapon);
}
