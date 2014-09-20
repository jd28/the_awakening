#include "x2_inc_itemprop"
#include "info_inc"

const int IP_CONST_FEAT_SCRIBE_SCROLL = 63;

// Returns TRUE if oItem is ammunition or throwing weapon
int GetIsAmmunition(object oItem);
int GetBaseArmorACBonus(object oItem);
int GetisILRItem(object oItem);
// Returns TRUE if oItem is a melee weapon
int GetIsMeleeWeapon(object oItem);

// Returns TRUE if oItem is a ranged weapon
int GetIsRangedWeapon2(object oItem);

int GetIsShield(object oItem);

// Get Item Enhancement Bonus, (EB, AB, AC, etc)
int GetItemEnhancementBonus(object oItem, int nDur = DURATION_TYPE_PERMANENT);

int GetItemEnhancementBonus(object oItem, int nDur = DURATION_TYPE_PERMANENT){

    int nFound = 0;
    int nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    int nBaseItem = GetBaseItemType(oItem);

    if(GetIsMeleeWeapon(oItem)){
        nIPEnhanceType = ITEM_PROPERTY_ENHANCEMENT_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_HEAVYCROSSBOW ||
            nBaseItem == BASE_ITEM_LIGHTCROSSBOW ||
            nBaseItem == BASE_ITEM_LONGBOW ||
            nBaseItem == BASE_ITEM_SHORTBOW){
        nIPEnhanceType = ITEM_PROPERTY_ATTACK_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_LARGESHIELD ||
            nBaseItem == BASE_ITEM_SMALLSHIELD ||
            nBaseItem == BASE_ITEM_TOWERSHIELD){
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_AMULET){
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_HELMET ||
            nBaseItem == BASE_ITEM_RING   ||
            nBaseItem == BASE_ITEM_BRACER ||
            nBaseItem == BASE_ITEM_CLOAK){
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_BOOTS){
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }
    else if(nBaseItem == BASE_ITEM_ARMOR){
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }
    else{
        nIPEnhanceType = ITEM_PROPERTY_AC_BONUS;
    }

    //SendMessageToPC(GetFirstPC(), "ILR: Base Item Type: " + IntToString(nBaseItem));

    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == nIPEnhanceType &&
           GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT){
            return GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oItem);
    }
    return 0;
}

