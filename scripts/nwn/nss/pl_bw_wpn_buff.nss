#include "item_func_inc"
#include "vfx_inc"

void main(){
    int NCode = GetLocalInt(OBJECT_SELF,"MODCODE"), nBaseAC, nGold;
    object oBuff, oPC = GetPCSpeaker();
    itemproperty ipProp;
    string sGold = "You ain't gold enough for that!";

    switch(NCode / 10){
        case 0: // Weapons
            nGold = 5000000;
            oBuff = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
            if(!GetIsObjectValid(oBuff))
                oBuff = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);

            nBaseAC = GetBaseArmorACBonus(oBuff);
            switch(NCode % 10){
                case 1: // Keen
                    if(!GetIsObjectValid(oBuff)){
                        SendMessageToPC(oPC, C_RED+"You haven't got a melee or ranged weapon equipped!"+C_END);
                        return;
                    }
                    if(GetGold(oPC) < nGold){
                        SpeakString(sGold);
                        return;
                    }
                    ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
                    TakeGoldFromCreature(nGold, oPC, TRUE);
                    ipProp = ItemPropertyKeen();
                    IPSafeAddItemProperty(oBuff, ipProp);
                break;
                case 2: // Massive Criticals 2d8
                    if(!GetIsObjectValid(oBuff)){
                        SendMessageToPC(oPC, C_RED+"You haven't got a melee or ranged weapon equipped!"+C_END);
                        return;
                    }
                    if(GetGold(oPC) < nGold){
                        SpeakString(sGold);
                        return;
                    }
                    ApplyVisualToObject(VFX_IMP_GOOD_HELP, oPC);
                    TakeGoldFromCreature(nGold, oPC, TRUE);
                    ipProp = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
                    IPSafeAddItemProperty(oBuff, ipProp);
                break;

            }
        break;
        /*
        case 1: //Bladed
            switch(NCode % 10)
            {
                case 1: sResref = "nw_wswbs001"; break;
                case 2: sResref = "nw_wswdg001"; break;
                case 3: sResref = "nw_wswgs001"; break;
                case 4: sResref = "nw_wswka001"; break;
                case 5: sResref = "nw_wswls001"; break;
                case 6: sResref = "nw_wswrp001"; break;
                case 7: sResref = "nw_wswsc001"; break;
                case 8: sResref = "nw_wswss001"; break;
            }
        break;
        */
    }
}
