#include "pl_ai_inc"


void SetupDrow(object oSelf){
    effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oSelf);
    object oArea = GetArea(oSelf);
    string sHouseName, sType;
    string sRightHand, sLeftHand;

    if(GetTag(oArea) == "pl_drowcity_003"){
        sHouseName = "House Aleervs";
        sType = GetStringRight(GetResRef(oSelf), 1);

        switch(StringToInt(sType)){
            case 1: //Assassin
                SetName(oSelf, sHouseName + " Assassin");
                sRightHand = "pl_drow_kama";
                sLeftHand = "pl_drow_kama";
            break;
            case 2: //Warrior
                SetName(oSelf, sHouseName + " Warrior");
                sRightHand = "pl_drow_scimdoub";
                sLeftHand = "";
            break;
            case 3: //Sharpshooter
                SetName(oSelf, sHouseName + " Sharpshoot");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 4: //Wizard
                SetName(oSelf, sHouseName + " Wizard");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 5: //Priestess
                SetName(oSelf, sHouseName + " Priestess");
                sRightHand = "";
                sLeftHand = "";
            break;
        }
    }
    else if(GetTag(oArea) == "pl_drowcity_004"){
        sHouseName = "House Do'rae";
        sType = GetStringRight(GetResRef(oSelf), 1);

        switch(StringToInt(sType)){
            case 1: //Assassin
                SetName(oSelf, sHouseName + " Assassin");
                sRightHand = "pl_drow_dagass";
                sLeftHand = "pl_drow_dagass";
            break;
            case 2: //Warrior
                SetName(oSelf, sHouseName + " Warrior");
                sRightHand = "pl_drow_swls";
                sLeftHand = "pl_drow_swls";
            break;
            case 3: //Sharpshooter
                SetName(oSelf, sHouseName + " Sharpshoot");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 4: //Wizard
                SetName(oSelf, sHouseName + " Wizard");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 5: //Priestess
                SetName(oSelf, sHouseName + " Priestess");
                sRightHand = "";
                sLeftHand = "";
            break;
        }
    }
    else if(GetTag(oArea) == "pl_drowcity_007" ||
            GetTag(oArea) == "pl_drowcity_007a"){
        sHouseName = "House Teken'rahel";
        sType = GetStringRight(GetResRef(oSelf), 1);

        switch(StringToInt(sType)){
            case 1: //Assassin
                SetName(oSelf, sHouseName + " Assassin");
                sRightHand = "pl_drow_katar";
                sLeftHand = "pl_drow_katar";
            break;
            case 2: //Warrior
                SetName(oSelf, sHouseName + " Warrior");
                sRightHand = "pl_drow_kat";
                sLeftHand = "pl_drow_kat";
            break;
            case 3: //Sharpshooter
                SetName(oSelf, sHouseName + " Sharpshoot");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 4: //Wizard
                SetName(oSelf, sHouseName + " Wizard");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 5: //Priestess
                SetName(oSelf, sHouseName + " Priestess");
                sRightHand = "";
                sLeftHand = "";
            break;
        }
    }
    else if(GetTag(oArea) == "pl_drowcity_008" ||
            GetTag(oArea) == "pl_drowcity_008a"){
        sHouseName = "House Arkenath";
        sType = GetStringRight(GetResRef(oSelf), 1);

        switch(StringToInt(sType)){
            case 1: //Assassin
                SetName(oSelf, sHouseName + " Assassin");
                sRightHand = "pl_drow_axehnd";
                sLeftHand = "pl_drow_axehnd";
            break;
            case 2: //Warrior
                SetName(oSelf, sHouseName + " Warrior");
                sRightHand = "pl_drow_rapier";
                sLeftHand = "pl_drow_rapier";
            break;
            case 3: //Sharpshooter
                SetName(oSelf, sHouseName + " Sharpshoot");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 4: //Wizard
                SetName(oSelf, sHouseName + " Wizard");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 5: //Priestess
                SetName(oSelf, sHouseName + " Priestess");
                sRightHand = "";
                sLeftHand = "";
            break;
        }
    }
    else if(GetTag(oArea) == "pl_drowcity_009" ||
            GetTag(oArea) == "pl_drowcity_010"){
        sHouseName = "Temple of Lloth";
        sType = GetStringRight(GetResRef(oSelf), 1);

        switch(StringToInt(sType)){
            case 1: //Assassin
                SetName(oSelf, sHouseName + " Assassin");
                sRightHand = "pl_drow_kat";
                sLeftHand = "pl_drow_kat";
            break;
            case 2: //Warrior
                SetName(oSelf, sHouseName + " Warrior");
                sRightHand = "pl_drow_axedbl";
                sLeftHand = "";
            break;
            case 3: //Sharpshooter
                SetName(oSelf, sHouseName + " Sharpshoot");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 4: //Wizard
                SetName(oSelf, sHouseName + " Wizard");
                sRightHand = "";
                sLeftHand = "";
            break;
            case 5: //Priestess
                SetName(oSelf, sHouseName + " Priestess");
                sRightHand = "";
                sLeftHand = "";
            break;
        }
    }

    object oRightHand = CreateItemOnObject(sRightHand, oSelf);
    object oLeftHand = CreateItemOnObject(sLeftHand, oSelf);

    ClearAllActions(TRUE);
    if(oRightHand != OBJECT_INVALID){
        SetDroppableFlag(oRightHand, FALSE);
        ActionEquipItem(oRightHand, INVENTORY_SLOT_RIGHTHAND);
    }
    if(oLeftHand != OBJECT_INVALID){
        SetDroppableFlag(oLeftHand, FALSE);
        ActionEquipItem(oLeftHand, INVENTORY_SLOT_LEFTHAND);
    }
    ActionDoCommand(SetCommandable(TRUE));
    //ActionDoCommand(DetermineCombatRound());
    SetCommandable(FALSE);

    DelayCommand(0.5f, RemoveEffect(oSelf, eInvis));
}

void main(){
    SetupDrow(OBJECT_SELF);
    PL_AIDetermineCombatRound();
    //ActionAttack(GetNearestEnemy());
    //ExecuteScript("pl_ai_9spawn", OBJECT_SELF);
}