int GetisILRItem(object oItem) { //no ilr for ammo and creature items {
	if (GetLocalString(oItem, "ilr_tagged") != "") { return TRUE; }

    int nTyp = GetBaseItemType(oItem);
    if      (nTyp == BASE_ITEM_ARROW)         return FALSE;
    else if (nTyp == BASE_ITEM_BOLT)          return FALSE;
    else if (nTyp == BASE_ITEM_BULLET)        return FALSE;
    else if (nTyp == BASE_ITEM_DART)          return FALSE;
    else if (nTyp == BASE_ITEM_SHURIKEN)      return FALSE;
    else if (nTyp == BASE_ITEM_THROWINGAXE)   return FALSE;
    else if (nTyp == BASE_ITEM_CREATUREITEM)  return FALSE;
    else if (nTyp == BASE_ITEM_CSLASHWEAPON)  return FALSE;
    else if (nTyp == BASE_ITEM_CPIERCWEAPON)  return FALSE;
    else if (nTyp == BASE_ITEM_CBLUDGWEAPON)  return FALSE;
    else if (nTyp == BASE_ITEM_CSLSHPRCWEAP)  return FALSE;
    else if (nTyp == BASE_ITEM_LONGBOW)       return FALSE;
    else if (nTyp == BASE_ITEM_SHORTBOW)      return FALSE;
    else if (nTyp == BASE_ITEM_SLING)         return FALSE;
    else if (nTyp == BASE_ITEM_LIGHTCROSSBOW) return FALSE;
    else if (nTyp == BASE_ITEM_HEAVYCROSSBOW) return FALSE;

    return TRUE;
}
// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a melee weapon
// ----------------------------------------------------------------------------
int GetIsMeleeWeapon(object oItem){
    if(!GetIsObjectValid(oItem))
        return FALSE;

    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if (nItem == BASE_ITEM_BASTARDSWORD         ||
        nItem == BASE_ITEM_BATTLEAXE            ||
        nItem == BASE_ITEM_DOUBLEAXE            ||
        nItem == BASE_ITEM_GREATAXE             ||
        nItem == BASE_ITEM_GREATSWORD           ||
      (nItem == BASE_ITEM_GLOVES) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD) ||
      (nItem == BASE_ITEM_SCIMITAR) ||
      (nItem == BASE_ITEM_SCYTHE) ||
      (nItem == BASE_ITEM_SICKLE) ||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_CLUB) ||
      (nItem == BASE_ITEM_DAGGER) ||
      (nItem == BASE_ITEM_DIREMACE) ||
      (nItem == BASE_ITEM_HEAVYFLAIL) ||
      (nItem == BASE_ITEM_LIGHTFLAIL) ||
      (nItem == BASE_ITEM_LIGHTHAMMER) ||
      (nItem == BASE_ITEM_LIGHTMACE) ||
      (nItem == BASE_ITEM_MORNINGSTAR) ||
      (nItem == BASE_ITEM_QUARTERSTAFF) ||
      (nItem == BASE_ITEM_MAGICSTAFF) ||
      (nItem == BASE_ITEM_RAPIER) ||
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == BASE_ITEM_SHORTSPEAR) ||
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_WARHAMMER)  ||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
      (nItem == BASE_ITEM_TRIDENT) ||
      (nItem == BASE_ITEM_HEAVYPICK) ||
      (nItem == BASE_ITEM_LIGHTPICK) ||
      (nItem == BASE_ITEM_SAI) ||
      (nItem == BASE_ITEM_NUNCHAKU) ||
      (nItem == BASE_ITEM_FALCHION) ||
      (nItem == BASE_ITEM_SAP) ||
      (nItem == BASE_ITEM_ASSASSINDAGGER) ||
      (nItem == BASE_ITEM_KATAR) ||
      (nItem == BASE_ITEM_LIGHTMACE_2) ||
      (nItem == BASE_ITEM_KUKRI_2) ||
      (nItem == BASE_ITEM_FALCHION_2) ||
      (nItem == BASE_ITEM_HEAVYMACE) ||
      (nItem == BASE_ITEM_MAUL) ||
      (nItem == BASE_ITEM_MERCLONGSWORD) ||
      (nItem == BASE_ITEM_MERCGREATSWORD) ||
      (nItem == BASE_ITEM_DOUBLESCIMITAR) ||
      (nItem == BASE_ITEM_GOAD) ||
      (nItem == BASE_ITEM_WINDFIREWHEEL) ||
      (nItem == BASE_ITEM_MAUGDOUBLESWORD) ||
      (nItem == BASE_ITEM_LONGSWORD_2) ||
      (nItem == BASE_ITEM_SPEAR_SHORT) ||
      (nItem == BASE_ITEM_TRIDENT_ONE_HANDED))
   {
        return TRUE;
   }
   return FALSE;
}

int GetIsRangedWeapon2(object oItem){
    if(!GetIsObjectValid(oItem))
        return FALSE;

    int nBaseItemType = GetBaseItemType(oItem);
    if(nBaseItemType == BASE_ITEM_LIGHTCROSSBOW ||
       nBaseItemType == BASE_ITEM_LONGBOW ||
       nBaseItemType == BASE_ITEM_HEAVYCROSSBOW ||
       nBaseItemType == BASE_ITEM_SHORTBOW ||
       nBaseItemType == BASE_ITEM_SLING){
        return TRUE;
    }

    return FALSE;
}

int GetIsShield(object oItem){
    if(!GetIsObjectValid(oItem))
        return FALSE;

    int nBaseItemType = GetBaseItemType(oItem);
    if(nBaseItemType == BASE_ITEM_SMALLSHIELD       ||
           nBaseItemType == BASE_ITEM_LARGESHIELD   ||
           nBaseItemType == BASE_ITEM_TOWERSHIELD)
        return TRUE;

    return FALSE;
}
int GetIsAmmunition(object oItem){
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_ARROW) ||
      (nItem == BASE_ITEM_BOLT) ||
      (nItem == BASE_ITEM_BULLET) ||
      (nItem == BASE_ITEM_DART) ||
      (nItem == BASE_ITEM_SHURIKEN) ||
      (nItem == BASE_ITEM_THROWINGAXE))
   {
        return TRUE;
   }
   return FALSE;
}

