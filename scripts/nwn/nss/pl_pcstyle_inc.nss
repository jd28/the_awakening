#include "pl_pcinvo_inc"

int CheckStyleItemRequirement(object oPC, object oItem);
int GetDragonDiscipleStyle(object oPC);
int GetFightingStyle(object oPC);
int GetMeetsStyleRequirement(object oPC, int nStyle);
int GetUndeadStyle(object oPC);
void SetDragonDiscipleStyle(object oPC, int nStyle);
void SetFightingStyle(object oPC, int nStyle);
void SetUndeadStyle(object oPC, int nStyle);


// PC AGE: HDAEODiFUN
// H: Helmet Hidden
// D: Difficultly Level 1 - 3
// A: Attack Ability
// E: Extra Attacks
// O: Extra Offhand Attacks
// Di: Damage Immunity
// F: Fighting Style
// U: Unused
// N: Enhanced: 0 - 2

// MN AGE: TouAEODiPU
// Tou: TouchAC 200 limit...
// A: Attack Ability
// E: Extra Attacks
// O: Extra Offhand Attacks
// Di: Damage Immunity
// P: Marked by PDK
// U: Unused

int CheckStyleItemRequirement(object oPC, object oItem){
    int nStyle;
    int bGood = TRUE;

    // Currently only restrictions are on Fighting Styles.
    nStyle = GetFightingStyle(oPC);
    if (nStyle != STYLE_INVALID){
        switch(nStyle){
            case STYLE_FIGHTER_FENCER:
                if(GetIsShield(oItem) || GetIsRangedWeapon2(oItem))
                    bGood = FALSE;
                else if(GetIsMeleeWeapon(oItem) && GetIsWeaponTwoHanded(oPC, oItem))
                    bGood = FALSE; 
            break;
            case STYLE_FIGHTER_KENSEI:
                if(GetIsShield(oItem) || GetIsRangedWeapon2(oItem))
                    bGood = FALSE;
                else if(GetIsMeleeWeapon(oItem) && GetIsWeaponTwoHanded(oPC, oItem))
                    bGood = FALSE; 
            break;
            case STYLE_FIGHTER_SPARTAN:
                if(GetIsMeleeWeapon(oItem) && GetIsWeaponTwoHanded(oPC, oItem))
                    bGood = FALSE; 
            break;
            case STYLE_FIGHTER_WARLORD:
                if(GetIsShield(oItem) || GetIsRangedWeapon2(oItem))
                    bGood = FALSE;
                else if(GetIsMeleeWeapon(oItem) && !GetIsWeaponTwoHanded(oPC, oItem))
                    bGood = FALSE; 
            break;
            case STYLE_MONK_BEAR_CLAW:
            case STYLE_MONK_DRAGON_PALM: 
            case STYLE_MONK_SUN_FIST:
            case STYLE_MONK_TIGER_FANG:
                if(GetIsShield(oItem) || GetIsRangedWeapon2(oItem))
                    bGood = FALSE;
                else if(GetIsMeleeWeapon(oItem) && GetBaseItemType(oItem) != BASE_ITEM_GLOVES)
                    bGood = FALSE; 
            break;
            case STYLE_ASSASSIN_NINJA:
                if(GetIsShield(oItem) || GetIsRangedWeapon2(oItem))
                    bGood = FALSE;
                else if(GetIsMeleeWeapon(oItem) && GetIsWeaponTwoHanded(oPC, oItem))
                    bGood = FALSE; 
            break;
        }
    }

    return bGood;
}

int GetDragonDiscipleStyle(object oPC){
    return GetPlayerInt(oPC, "pc_style_dragon");
}

int GetFightingStyle(object oPC){
    // Contains all info for fighter, monk, ninja.
    return GetPlayerInt(oPC, "pc_style_fighting");
}

int GetMeetsStyleRequirement(object oPC, int nStyle){
    int bGood = FALSE;

    if(GetSubRace(oPC) == "Paragon"){
        return FALSE;
    }

    // Currently only restrictions are on Fighting Styles.
    switch(nStyle){
        case STYLE_FIGHTER_FENCER:
        break;
        case STYLE_FIGHTER_KENSEI:
        break;
        case STYLE_FIGHTER_SPARTAN:
        break;
        case STYLE_FIGHTER_WARLORD:
        break;
        case STYLE_MONK_BEAR_CLAW:
        break;
        case STYLE_MONK_DRAGON_PALM: 
        break;
        case STYLE_MONK_SUN_FIST:
        break;
        case STYLE_MONK_TIGER_FANG:
        break;
        case STYLE_ASSASSIN_NINJA:
            if(GetKnowsFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC)
                    && GetKnowsFeat(FEAT_EPIC_REFLEXES, oPC)
                    && GetKnowsFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)
                    && GetLevelByClass (CLASS_TYPE_ASSASSIN, oPC) >= 25)
                bGood = TRUE;
        break;
    }
    
    return bGood;
}

int GetUndeadStyle(object oPC){
    return GetPlayerInt(oPC, "pc_style_undead");
}

int GetUndeadStyleAppearance(int nIndex){
    switch(nIndex){
        case 1: return 39;
        case 2: return 156;
        case 3: return 148;
        case 4: return 196;
    }

    return -1;
}

void SetDragonDiscipleStyle(object oPC, int nStyle){
    int nAge        = GetAge(oPC);
    int nBefore     = nAge % 1000;
    int nAfter      = nAge / 100000;
    int nColor      = nStyle;
    
    switch(nStyle){
        case STYLE_DRAGON_RED:
            nStyle = 0;
        break;
        case STYLE_DRAGON_BLUE:
            nStyle = 5;
        break;
        case STYLE_DRAGON_BRASS:
            nStyle = 6;
        break;
        case STYLE_DRAGON_GOLD:
            nStyle = 7;
        break;
        case STYLE_DRAGON_GREEN:
            nStyle = 4;
        break;
    }
    nAge = nAfter * 100000;
    nAge += nStyle * 1000;
    nAge += nBefore;
    SetAge(oPC, nAge);

    SetPlayerInt(oPC, "pc_style_dragon", nColor);
}

void SetFightingStyle(object oPC, int nStyle){
    // Contains all info for fighter, monk, ninja.
    int  nAge = GetAge(oPC);
    nAge = SetIntegerDigit(nAge, 2, nStyle);
    SetAge(oPC, nAge);
    SetPlayerInt(oPC, "pc_style_fighting", nStyle);
}

void SetUndeadStyle(object oPC, int nStyle){
    SetPlayerInt(oPC, "pc_style_undead", nStyle);
}
