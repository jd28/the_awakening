#include "pl_pcstyle_inc"

// TODO: Requirements met code.

void main(){

    object oPC      = GetPCSpeaker();
    object oConv    = GetLocalObject(oPC, "ITEM_TALK_TO");
    string sTag     = GetTag(oConv);
    string sStyle   = "";
    int nCode       = GetLocalInt(oPC, "MODCODE");
    int bSuccess    = FALSE;
    int bEnhanced   = GetPlayerInt(oPC, "pc_enhanced");
    int bAppear     = FALSE;
    DeleteLocalObject(oPC, "PL_CONV_WITH");
    DeleteLocalInt(oPC, "MODCODE");

    if(sTag == "pl_style_fighter"){
        switch(nCode){
            case 100:       // Fencer
                sStyle = "master of the Fencing Style";
                SetFightingStyle(oPC, STYLE_FIGHTER_FENCER);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_FENCER, oPC);
                bSuccess = TRUE;
            break;
            case 200:       // Kensei
                sStyle = "master of the Kensei Style";
                SetFightingStyle(oPC, STYLE_FIGHTER_KENSEI);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_KENSEI, oPC);
                bSuccess = TRUE;
            break;
            case 300:       // Spartan
                sStyle = "master of the Spartan Style";
                SetFightingStyle(oPC, STYLE_FIGHTER_SPARTAN);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_SPARTAN, oPC);
                bSuccess = TRUE;
            break;
            case 400:       // Warlord
                sStyle = "master of the Warlord Style";
                SetFightingStyle(oPC, STYLE_FIGHTER_WARLORD);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_WARLORD, oPC);
                bSuccess = TRUE;
            break;
        }
    }
    else if(sTag == "pl_style_monk"){
        switch(nCode){
            case 100:       // Bear Claw
                sStyle = "disciple of the Bear Claw";
                SetFightingStyle(oPC, STYLE_MONK_BEAR_CLAW);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_BEAR_CLAW, oPC);
                bSuccess = TRUE;
            break;
            case 200:       // Dragon Palm
                sStyle = "disciple of the Dragon Palm";
                SetFightingStyle(oPC, STYLE_MONK_DRAGON_PALM);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_DRAGON_PALM, oPC);
                bSuccess = TRUE;
            break;
            case 300:       // Sun Fist
                sStyle = "disciple of the Sun Fist";
                SetFightingStyle(oPC, STYLE_MONK_SUN_FIST);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_SUN_FIST, oPC);
                bSuccess = TRUE;
            break;
            case 400:       // Tiger Fang
                sStyle = "disciple of the Tiger Fang";
                SetFightingStyle(oPC, STYLE_MONK_TIGER_FANG);
                if(bEnhanced)
                    SetPhenoType(PHENOTYPE_TIGER_FANG, oPC);
                bSuccess = TRUE;
            break;
        }
    }
    else if(sTag == "pl_style_undead"){
        nCode = GetLocalInt(oPC, "CON_CYCLE_CURRENT");
        nCode = GetUndeadStyleAppearance(nCode);
    
        if(nCode >= 0){
            SetCreatureAppearanceType(oPC, nCode);
            bSuccess = TRUE;
            bAppear  = TRUE;
        }
    }
    else if(sTag == "pl_style_ninja"){
        if(!GetMeetsStyleRequirement(oPC, STYLE_ASSASSIN_NINJA)){
            ErrorMessage(oPC, "You do not meet the requirements for this style.");
            return;
        }
            
        sStyle = "follower of the Way of the Ninja";
        SetFightingStyle(oPC, STYLE_ASSASSIN_NINJA);
        if(bEnhanced)
            SetPhenoType(PHENOTYPE_NINJA, oPC);
        bSuccess = TRUE;
    }
    else if(sTag == "pl_style_dragon"){
        switch(nCode){
            case 300:   // Acid - Green
                sStyle = "Green Dragon Disciple";
                SetCreatureAppearanceType(oPC, 1039);
                SetCreatureWingType(34, oPC);
                SetDragonDiscipleStyle(oPC, STYLE_DRAGON_GREEN);
                bSuccess = TRUE;
                bAppear  = TRUE;
            break;
            case 100:   // Cold - Blue 
                sStyle = "Blue Dragon Disciple";
                SetCreatureAppearanceType(oPC, 1037);
                SetCreatureWingType(35, oPC);
                SetDragonDiscipleStyle(oPC, STYLE_DRAGON_BLUE);
                bSuccess = TRUE;
                bAppear  = TRUE;
            break;
            case 200:   // Electrical - Brass
                sStyle = "Brass Dragon Disciple";
                SetCreatureAppearanceType(oPC, 1081);
                SetCreatureWingType(36, oPC);
                SetDragonDiscipleStyle(oPC, STYLE_DRAGON_BRASS);
                bSuccess = TRUE;
                bAppear  = TRUE;
            break;
            case 500:   // Fire - Red
                sStyle = "Red Dragon Disciple";
                SetCreatureAppearanceType(oPC, 1033);
                SetCreatureWingType(4, oPC);
                SetDragonDiscipleStyle(oPC, STYLE_DRAGON_RED);
                bSuccess = TRUE;
                bAppear  = TRUE;
            break;
            case 400:   // Sonic - Gold
                sStyle = "Gold Dragon Disciple";
                SetCreatureAppearanceType(oPC, 1086);
                SetCreatureWingType(39, oPC);
                SetDragonDiscipleStyle(oPC, STYLE_DRAGON_GOLD);
                bSuccess = TRUE;
                bAppear  = TRUE;
            break;
        }
    }

    Logger(oPC, "DebugStyles", LOGLEVEL_DEBUG, "Tag: %s, nCode: %s, Age: %s, Appearance: %s, Phenotype: %s, Success: %s",
           sTag, IntToString(nCode), IntToString(GetAge(oPC)), IntToString(GetAppearanceType(oPC)),
           IntToString(GetPhenoType(oPC)), IntToString(bSuccess));

    if(bSuccess){
        string sMsg = "You are now a " + sStyle + "!";
        if(bEnhanced){
            sMsg += "  Remember you are able to turn of the new animations with the command !opt anims off.  Or in the case of appearances !opt appear off.";
        }
        if(bAppear)
            SetPlayerInt(oPC, "pc_no_appear_change", bAppear);

        SuccessMessage(oPC, sMsg);
        SetPlotFlag(oConv, FALSE);
        AssignCommand(oConv, SetIsDestroyable(TRUE));
        DestroyObject(oConv, 0.2);
        DestroyObject(oConv);
    }
    else{
        ErrorMessage(oPC, "Something terrible must have happened.  Please post a bug report or inform a DM.");
    }
}