int GetDamageResistFromNumber(int nNumber){
    switch(nNumber){
        case 1: return IP_CONST_DAMAGERESIST_5; break;
        case 2: return IP_CONST_DAMAGERESIST_10; break;
        case 3: return IP_CONST_DAMAGERESIST_15; break;
        case 4: return IP_CONST_DAMAGERESIST_20; break;
        case 5: return IP_CONST_DAMAGERESIST_25; break;
        case 6: return IP_CONST_DAMAGERESIST_30; break;
        case 7: return IP_CONST_DAMAGERESIST_35; break;
        case 8: return IP_CONST_DAMAGERESIST_40; break;
        case 9: return IP_CONST_DAMAGERESIST_50; break;
    }

    return -1;
}

int GetSpellResistenceFromNumber(int nNumber){
    switch(nNumber){
        case 1: return IP_CONST_SPELLRESISTANCEBONUS_10; break;
        case 2: return IP_CONST_SPELLRESISTANCEBONUS_12; break;
        case 3: return IP_CONST_SPELLRESISTANCEBONUS_14; break;
        case 4: return IP_CONST_SPELLRESISTANCEBONUS_16; break;
        case 5: return IP_CONST_SPELLRESISTANCEBONUS_18; break;
        case 6: return IP_CONST_SPELLRESISTANCEBONUS_20; break;
        case 7: return IP_CONST_SPELLRESISTANCEBONUS_22; break;
        case 8: return IP_CONST_SPELLRESISTANCEBONUS_24; break;
        case 9: return IP_CONST_SPELLRESISTANCEBONUS_32; break;
    }

    return -1;
}
int GetDamageBonusFromNumber(int nNumber){
    switch(nNumber){
        case 1: return DAMAGE_BONUS_1d4; break;
        case 2: return DAMAGE_BONUS_1d6; break;
        case 3: return DAMAGE_BONUS_2d4; break;
        case 4: return DAMAGE_BONUS_2d6; break;
        case 5: return DAMAGE_BONUS_2d8; break;
        case 6: return DAMAGE_BONUS_2d10; break;
        case 7: return DAMAGE_BONUS_2d12; break;
        case 8: return DAMAGE_BONUS_16; break;
        case 9: return DAMAGE_BONUS_20; break;
    }

    return -1;
}

string GetRackWeaponResref(int NCode){
    string sResref;

    switch(NCode / 10){
        case 0: //Axes
            switch(NCode % 10)
            {
                case 1: sResref = "nw_waxbt001"; break;
                case 2: sResref = "x2_wdwraxe001"; break;
                case 3: sResref = "nw_waxhn001"; break;
                case 4: sResref = "nw_waxgr001"; break;
            }
        break;
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
        case 2: //Blunt
            switch(NCode % 10)
            {
                case 1: sResref = "nw_wblcl001"; break;
                case 2: sResref = "nw_wblfl001"; break;
                case 3: sResref = "nw_wblfh001"; break;
                case 4: sResref = "monkguantlet"; break;
                case 5: sResref = "nw_wblhl001"; break;
                case 6: sResref = "nw_wblhw001"; break;
                case 7: sResref = "nw_wblml001"; break;
                case 8: sResref = "nw_wblms001"; break;
                case 9: sResref = "nw_wdbqs001"; break;
            }
        break;
        case 3: //Double-Sided
            switch(NCode % 10)
            {
                case 1: sResref = "nw_wdbma001"; break;
                case 2: sResref = "nw_wdbax001"; break;
                case 3: sResref = "nw_wdbsw001"; break;
            }
        break;
        case 4: //Exotic
            switch(NCode % 10){
                case 1: sResref = "nw_wspka001"; break;
                case 2: sResref = "nw_wspku001"; break;
                case 3: sResref = "nw_wspsc001"; break;;
                case 4: sResref = "x2_it_wpwhip"; break;
            }
        break;
        case 5: //Polearm
            switch(NCode % 10)
            {
                case 1: sResref = "nw_wplhb001"; break;
                case 2: sResref = "nw_wplsc001"; break;
                case 3: sResref = "nw_wplss001"; break;
                case 4: sResref = "nw_wpltr001"; break;
            }
        break;
        case 6: //Quivers
            switch(NCode % 10)
            {
                case 1: sResref = "pl_quiver_magic"; break; // Arrows
                case 2: sResref = "pl_quiver_bolt"; break; // Bolts
                case 3: sResref = "pl_quiver_bullet"; break; // Bullets
                case 4: sResref = "pl_quiver_darts"; break; // Darts
                case 5: sResref = "pl_quive_shurike"; break; // Shurikens
                case 6: sResref = "pl_quiver_axthr"; break; // Throwing Axes
            }
        break;
    }
    return sResref;
}

