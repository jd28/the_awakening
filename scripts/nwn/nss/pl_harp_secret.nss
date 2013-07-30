#include "pc_funcs_inc"
#include "info_inc"

void main(){

    object oPC      = GetPCSpeaker();
    object oConv    = GetLocalObject(oPC, "ITEM_TALK_TO");
    string sTag     = GetTag(oConv);
    string sStyle   = "";
    int nCode       = GetLocalInt(oPC, "MODCODE");
    int nHarper     = GetLevelByClass(CLASS_TYPE_HARPER, oPC);
    int bSuccess    = FALSE;
    int nLevel      = -1;
    DeleteLocalObject(oPC, "PL_CONV_WITH");
    DeleteLocalInt(oPC, "MODCODE");
    int nSecret, nFeat;


    if(sTag == "pl_harper_1"){
        nSecret = 1;
        nLevel  = 26;
        switch(nCode){
            case 100: nFeat = FEAT_EVASION; break;
            case 200: nFeat = FEAT_SKILL_MASTERY; break;
            case 300: nFeat = FEAT_SLIPPERY_MIND; break;
        }
    }
    else if(sTag == "pl_harper_2"){
        nSecret = 2;
        nLevel  = 29;
        switch(nCode){
            case 100: nFeat = FEAT_EVASION; break;
            case 200: nFeat = FEAT_SKILL_MASTERY; break;
            case 300: nFeat = FEAT_SLIPPERY_MIND; break;
            case 400: nFeat = FEAT_EPIC_BANE_OF_ENEMIES; break;
            case 500: nFeat = FEAT_EPIC_DODGE; break;
        }
    }

    if (nSecret == GetPlayerInt(oPC, "pc_harp_secret")){
        ErrorMessage(oPC, "It seems you have already used this Harper Secrect!");
        return;
    }

    if(nLevel != nHarper){
        ErrorMessage(oPC, "You can use this ONLY during your " + IntToString(nLevel) + "th Master Harper level!");
        return;
    }

    if(GetKnowsFeat(nFeat, oPC)){
        ErrorMessage(oPC, "You already know this feat!  Please select another!");
        return;
    }

    SuccessMessage(oPC, "You have received "+GetFeatName(nFeat)+"!");
    SetPlayerInt(oPC, "pc_harp_secret", nSecret);
    AddKnownFeat (oPC, nFeat, GetHitDice(oPC));

    SetPlotFlag(oConv, FALSE);
    AssignCommand(oConv, SetIsDestroyable(TRUE));
    DestroyObject(oConv, 0.2);
    DestroyObject(oConv);
}

