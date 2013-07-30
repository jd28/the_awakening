#include "dip_func_inc"
#include "x2_inc_switches"

void main(){

    object oPC = GetPCSpeaker(), oWeap;
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE");
    string sResref;

    if(nCode == 700) // Monk Guants
        sResref = "pl_mithral_guants";
    else
        sResref = GetWeaponResref(nCode);

    if(sResref == ""){
        SendMessageToPC(oPC, "Error no weapon resref.  Please inform a DM.");
        return;
    }

    // Take Mithral Ore
    object oMithril = GetItemPossessedBy(oPC, "ms_sv_mithril");
    if(oMithril == OBJECT_INVALID){
        SpeakString("Ye ain't got any mithril ore!");
        return;
    }
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        if(GetTag(oItem) == "ms_sv_mithril"){
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem, 0.2);
        }
        oItem = GetNextItemInInventory(oPC);
    }

    if(nCode >= 800 && nCode < 900){
        switch(nCode % 100){
            case 0: sResref = "pl_mithquiv_arr"; break; // Arrows
            case 1: sResref = "pl_mithquiv_bolt"; break; // Bolts
            case 2: sResref = "pl_mithquiv_bull"; break; // Bullets
            case 3: sResref = "pl_mithquiv_dart"; break; // Darts
            case 4: sResref = "pl_mithquiv_shu"; break; // Shurikens
            case 5: sResref = "pl_mithquiv_axt"; break; // Throwing Axes
        }
        oWeap = CreateItemOnObject(sResref, oPC);
    }
    else{
        oWeap = CreateItemOnObject(sResref, oPC, 1, "pl_mithral_weap");
        SetName(oWeap, "Mithril " + GetName(oWeap));
    }

    SetItemCursedFlag(oWeap, TRUE);
    //else
    //    ApplyLocalsToWeapon(OBJECT_SELF, oWeap, OBJECT_INVALID, OBJECT_INVALID);

    //DeleteLocalInt(oPC, GetTag(OBJECT_SELF));
}