string GetWeaponResref(int NCode){
    string sResref;

    if(NCode < 100){
        switch(NCode){
            case 0: sResref = "nw_waxbt001"; break;
            case 1: sResref = "x2_wdwraxe001"; break;
            case 2: sResref = "nw_waxhn001"; break;
            case 3: sResref = "nw_waxgr001"; break;
        }
    }
    else{
        switch(NCode / 100){
            case 1: //Bladed
                switch(NCode % 100)
                {
                    case 0: sResref = "nw_wswbs001"; break;
                    case 1: sResref = "nw_wswdg001"; break;
                    case 2: sResref = "nw_wswgs001"; break;
                    case 3: sResref = "nw_wswka001"; break;
                    case 4: sResref = "nw_wswls001"; break;
                    case 5: sResref = "nw_wswrp001"; break;
                    case 6: sResref = "nw_wswsc001"; break;
                    case 7: sResref = "nw_wswss001"; break;
                    case 8: sResref = "pl_falchion"; break; // Falchion
                    case 9: sResref = "pl_falchion_2"; break; // Falchion 2
                    case 10: sResref = "pl_dagger_ass"; break;// Assassin Dagger
                }
            break;
            case 2: //Blunt
                switch(NCode % 100)
                {
                    case 0: sResref = "nw_wblcl001"; break;
                    case 1: sResref = "nw_wblfl001"; break;
                    case 2: sResref = "nw_wblfh001"; break;
                    case 3: sResref = "nw_wblhl001"; break;
                    case 4: sResref = "nw_wblhw001"; break;
                    case 5: sResref = "nw_wblml001"; break;
                    case 6: sResref = "nw_wblms001"; break;
                    case 7: sResref = "nw_wdbqs001"; break;
                    case 8: sResref = "pl_maul"; break; // Maul
                    case 9: sResref = "pl_mace_hvy"; break; // Heavy Mace
                }
            break;
            case 3: //Double-Sided
                switch(NCode % 100)
                {
                    case 0: sResref = "nw_wdbma001"; break;
                    case 1: sResref = "nw_wdbax001"; break;
                    case 2: sResref = "nw_wdbsw001"; break;
                    case 3: sResref = "pl_scimi_dbl"; break;
                }
            break;
            case 4: //Exotic
                switch(NCode % 100){
                    case 0: sResref = "nw_wspka001"; break;
                    case 1: sResref = "nw_wspku001"; break;
                    case 2: sResref = "nw_wspsc001"; break;;
                    case 3: sResref = "x2_it_wpwhip"; break;
                    case 4: sResref = "pl_katar"; break;
                    case 5: sResref = "pl_sai"; break;
                    case 6: sResref = "pl_nunchaku"; break;
                    case 7: sResref = "pl_windfire"; break;
                }
            break;
            case 5: //Polearm
                switch(NCode % 100)
                {
                    case 0: sResref = "nw_wplhb001"; break;
                    case 1: sResref = "nw_wplsc001"; break;
                    case 2: sResref = "nw_wplss001"; break;
                    case 3: sResref = "nw_wpltr001"; break;
                    case 4: sResref = "pl_trident_1h"; break; // Trident One-Handed
                    case 5: sResref = "pl_spear_short"; break; // Short Spear
                }
            break;
            case 6: //Pick
                switch(NCode % 100)
                {
                    case 0: sResref = "pl_pick_hvy"; break;
                    case 1: sResref = "pl_pick_lght"; break;
                }
            break;
            // Monk Guants
            case 7: sResref = "monkguantlet"; break;
            case 8: //Quivers
                switch(NCode % 100)
                {
                    case 0: sResref = "pl_quiver_magic"; break; // Arrows
                    case 1: sResref = "pl_quiver_bolt"; break; // Bolts
                    case 2: sResref = "pl_quiver_bullet"; break; // Bullets
                    case 3: sResref = "pl_quiver_darts"; break; // Darts
                    case 4: sResref = "pl_quive_shurike"; break; // Shurikens
                    case 5: sResref = "pl_quiver_axthr"; break; // Throwing Axes
                }
            break;
    /*
            case 9:
                switch(NCode % 100)
                {
                    case 0: sResref = "pl_quiver_magic"; break; // Cleric
                    case 1: sResref = "pl_quiver_bolt"; break; // Druid
                    case 2: sResref = "pl_quiver_bullet"; break; // Sorcerer
                    case 3: sResref = "pl_quiver_darts"; break; // Wizard
                }
            break;
    */
        }
    }
    return sResref;
}

