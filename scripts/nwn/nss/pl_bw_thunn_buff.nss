#include "item_func_inc"
#include "vfx_inc"
void main(){
    int NCode = GetLocalInt(OBJECT_SELF,"MODCODE"), nBaseAC, nGold;
    object oBuff, oPC = GetPCSpeaker();
    itemproperty ipProp;

    nGold = 10000000;
    oBuff = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if(!GetIsObjectValid(oBuff)){
        SendMessageToPC(oPC, C_RED+"Ye're not wearin any armor!"+C_END);
        return;
    }
    if(GetItemEnhancementBonus(oBuff) < 5){
        SendMessageToPC(oPC, C_RED+"Ye got be wearin +5 er better to get this buff!"+C_END);
        return;
    }
    if(GetGold(oPC) < nGold){
        SpeakString("Ye don't have enough the gold!");
        return;
    }
    ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
    TakeGoldFromCreature(nGold, oPC, TRUE);
    ipProp = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6, IP_CONST_DAMAGESOAK_15_HP);
    IPSafeAddItemProperty(oBuff, ipProp);
}
