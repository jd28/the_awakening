// Found on the Bioboards.
// Struct used by GetCreatureWeaponInfo() to pass information
// about a weapon used by OBJECT_SELF.
struct STItemInfo {
    int focus;
    int epicfocus;
    int spec;
    int epicspec;
    int weaponofchoice;
    int impcrit;
    int overcrit;
    int devcrit;
    int basemaxdmg;
    int twohanded;
};
// PROTOTYPES:
int GetAbilityAttackBonus(object oTarget);
int GetWeaponAttackBonus(object oTarget);
//int GetLegendaryAttackPenalty(object oTarget);
struct STItemInfo GetCreatureWeaponInfo(object oItem);
////////////////////////////////////////////////////////////////////////////////
// Returns the total attack bonus oCreature has from her BAB, strength
// modifier and weapon enhancements. This value is stored in a variable to
// lessen CPU-drain and will only be recalculated every nCache calls to the
// function. If nCache is 0, it will be recalculated immediately.
////////////////////////////////////////////////////////////////////////////////
int GetCalculatedAttackBonus(object oCreature=OBJECT_SELF, int nCache=12) {
    int nAttack;
    int nAB = GetLocalInt(oCreature, "ST_AI_ATTACKBONUS");
    int nCn = GetLocalInt(oCreature, "ST_AI_ABCOUNTER");
    if ((nAB == 0) || (nCn > nCache) || (nCache == 0)) {
        nAttack = GetBaseAttackBonus(oCreature);
        //nAttack -= GetLegendaryAttackPenalty(oCreature);
        nAttack += GetAbilityAttackBonus(oCreature);
        nAttack += GetWeaponAttackBonus(oCreature);
        nAttack += (GetHasFeat(FEAT_EPIC_PROWESS, oCreature) ? 1 : 0);
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
        if (GetIsObjectValid(oItem)) {
            struct STItemInfo wpnInfo = GetCreatureWeaponInfo(oItem);
            nAttack += (wpnInfo.focus ? 1 : 0);
            nAttack += (wpnInfo.epicfocus ? 2 : 0);
            nAttack += (wpnInfo.weaponofchoice && GetHasFeat(FEAT_SUPERIOR_WEAPON_FOCUS, oCreature) ? 1 : 0);
        }
        else if (GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oCreature)) {
            nAttack += (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature) ? 1 : 0);
            nAttack += (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature)   ? 2 : 0);
        }
        SetLocalInt(oCreature, "ST_AI_ATTACKBONUS", nAttack);
        SetLocalInt(oCreature, "ST_AI_ABCOUNTER", 0);
    }
    else {
        SetLocalInt(oCreature, "ST_AI_ABCOUNTER", ++nCn);
        nAttack = nAB;
    }
    return nAttack;
}
////////////////////////////////////////////////////////////////////////////////
//  Returns the attack bonus provided by Ability Modifiers. This is usually
//  strength, but if the creature has higher dexterity and the Weapon Finesse
//  feat, and wields a finessable weapon, that AB is returned instead.
////////////////////////////////////////////////////////////////////////////////
int GetAbilityAttackBonus(object oTarget) {
    int nStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
    // Have Weapon Finesse feat and higher Dex than Str modifier.
    if ((nDex > nStr) && GetHasFeat(FEAT_WEAPON_FINESSE, oTarget)) {
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        // Unarmed Strike
        if (!GetIsObjectValid(oItem)) {
            return nDex;
        }
        switch (GetBaseItemType(oItem)) {
            case BASE_ITEM_DAGGER:
            case BASE_ITEM_HANDAXE:
            case BASE_ITEM_KAMA:
            case BASE_ITEM_KUKRI:
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_LIGHTHAMMER:
            case BASE_ITEM_LIGHTMACE:
            case BASE_ITEM_RAPIER:
            case BASE_ITEM_SHORTSWORD:
            case BASE_ITEM_SHURIKEN:
            case BASE_ITEM_SICKLE:
            case BASE_ITEM_SLING:
            case BASE_ITEM_THROWINGAXE: return nDex;
        }
    }
    return nStr;
}
////////////////////////////////////////////////////////////////////////////////
//  Returns the attack penalty applied by legendary levels to the target.
////////////////////////////////////////////////////////////////////////////////
/*
int GetLegendaryAttackPenalty(object oTarget) {
    if (!GetIsPC(oTarget))
        return 0;
    int nLL = GetLootable(oTarget) - 40;
    if (nLL < 0)
        return 0;
    int nPenalty = 20;
    switch (GetLLControlClass(oTarget)) {
        case CLASS_TYPE_BARBARIAN:
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_BLACKGUARD:
        case CLASS_TYPE_DIVINECHAMPION:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_WEAPON_MASTER:
            nPenalty -= (nLL * 3) / 4;
            break;
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_ASSASSIN:
        case CLASS_TYPE_DRAGONDISCIPLE:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_SHIFTER:
            nPenalty -= (nLL + 1) / 2;
            if (nLL >= 20)
                nPenalty -= 2;
            else if (nLL >= 10)
                nPenalty -= 1;
            break;
        default:
            if (nLL >= 4)
                nPenalty -= (nLL - 2) / 2;
            break;
    }
    return nPenalty;
}
*/
////////////////////////////////////////////////////////////////////////////////
//  Returns the attack bonus provided by Attack Bonus or Enhancement bonus
//  properties on the currentl equipped weapon of the creature oTarget.
////////////////////////////////////////////////////////////////////////////////
int GetWeaponAttackBonus(object oTarget) {
    int nBonus = 0;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);    // Main hand weapon
    if (!GetIsObjectValid(oItem)) {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);       // Right hand claw
    }
    if (!GetIsObjectValid(oItem)) {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);       // Left hand claw
    }
    if (!GetIsObjectValid(oItem)) {
        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);       // Creature bite
    }
    if (!GetIsObjectValid(oItem)) {
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);            // Monk gloves
        if (GetIsObjectValid(oItem) && (GetBaseItemType(oItem) != BASE_ITEM_GLOVES)) {
            oItem = OBJECT_INVALID;
        }
    }
    if (GetIsObjectValid(oItem)) {
        itemproperty ipFirst = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ipFirst)) {
            if ((GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
                || (GetItemPropertyType(ipFirst) == ITEM_PROPERTY_ATTACK_BONUS))
            {
                int nSubType = GetItemPropertyCostTableValue(ipFirst);
                if (nSubType > nBonus) {
                    nBonus = nSubType;
                }
            }
            ipFirst = GetNextItemProperty(oItem);
        }
    }
    return nBonus;
}
////////////////////////////////////////////////////////////////////////////////
// Returns a STItemInfo struct containing information about the specified
// weapon and OBJECT_SELF's feats relating to it.
//
// Struct fields are:
// .focus           = the creature has weapon focus in the weapon.
// .epicfocus       = the creature has epic weapon focus in the weapon.
// .spec            = the creature has weapon specialization in the weapon.
// .epicspec        = the creature has epic weapon specialization in the weapon.
// .weaponofchoice  = the weapon is the creatures weaponmaster weapon of choice.
// .impcrit         = the creature has Improved Critical Hit in the weapon.
// .overcrit        = the creature has Overwhelming Critical Hit in the weapon.
// .devcrit         = the creature has Devastating Critical Hit in the weapon.
// .basemaxdmg      = returns the base damage of the weapon type.
// .twohanded       = TRUE if the weapon is two-handed for the creature (the
//                    creatures size is taken into account).
//                    Returns 2 if the weapon is a double-bladed twohanded weapon.
////////////////////////////////////////////////////////////////////////////////
struct STItemInfo GetCreatureWeaponInfo(object oItem) {
    struct STItemInfo res;
    int bTiny = (GetCreatureSize(OBJECT_SELF) < CREATURE_SIZE_MEDIUM);
    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_SHORTSWORD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSWORD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD);
            res.basemaxdmg      = 6;
            break;
        case BASE_ITEM_LONGSWORD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGSWORD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONG_SWORD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LONGSWORD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD);
            res.basemaxdmg      = 8;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_BATTLEAXE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_BATTLEAXE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_BATTLE_AXE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE);
            res.basemaxdmg      = 8;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_BASTARDSWORD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_BASTARDSWORD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_BASTARD_SWORD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD);
            res.basemaxdmg      = 10;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_LIGHTFLAIL:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL);
            res.basemaxdmg      = 9;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_WARHAMMER:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_WARHAMMER);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_WARHAMMER);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_WAR_HAMMER);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER);
            res.basemaxdmg      = 6;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_LIGHTMACE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTMACE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_MACE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE);
            res.basemaxdmg      = 6;
            break;
        case BASE_ITEM_HALBERD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_HALBERD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HALBERD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_HALBERD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_HALBERD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD);
            res.basemaxdmg      = 10;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_TWOBLADEDSWORD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD);
            res.basemaxdmg      = 8;
            res.twohanded       = 2;
            break;
        case BASE_ITEM_GREATSWORD:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_GREATSWORD);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATSWORD);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD);
            res.basemaxdmg      = 12;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_GREATAXE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_GREATAXE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_GREAT_AXE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_GREATAXE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_AXE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE);
            res.basemaxdmg      = 12;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_DAGGER:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DAGGER);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DAGGER);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_DAGGER);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER);
            res.basemaxdmg      = 4;
            break;
        case BASE_ITEM_CLUB:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_CLUB);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CLUB);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CLUB);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_CLUB);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_CLUB);
            res.basemaxdmg      = 6;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_DIREMACE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DIREMACE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DIRE_MACE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_DIREMACE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_DIRE_MACE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE);
            res.basemaxdmg      = 8;
            res.twohanded       = 2;
            break;
        case BASE_ITEM_DOUBLEAXE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_DOUBLEAXE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_DOUBLE_AXE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE);
            res.basemaxdmg      = 8;
            res.twohanded       = 2;
            break;
        case BASE_ITEM_HEAVYFLAIL:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL);
            res.basemaxdmg      = 10;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_LIGHTHAMMER:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER);
            res.basemaxdmg      = 4;
            break;
        case BASE_ITEM_HANDAXE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_HANDAXE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HAND_AXE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_HANDAXE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_HAND_AXE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE);
            res.basemaxdmg      = 6;
            break;
        case BASE_ITEM_KAMA:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_KAMA);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_KAMA);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_KAMA);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_KAMA);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_KAMA);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KAMA);
            res.basemaxdmg      = 6;
            break;
        case BASE_ITEM_KATANA:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_KATANA);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_KATANA);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_KATANA);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_KATANA);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_KATANA);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KATANA);
            res.basemaxdmg      = 10;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_KUKRI:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_KUKRI);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_KUKRI);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_KUKRI);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_KUKRI);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI);
            res.basemaxdmg      = 4;
            break;
        case BASE_ITEM_MORNINGSTAR:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_MORNING_STAR);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_MORNINGSTAR);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_MORNING_STAR);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR);
            res.basemaxdmg      = 8;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_QUARTERSTAFF:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_STAFF);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_STAFF);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_STAFF);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF);
            res.basemaxdmg      = 6;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_RAPIER:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_RAPIER);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_RAPIER);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_RAPIER);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER);
            res.basemaxdmg      = 6;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_SCIMITAR:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SCIMITAR);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SCIMITAR);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SCIMITAR);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_SCIMITAR);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR);
            res.basemaxdmg      = 6;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_SCYTHE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SCYTHE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SCYTHE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SCYTHE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_SCYTHE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE);
            res.basemaxdmg      = 8;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_SHORTSPEAR:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SPEAR);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SHORTSPEAR);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR);
            res.basemaxdmg      = 8;
            res.twohanded       = TRUE;
            break;
        case BASE_ITEM_SICKLE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SICKLE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SICKLE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_SICKLE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_SICKLE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE);
            res.basemaxdmg      = 6;
            break;
        case BASE_ITEM_DWARVENWARAXE:
            res.focus           = GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE);
            res.epicfocus       = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DWAXE);
            res.spec            = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DWAXE);
            res.epicspec        = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE);
            res.weaponofchoice  = GetHasFeat(FEAT_WEAPON_OF_CHOICE_DWAXE);
            res.impcrit         = GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE);
            res.overcrit        = GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE);
            res.devcrit         = GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE);
            res.basemaxdmg      = 10;
            res.twohanded       = (bTiny ? TRUE : FALSE);
            break;
        case BASE_ITEM_WHIP:
            res.focus           = GetHasFeat(993);
            res.epicfocus       = GetHasFeat(997);
            res.spec            = GetHasFeat(994);
            res.epicspec        = GetHasFeat(998);
            res.weaponofchoice  = GetHasFeat(1000);
            res.impcrit         = GetHasFeat(995);
            res.overcrit        = GetHasFeat(999);
            res.devcrit         = GetHasFeat(996);
            res.basemaxdmg      = 2;
            break;
    }
    return res;
}