int GetBaseArmorACBonus(object oItem){
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid (oItem)) return -1;
    if (GetBaseItemType (oItem) != BASE_ITEM_ARMOR) return -1;

    //Get the AC value of armor (includes magical bonus)
    int nAC = GetItemACValue (oItem);
    // Preserve whether item is identified or not
    int bIdentified = GetIdentified (oItem);
    // Unidentify it to find base AC (without enhancements)
    SetIdentified(oItem,FALSE);
    int nType = -1;
    switch (GetGoldPieceValue (oItem)){
        case    1: nType = 0; break; // None
        case    5: nType = 1; break; // Padded
        case   10: nType = 2; break; // Leather
        case   15: nType = 3; break; // Studded Leather / Hide
        case  100: nType = 4; break; // Chain Shirt / Scale Mail
        case  150: nType = 5; break; // Chainmail / Breastplate
        case  200: nType = 6; break; // Splint Mail / Banded Mail
        case  600: nType = 7; break; // Half-Plate
        case 1500: nType = 8; break; // Full Plate
    }

    // Restore the identified flag, and return armor type.
    SetIdentified (oItem,bIdentified);

    return nType;
}

int GetIPDamageConst(int nDamage);
int GetIPDamageConst(int nDamage){
    switch (nDamage){
        case DAMAGE_TYPE_ACID: return IP_CONST_DAMAGETYPE_ACID;
        case DAMAGE_TYPE_BLUDGEONING: return IP_CONST_DAMAGETYPE_BLUDGEONING;
        case DAMAGE_TYPE_COLD: return IP_CONST_DAMAGETYPE_COLD;
        case DAMAGE_TYPE_DIVINE: return IP_CONST_DAMAGETYPE_DIVINE;
        case DAMAGE_TYPE_ELECTRICAL: return IP_CONST_DAMAGETYPE_ELECTRICAL;
        case DAMAGE_TYPE_FIRE: return IP_CONST_DAMAGETYPE_FIRE;
        case DAMAGE_TYPE_MAGICAL: return IP_CONST_DAMAGETYPE_MAGICAL;
        case DAMAGE_TYPE_NEGATIVE: return IP_CONST_DAMAGETYPE_NEGATIVE;
        case DAMAGE_TYPE_PIERCING: return IP_CONST_DAMAGETYPE_PIERCING;
        case DAMAGE_TYPE_POSITIVE: return IP_CONST_DAMAGETYPE_POSITIVE;
        case DAMAGE_TYPE_SLASHING: return IP_CONST_DAMAGETYPE_SLASHING;
        case DAMAGE_TYPE_SONIC: return IP_CONST_DAMAGETYPE_SONIC;
    }
    return -1;
}

void RemoveAllItemProperties(object oItem){
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip)){
        RemoveItemProperty(oItem, ip);
        ip = GetNextItemProperty(oItem);
    }
}

object GetTargetedOrEquippedArmor(object oTarget, int bAllowShields = FALSE){
    if(!GetIsObjectValid(oTarget))
        return OBJECT_INVALID;

    if(GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
        oTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

    if(oTarget == OBJECT_INVALID && bAllowShields){
        oTarget = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);

        if (GetBaseItemType(oTarget) != BASE_ITEM_LARGESHIELD
                && GetBaseItemType(oTarget) != BASE_ITEM_SMALLSHIELD
                && GetBaseItemType(oTarget) != BASE_ITEM_TOWERSHIELD)
            return OBJECT_INVALID;
    }

    return oTarget;
}
