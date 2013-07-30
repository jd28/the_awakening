#include "pc_funcs_inc"
#include "x2_inc_switches"


void main(){

    object oCaster = OBJECT_SELF;
    object oWeapon = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();

    int nEvent = GetUserDefinedItemEventNumber();
    if(GetLocalInt(oCaster, "Delay") || nEvent != X2_ITEM_EVENT_ONHITCAST)
        return;

    object oTargetWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    if(GetIsObjectValid(oTargetWeapon) && d100() > 85){
        ForceUnequipItem(oTarget, oTargetWeapon, FALSE);
        ErrorMessage(oTarget, "You have been disarmed!");
    }

    SetLocalInt(oCaster, "Delay", 1);
    DelayCommand(IntToFloat(6 + d6()), DeleteLocalInt(oCaster, "Delay"));
}
