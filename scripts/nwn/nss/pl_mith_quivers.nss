#include "pl_pcinvo_inc"

void main(){
    object oPC = GetPCSpeaker(), oQuiver;
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE");
    int nGold = 1000000;
    string sResref;

    //SpeakString("Code: " + IntToString(nCode) +", Resref: "+ sResref+", Gold: " + IntToString(nGold) );

    if(GetGold(oPC) > nGold){
        switch(nCode){
            case 0:
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_arr");
                sResref = "pl_mithril_arrow";
            break; // Arrows
            case 1: sResref = "pl_mithril_bolt";
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_bolt");
            break; // Bolts
            case 2: sResref = "pl_mithril_bulle";
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_bull");
            break; // Bullets
            case 3: sResref = "pl_mithril_dart";
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_dart");
            break; // Darts
            case 4: sResref = "pl_mithril_shuri";
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_shu");
            break; // Shurikens
            case 5: sResref = "pl_mithril_axthr";
                oQuiver = GetItemPossessedBy(oPC, "pl_mithquiv_axt");
            break; // Throwing Axes
        }
        if(oQuiver == OBJECT_INVALID){
            SpeakString("You don't have any magical mithril ammunition makers.");
            return;
        }

        TakeGoldFromCreature(nGold, oPC, TRUE);
        SetTag(oQuiver, "pl_quiver_magic");
        SetLocalString(oQuiver, "Resref", sResref);
        SetLocalInt(oQuiver, "StackSize", 300);
    }
    else{
        SpeakString("You haven't got "+IntToString(nGold)+" gold!");
    }

}
