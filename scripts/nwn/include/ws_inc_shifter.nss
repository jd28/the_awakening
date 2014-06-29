//:://////////////////////////////
//:: Created By: Iznoghoud
//:: Last modified: January 19 2004
/*
What this script changes:
- Melee Weapon properties now carry over to the unarmed forms' claws and bite
attacks.
1) Now, items with an AC bonus (or penalty) carry over to the shifted form as
the correct type. This means if you wear an amulet of natural armor +4, and a
cloak of protection +5, and you shift to a form that gets all item properties
carried over, you will have the +4 natural armor bonus from the ammy, as well as
the +5 deflection bonus from the cloak. No longer will the highest one override
all the other AC bonuses even if they are a different type.
2) Other "stackable" item properties, like ability bonuses, skill bonuses and
saving throw bonuses, now correctly add up in shifted form. This means if you
have a ring that gives +2 strength, and a ring with +3 strength, and you shift
into a drow warrior, you get +5 strength in shifted form, where you used to get
only +3. (the highest)


This file contains the code that handles stacking item properties for the improved
Shifter and Druid wildshape scripts.
1 February 2004:
Added an option to allow or disallow AC stacking of different types.
*/
//:://////////////////////////////

//******** Begin Options *********

//***************** GENERAL OPTIONS *********************

// Set this to TRUE to allow differing types of AC bonuses on items to stack.
// (ie armor, deflection, natural) Warning: This can give shifters who multiclass
// with monk a godly AC depending on your module.
// With FALSE, AC will transfer as it did with the default Bioware shifter script.
const int GW_ALLOW_AC_STACKING = TRUE;

//***************** FOR SHIFTER SHAPES ******************

// Set this to TRUE to merge properties of boots/rings/ammy/cloak/bracers regardless
// of what polymorph.2da indicates.
// FALSE uses the polymorph.2da to decide whether to copy
const int GW_ALWAYS_COPY_ITEM_PROPS = TRUE;//FALSE;

// Set this to TRUE to merge armor/helmet properties regardless of what polymorph.2da indicates.
// FALSE uses the polymorph.2da to decide whether to copy
const int GW_ALWAYS_COPY_ARMOR_PROPS = TRUE;

// - Set this to 1 to copy over weapon properties to claw/bite attacks.
// - Set this to 2 to copy over glove properties to claw/bite attacks.
// - Set this to 3 to copy over from either weapon or gloves depending on whether a
//   weapon was worn at the time of shifting.
// - Set this to any other value ( eg 0 ) to not copy over anything to claw/bite attacks.
const int GW_COPY_WEAPON_PROPS_TO_UNARMED = 3;


//***************** FOR DRUID SHAPES ********************
// These options do nothing if you have not imported the improved Druid wild-
// and elemental shape scripts

// Set this to TRUE to merge properties of boots/rings/ammy/cloak/bracers regardless
// of what polymorph.2da indicates.
// FALSE uses the polymorph.2da to decide whether to copy
const int WS_ALWAYS_COPY_ITEM_PROPS = TRUE;//FALSE;

// Set this to TRUE to merge armor/helmet properties regardless of what polymorph.2da indicates.
// FALSE uses the polymorph.2da to decide whether to copy
const int WS_ALWAYS_COPY_ARMOR_PROPS = TRUE;

// - Set this to 1 to copy over weapon properties to claw/bite attacks.
// - Set this to 2 to copy over glove properties to claw/bite attacks.
// - Set this to 3 to copy over from either weapon or gloves depending on whether a
//   weapon was worn at the time of shifting.
// - Set this to any other value ( eg 0 ) to not copy over anything to claw/bite attacks.
const int WS_COPY_WEAPON_PROPS_TO_UNARMED = 3;

//******** End Options ***********

// Includes for various shifter and item related functions
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "nwnx_inc"
#include "mod_const_inc"
#include "item_func_inc"

// **** Begin Function prototypes ****
// Copies oOld's Properties to oNew, but only properties that do not stack
// with properties of the same type. If oOld is a weapon, then bWeapon must be TRUE.
void WildshapeCopyNonStackProperties(object oOld, object oNew, int bWeapon = FALSE);
// Returns TRUE if ip is an item property that will stack with other properties
// of the same type: Ability, AC, Saves, Skills.
int GetIsStackingProperty(itemproperty ip);
// Returns the AC bonus type of oItem: AC_*_BONUS
int GetItemACType(object oItem);
// Looks for Stackable Properties on oItem, and sets local variables to count the total bonus.
// Also links any found AC bonuses/penalties to ePoly.
effect ExamineStackableProperties (object oPC, effect ePoly, object oItem );
// if bItems is TRUE, Adds the stackable properties on all the objects given to ePoly.
// if bArmor is TRUE, Adds the stackable properties on armor and helmet to ePoly.
effect AddStackablePropertiesToPoly ( object oPC, effect ePoly, int bWeapon, int bItems, int bArmor, object oArmorOld, object oRing1Old,
                                      object oRing2Old, object oAmuletOld, object oCloakOld, object oBracerOld,
                                      object oBootsOld, object oBeltOld, object oHelmetOld, object oShield, object oWeapon, object oHideOld);
// Returns the spell that applied a Polymorph Effect currently on the player.
// -1 if it was no spell, -2 if no polymorph effect found.
int ScanForPolymorphEffect(object oPC);

// Converts a number from iprp_damagetype.2da to the corresponding
// DAMAGE_TYPE_* constants.
int ConvertNumToDamTypeConstant ( int iItemDamType );

// Converts a number from iprp_immuncost.2da to the corresponding percentage of immunity
int ConvertNumToImmunePercentage ( int iImmuneCost );

// Special function to copy over weapon properties, which deals with copying
// over ranged weapons correctly.
void WildshapeCopyWeaponProperties(object oPC, object oOld, object oNew);

// Returns TRUE if oItem is a creature claw or bite.
int GetIsCreatureWeapon( object oItem );


void WildshapeAddWeaponFeats(object oSkin, int nWeaponType, int bWF, int bEWF,
                             int bWS, int bEWS, int bIC, int bOC, int bDC, int bWC);

// **** End Function prototypes ****

// **** Begin Functions, added by Iznoghoud ****
// Copies oOld's Properties to oNew, but only properties that do not stack
// with properties of the same type. If oOld is a weapon, then bWeapon must be TRUE.
void WildshapeCopyNonStackProperties(object oOld, object oNew, int bWeapon = FALSE) {
//    SpeakString(GetName(oOld) + "  " + GetName(oNew));

    if (GetIsObjectValid(oOld) && GetIsObjectValid(oNew))
    {
        itemproperty ip = GetFirstItemProperty(oOld);
        while (GetIsItemPropertyValid(ip)) // Loop through all the item properties.
        {
            if (bWeapon) // If a weapon, then we must make sure not to transfer between ranged and non-ranged weapons!
            {
                if (GetWeaponRanged(oOld) == GetWeaponRanged(oNew) )
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
                }
            }
            else
            {
                // If not a stacking property, copy over the property.
                // Dont copy on hit cast spell property unless the target is a claw/bite.
                if ( !GetIsStackingProperty(ip) && ( !(GetItemPropertyType(ip) == ITEM_PROPERTY_ONHITCASTSPELL) || GetIsCreatureWeapon(oNew) ) )
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
            }
            ip = GetNextItemProperty(oOld); // Get next property
        }
    }
}
// Returns TRUE if ip is an item property that will stack with other properties
// of the same type: Ability, AC, Saves, Skills.
int GetIsStackingProperty(itemproperty ip) {
    int iType = GetItemPropertyType(ip);
    if ( iType == 0 || ( GW_ALLOW_AC_STACKING && (iType == 1) ) ||     // Bonus to Ability, AC
         iType == 27 || ( GW_ALLOW_AC_STACKING && (iType == 28) ) ||   // Penalty to Ability, AC
           iType == 40 || iType == 41 || // Bonus to saves (against element/universal, or fort/reflex/will)
           iType == 49 || iType == 50 || // Penalty to saves (against element/universal, or fort/reflex/will)
           iType == 52 || iType == 29 || // Skill Bonus, Penalty
           iType == 51 ||                // Regeneration
           iType == 20 || iType == 24    // Damage Immunity and Vulnerability
       )
        return TRUE;
    else
        return FALSE;
}
// Returns the AC bonus type of oItem: AC_*_BONUS
int GetItemACType(object oItem) {
    switch(GetBaseItemType(oItem)) {
    case BASE_ITEM_ARMOR: // These item types always get an armor ac bonus
    case BASE_ITEM_BRACER:
        return AC_ARMOUR_ENCHANTMENT_BONUS;
        break;
    case BASE_ITEM_BELT: // These item types always get a deflection ac bonus.
    case BASE_ITEM_CLOAK:
    case BASE_ITEM_GLOVES: // Note that gloves and bracers equip in the same inventory slot,
    case BASE_ITEM_HELMET: // but do not give the same AC bonus type!!!
    case BASE_ITEM_RING:
    case BASE_ITEM_TORCH:
        return AC_DEFLECTION_BONUS;
        break;
    case BASE_ITEM_BOOTS: // Only boots give a dodge ac bonus
        return AC_DODGE_BONUS;
        break;
    case BASE_ITEM_AMULET: // Only amulets give a natural AC bonus
        return AC_NATURAL_BONUS;
        break;
    case BASE_ITEM_LARGESHIELD: // Shields give a shield AC bonus
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
        return AC_SHIELD_ENCHANTMENT_BONUS;
        break;
    default: // It was a weapon, or a non default item, safest to default to deflection
        return AC_DEFLECTION_BONUS;
        break;
    };
    return AC_DEFLECTION_BONUS; // This one would seem unneccesary but it won't compile otherwise.
}
// Looks for Stackable Properties on oItem, and sets local variables to count the total bonus.
// Also links any found AC bonuses/penalties to ePoly.
effect ExamineStackableProperties ( object oPC, effect ePoly, object oItem )
{
    if ( !GetIsObjectValid(oItem) ) // If not valid, dont do any unneccesary work.
        return ePoly;
    itemproperty ip = GetFirstItemProperty(oItem);
    int iSubType, bMonk = (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0), nBaseItemType = GetBaseItemType(oItem);
    effect eTemp;
    while ( GetIsItemPropertyValid(ip) ) // Loop through all the item properties
    {
        if ( GetIsStackingProperty(ip) ) // See if it's a stacking property
        {
            iSubType = GetItemPropertySubType(ip); // Get the item property subtype for later use.
                                            // This contains whether a bonus is str, dex,
                                            // concentration skill, universal saving throws, etc.
            switch ( GetItemPropertyType(ip) ) // Which type of property is it?
            {
                // In the case of AC modifiers, add it directly to the Polymorphing effect.
                // For the other cases, set local variables on the player to
                // make a sum of all the bonuses/penalties. We use local
                // variables here because there are no arrays in NWScript, and
                // declaring a variable for every skill, ability type and saving
                // throw type in here is a little overboard.
                case 0: // Ability Bonus
                    SetLocalInt(oPC, "ws_ability_" + IntToString(iSubType), GetLocalInt(oPC, "ws_ability_" + IntToString(iSubType)) + GetItemPropertyCostTableValue(ip) );
                    break;
                case 1: // AC Bonus
                    if(bMonk && (nBaseItemType == BASE_ITEM_LARGESHIELD || nBaseItemType == BASE_ITEM_SMALLSHIELD || nBaseItemType == BASE_ITEM_TOWERSHIELD))
                        break;

                    ePoly = EffectLinkEffects(EffectACIncrease(GetItemPropertyCostTableValue(ip),GetItemACType(oItem)), ePoly);
                    break;
                case 27: // Ability Penalty
                    SetLocalInt(oPC, "ws_ability_" + IntToString(iSubType), GetLocalInt(oPC, "ws_ability_" + IntToString(iSubType)) - GetItemPropertyCostTableValue(ip) );
                    break;
                case 28: // AC penalty
                    ePoly = EffectLinkEffects(EffectACDecrease(GetItemPropertyCostTableValue(ip)), ePoly);
                    break;
                case 52: // Skill Bonus
                    SetLocalInt(oPC, "ws_skill_" + IntToString(iSubType), GetLocalInt(oPC, "ws_skill_" + IntToString(iSubType)) + GetItemPropertyCostTableValue(ip) );
                    break;
                case 29: // Skill Penalty
                    SetLocalInt(oPC, "ws_skill_" + IntToString(iSubType), GetLocalInt(oPC, "ws_skill_" + IntToString(iSubType)) - GetItemPropertyCostTableValue(ip) );
                    break;
                case 40: // Saving Throw Bonus vs Element(or universal)
                    SetLocalInt(oPC, "ws_save_elem_" + IntToString(iSubType), GetLocalInt(oPC, "ws_save_elem_" + IntToString(iSubType)) + GetItemPropertyCostTableValue(ip) );
                    break;
                case 41: // Saving Throw Bonus specific (fort/reflex/will)
                    SetLocalInt(oPC, "ws_save_spec_" + IntToString(iSubType), GetLocalInt(oPC, "ws_save_spec_" + IntToString(iSubType)) + GetItemPropertyCostTableValue(ip) );
                    break;
                case 49: // Saving Throw Penalty vs Element(or universal)
                    SetLocalInt(oPC, "ws_save_elem_" + IntToString(iSubType), GetLocalInt(oPC, "ws_save_elem_" + IntToString(iSubType)) - GetItemPropertyCostTableValue(ip) );
                    break;
                case 50: // Saving Throw Penalty specific (fort/reflex/will)
                    SetLocalInt(oPC, "ws_save_spec_" + IntToString(iSubType), GetLocalInt(oPC, "ws_save_spec_" + IntToString(iSubType)) - GetItemPropertyCostTableValue(ip) );
                    break;
                case 51: // Regeneration
                    SetLocalInt(oPC, "ws_regen", GetLocalInt(OBJECT_SELF, "ws_regen") + GetItemPropertyCostTableValue(ip) );
                    break;
                case 20: // Damage Immunity
                    SetLocalInt(oPC, "ws_dam_immun_" + IntToString(iSubType), GetLocalInt(oPC, "ws_dam_immun_" + IntToString(iSubType)) + ConvertNumToImmunePercentage(GetItemPropertyCostTableValue(ip)) );
                    break;
                case 24: // Damage Vulnerability
                    SetLocalInt(oPC, "ws_dam_immun_" + IntToString(iSubType), GetLocalInt(oPC, "ws_dam_immun_" + IntToString(iSubType)) - ConvertNumToImmunePercentage(GetItemPropertyCostTableValue(ip)) );
                    break;
            };
        }
        ip = GetNextItemProperty(oItem);
    }
    return ePoly;
}
// if bItems is TRUE, Adds all the stackable properties on all the objects given to ePoly.
// if bItems is FALSE, Adds only the stackable properties on armor and helmet to ePoly.
effect AddStackablePropertiesToPoly ( object oPC, effect ePoly, int bWeapon, int bItems, int bArmor, object oArmorOld, object oRing1Old,
                                      object oRing2Old, object oAmuletOld, object oCloakOld, object oBracerOld,
                                      object oBootsOld, object oBeltOld, object oHelmetOld, object oShield, object oWeapon, object oHideOld)
{
    if (bArmor ) // Armor properties get carried over
    {
        ePoly = ExamineStackableProperties ( oPC, ePoly, oArmorOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oHelmetOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oShield );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oHideOld );
    }
    if ( bItems ) // Item properties get carried over
    {
        ePoly = ExamineStackableProperties ( oPC, ePoly, oRing1Old );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oRing2Old );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oAmuletOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oCloakOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oBootsOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oBeltOld );
        ePoly = ExamineStackableProperties ( oPC, ePoly, oBracerOld );
    }
    // AC bonuses are attached to ePoly inside ExamineStackableProperties
    int i; // This will loop over all the different ability subtypes (eg str, dex, con, etc)
    int j; // This will contain the sum of the stackable bonus type we're looking at
    for ( i = 0; i <= 5; i++ ) // **** Handle Ability Bonuses ****
    {
        j = GetLocalInt(oPC, "ws_ability_" + IntToString(i));
        // Add the sum of this ability bonus to the polymorph effect.
        if ( j > 0 ) // Sum was Positive
            ePoly = EffectLinkEffects(EffectAbilityIncrease(i, j), ePoly);
        else if ( j < 0 ) // Sum was Negative
            ePoly = EffectLinkEffects(EffectAbilityDecrease(i, -j), ePoly);
        DeleteLocalInt(oPC, "ws_ability_" + IntToString(i));
    }
    for ( i = 0; i <= 26; i++ ) // **** Handle Skill Bonuses ****
    {
        j = GetLocalInt(oPC, "ws_skill_" + IntToString(i));
        // Add the sum of this skill bonus to the polymorph effect.
        if ( j > 0 ) // Sum was Positive
            ePoly = EffectLinkEffects(EffectSkillIncrease(i, j), ePoly);
        else if ( j < 0 ) // Sum was Negative
            ePoly = EffectLinkEffects(EffectSkillDecrease(i, -j), ePoly);
        DeleteLocalInt(oPC, "ws_skill_" + IntToString(i));
    }
    for ( i = 0; i <= 21; i++ ) // **** Handle Saving Throw vs element Bonuses ****
    {
        j = GetLocalInt(oPC, "ws_save_elem_" + IntToString(i));
        // Add the sum of this saving throw bonus to the polymorph effect.
        if ( j > 0 ) // Sum was Positive
            ePoly = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_ALL, j, i), ePoly);
        else if ( j < 0 ) // Sum was Negative
            ePoly = EffectLinkEffects(EffectSavingThrowDecrease(SAVING_THROW_ALL, -j, i), ePoly);
        DeleteLocalInt(oPC, "ws_save_elem_" + IntToString(i));
    }
    for ( i = 0; i <= 3; i++ ) // **** Handle Saving Throw specific Bonuses ****
    {
        j = GetLocalInt(oPC, "ws_save_spec_" + IntToString(i));
        // Add the sum of this saving throw bonus to the polymorph effect.
        if ( j > 0 ) // Sum was Positive
            ePoly = EffectLinkEffects(EffectSavingThrowIncrease(i, j), ePoly);
        else if ( j < 0 ) // Sum was Negative
            ePoly = EffectLinkEffects(EffectSavingThrowDecrease(i, -j), ePoly);
        DeleteLocalInt(oPC, "ws_save_spec_" + IntToString(i));
    }
    j = GetLocalInt(oPC, "ws_regen");
    if ( j > 0 )
    {
        ePoly = EffectLinkEffects(EffectRegenerate(j, 6.0), ePoly);
        DeleteLocalInt(oPC, "ws_regen" );
    }
    for ( i = 0; i <= 13; i++ ) // **** Handle Damage Immunity and Vulnerability ****
    {
        j = GetLocalInt(oPC, "ws_dam_immun_" + IntToString(i));
        // Add the sum of this Damage Immunity/Vulnerability to the polymorph effect.
        if ( j > 0 ) // Sum was Positive
            ePoly = EffectLinkEffects(EffectDamageImmunityIncrease(ConvertNumToDamTypeConstant ( i ), j), ePoly);
        else if ( j < 0 ) // Sum was Negative
            ePoly = EffectLinkEffects(EffectDamageImmunityDecrease(ConvertNumToDamTypeConstant ( i ), -j), ePoly);
        DeleteLocalInt(oPC, "ws_dam_immun_" + IntToString(i));
    }

    return ePoly; // Finally, we have the entire (possibly huge :P  ) effect to be applied to the shifter.
}

// Returns the spell that applied a Polymorph Effect currently on the player.
// -1 if it was no spell, -2 if no polymorph effect found.
int ScanForPolymorphEffect(object oPC)
{
    effect eEffect = GetFirstEffect(oPC);
    while ( GetIsEffectValid(eEffect) )
    {
        if ( GetEffectType( eEffect ) == EFFECT_TYPE_POLYMORPH )
        {
            return GetEffectSpellId(eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }
    return -2;
}

// Converts a number from iprp_damagetype.2da to the corresponding
// DAMAGE_TYPE_* constants.
int ConvertNumToDamTypeConstant ( int iItemDamType )
{
    switch ( iItemDamType )
    {
        case 0:
            return DAMAGE_TYPE_BLUDGEONING;
            break;
        case 1:
            return DAMAGE_TYPE_PIERCING;
            break;
        case 2:
            return DAMAGE_TYPE_SLASHING;
            break;
        case 5:
            return DAMAGE_TYPE_MAGICAL;
            break;
        case 6:
            return DAMAGE_TYPE_ACID;
            break;
        case 7:
            return DAMAGE_TYPE_COLD;
            break;
        case 8:
            return DAMAGE_TYPE_DIVINE;
            break;
        case 9:
            return DAMAGE_TYPE_ELECTRICAL;
            break;
        case 10:
            return DAMAGE_TYPE_FIRE;
            break;
        case 11:
            return DAMAGE_TYPE_NEGATIVE;
            break;
        case 12:
            return DAMAGE_TYPE_POSITIVE;
            break;
        case 13:
            return DAMAGE_TYPE_SONIC;
            break;
        default:
            return DAMAGE_TYPE_POSITIVE;
            break;
    };
    // This one might seem unneccesary but it wont compile otherwise
    return DAMAGE_TYPE_POSITIVE;
}

// Converts a number from iprp_immuncost.2da to the corresponding percentage of immunity
int ConvertNumToImmunePercentage ( int iImmuneCost )
{
    switch ( iImmuneCost )
    {
        case 1:
            return 5;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 25;
            break;
        case 4:
            return 50;
            break;
        case 5:
            return 75;
            break;
        case 6:
            return 90;
            break;
        case 7:
            return 100;
            break;
//        default:
//            return 0;
//            break;
    };

    if(iImmuneCost > 50 && iImmuneCost <= 150)
        return iImmuneCost - 50;

    return 0;
}

void WildshapeCopyWeaponProperties(object oPC, object oOld, object oNew)
{
    object oAmmo;
    itemproperty ip;
    int bAmmo;

    if(!GetIsObjectValid(oOld) || !GetIsObjectValid(oNew))
        return;

    // If original is a Melee Weapon...
    if (!GetWeaponRanged(oOld)){
        // If the new weapon is ranged...apply bonuses to ammo.
        if(GetWeaponRanged(oNew)){
            // TODO: Do Something about Mighty, etc here.
            int nEnhance = GetItemEnhancementBonus(oOld);
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(nEnhance),oNew);
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMaxRangeStrengthMod(nEnhance),oNew);

            // Find Ammo...
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            if(oAmmo == OBJECT_INVALID)
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            if(oAmmo == OBJECT_INVALID)
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);

            //oNew = oAmmo; // We transfer to oAmmo.
            bAmmo = TRUE;

        }
        // Copy over item properties...those that don't work on the arrows,
        // will not transfer.
        ip = GetFirstItemProperty(oOld);
        while (GetIsItemPropertyValid(ip)){
            if(bAmmo){
                if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS)
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oAmmo);
                else if(GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS ||
                        GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS)
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
                }
            }
            else
                AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);

            ip = GetNextItemProperty(oOld);
        }
    }
/* We don't care about the original bow case.
    // If both are Ranged Weapons
    else if ( GetWeaponRanged(oOld) && GetWeaponRanged(oNew) ){
        int bUnlimitedAmmoFound = FALSE;
        itemproperty ipNew;
        int iOldMightyValue = 0;
            while (GetIsItemPropertyValid(ip))
            {
                if ( GetItemPropertyType(ip) == 61 ) // 61 = Unlimited Ammo
                {
                    // For some reason, when removing/replacing an unlimited
                    // ammo property, the corresponding missile type will get
                    // dropped in the player's inventory, so we have to remove
                    // that missile again to prevent abuse.
                    bUnlimitedAmmoFound = TRUE;
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                    if ( !GetIsObjectValid( oAmmo ) )
                        oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                    if ( !GetIsObjectValid( oAmmo ) )
                        oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                    IPRemoveMatchingItemProperties(oNew, ITEM_PROPERTY_UNLIMITED_AMMUNITION, DURATION_TYPE_PERMANENT );
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
                    DestroyObject(oAmmo);
                }
                else if ( GetItemPropertyType(ip) == 45 ) // 45 = Mighty
                {
                    ipNew = GetFirstItemProperty(oNew);
                    // Find the mighty value of the Polymorph's weapon
                    while ( GetIsItemPropertyValid(ipNew) )
                    {
                        if ( GetItemPropertyType( ipNew ) == 45 )
                        {
                            iOldMightyValue = GetItemPropertyCostTableValue( ipNew );
                            break;
                        }
                        ipNew = GetNextItemProperty(oNew);
                    } // while
                    // If new mighty value bigger, remove old one and add new one.
                    if ( GetItemPropertyCostTableValue(ip) > iOldMightyValue )
                    {
                        RemoveItemProperty(oNew, ipNew);
                        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
                    }
                }
                else
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);

                ip = GetNextItemProperty(oOld);
            } // while

            // Add basic unlimited ammo if neccesary
            if ( bUnlimitedAmmoFound == FALSE && !GetItemHasItemProperty(oNew, ITEM_PROPERTY_UNLIMITED_AMMUNITION ) )
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo(), oNew);
        }
    }
    else if ( GetWeaponRanged(oNew) )
    {
        // Add basic unlimited ammo if neccesary
        if ( !GetItemHasItemProperty(oNew, ITEM_PROPERTY_UNLIMITED_AMMUNITION ) )
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo(), oNew);
    }
*/
}

// Returns TRUE if oItem is a creature claw or bite.
int GetIsCreatureWeapon( object oItem )
{
    int iBaseItemType = GetBaseItemType(oItem);
    switch ( iBaseItemType )
    {
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
            return TRUE;
        default:
            return FALSE;
    };
    return FALSE;
}

void AddWeaponFeatsToItem(object oSkin, int nWeaponType, int bWF, int bEWF,
                          int bWS, int bEWS, int bIC, int bOC, int bDC, int bWC)
{
    int nOffset;
    switch(nWeaponType){
        case BASE_ITEM_BASTARDSWORD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_BASTARDSWORD), oSkin);
        break;
        case BASE_ITEM_BATTLEAXE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_BATTLE_AXE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_BATTLEAXE), oSkin);
        break;
        case BASE_ITEM_DOUBLEAXE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_DOUBLE_AXE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_DOUBLEAXE), oSkin);
        break;
        case BASE_ITEM_GREATAXE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_GREAT_AXE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREATAXE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATAXE), oSkin);
        break;
        case BASE_ITEM_FALCHION:
        case BASE_ITEM_GREATSWORD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_GREAT_SWORD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREATSWORD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATSWORD), oSkin);
        break;
        case BASE_ITEM_HALBERD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_HALBERD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HALBERD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_HALBERD), oSkin);
        break;
        case BASE_ITEM_HANDAXE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_HAND_AXE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HANDAXE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_HANDAXE), oSkin);
        break;
        case BASE_ITEM_KAMA:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_KAMA), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KAMA), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KAMA), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_KAMA), oSkin);
        break;
        case BASE_ITEM_KATANA:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_KATANA), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KATANA), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KATANA), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_KATANA), oSkin);
        break;
        case BASE_ITEM_KUKRI:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_KUKRI), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KUKRI), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_KUKRI), oSkin);
        break;
        case BASE_ITEM_LONGSWORD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_LONG_SWORD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONGSWORD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD), oSkin);
        break;
        case BASE_ITEM_SCYTHE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_SCYTHE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCYTHE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_SCYTHE), oSkin);
        break;
        case BASE_ITEM_HEAVYPICK:
        case BASE_ITEM_LIGHTPICK:
        case BASE_ITEM_SICKLE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_SICKLE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SICKLE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_SICKLE), oSkin);
        break;
        case BASE_ITEM_DOUBLESCIMITAR:
        case BASE_ITEM_TWOBLADEDSWORD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD), oSkin);
        break;
        case BASE_ITEM_CLUB:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_CLUB), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_CLUB), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_CLUB), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_CLUB), oSkin);
        break;
        case BASE_ITEM_ASSASSINDAGGER:
        case BASE_ITEM_DAGGER:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_DAGGER), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER), oSkin);
        break;
        case BASE_ITEM_GLOVES:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_UNARMED), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(18), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED), oSkin);
        break;
        case BASE_ITEM_DIREMACE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_DIRE_MACE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DIREMACE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_DIREMACE), oSkin);
        break;
        case BASE_ITEM_HEAVYFLAIL:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_HEAVY_FLAIL), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL), oSkin);
        break;
        case BASE_ITEM_LIGHTFLAIL:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_FLAIL), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL), oSkin);
        break;
        case BASE_ITEM_LIGHTHAMMER:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_HAMMER), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER), oSkin);
        break;
        case BASE_ITEM_HEAVYMACE:
        case BASE_ITEM_LIGHTMACE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_MACE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTMACE), oSkin);
        break;
        case BASE_ITEM_MORNINGSTAR:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_MORNING_STAR), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_MORNINGSTAR), oSkin);
        break;
        case BASE_ITEM_QUARTERSTAFF:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_STAFF), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF), oSkin);
        break;
        case BASE_ITEM_RAPIER:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_RAPIER), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_RAPIER), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_RAPIER), oSkin);
        break;
        case BASE_ITEM_WHIP:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_WHIP), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WHIP), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WHIP), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_WHIP), oSkin);
        break;
        case BASE_ITEM_SHORTSPEAR:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_SPEAR), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSPEAR), oSkin);
        break;
        case BASE_ITEM_SHORTSWORD:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD), oSkin);
        break;
        case BASE_ITEM_MAUL:
        case BASE_ITEM_WARHAMMER:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_WAR_HAMMER), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WARHAMMER), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_WARHAMMER), oSkin);
        break;
        case BASE_ITEM_DWARVENWARAXE:
            if(bWF)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FOCUS_DWAXE), oSkin);
            if(bEWF) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DWAXE), oSkin);
            if(bWS)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE), oSkin);
            if(bEWS) AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE), oSkin);
            if(bIC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE), oSkin);
            if(bOC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE), oSkin);
            if(bDC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE), oSkin);
            if(bWC)  AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_OF_CHOICE_DWAXE), oSkin);
        break;
           case BASE_ITEM_TRIDENT:
            // No trident properties.
        break;
    }
}

void DoWeaponFeats(object oPC, object oSkin, int nWeaponType){
    int bWF, bEWF, bWS, bEWS, bIC, bOC, bDC, bWC, i;

    // Weapon Focus
    if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB, oPC)) // Club
        bWF = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP, oPC)) // Whip
        bWF = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_FOCUS_TRIDENT, oPC)) // Trident
        bWF = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE, oPC)) // Dwarven Waraxe
        bWF = TRUE;
    else {
        for(i = 90; i <= 127 ; i++){
            if(GetHasFeat(i, oPC)){
                bWF = TRUE;
                break;
            }
        }
    }

    // Epic Weapon Focus
    if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CLUB, oPC)) // Club
        bEWF = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_WHIP, oPC)) // Whip
        bEWF = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_TRIDENT, oPC))// Trident
        bEWF = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DWAXE, oPC))// dwaxe
        bEWF = TRUE;
    else {
        for(i = 619; i <= 656 ; i++){
            if(GetHasFeat(i, oPC)){
                bEWF = TRUE;
                break;
            }
        }
    }
    // Weapon Specialization
    if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CLUB, oPC)) // Club
        bWS = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_WHIP, oPC)) // Whip
        bWS = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_TRIDENT, oPC))// Trident
        bWS = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_SPECIALIZATION_DWAXE, oPC))// dwaxe
        bWS = TRUE;
    else {
        for(i = 128; i <= 161 ; i++){
            if(GetHasFeat(i, oPC)){
                bWS = TRUE;
                break;
            }
        }
    }
    // Epic Weapon Specialization
    if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP, oPC)) // Whip
        bEWS = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT, oPC))// Trident
        bEWS = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE, oPC))// dwaxe
        bEWS = TRUE;
    else {
        for(i = 657; i <= 694 ; i++){
            if(GetHasFeat(i, oPC)){
                bEWS = TRUE;
                break;
            }
        }
    }

    // Improved Critical
    if(GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB, oPC)) // Club
        bIC = TRUE;
    else if(GetHasFeat(FEAT_IMPROVED_CRITICAL_WHIP, oPC)) // Whip
        bIC = TRUE;
    else if(GetHasFeat(FEAT_IMPROVED_CRITICAL_TRIDENT, oPC))// Trident
        bIC = TRUE;
    else if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE, oPC))// dwaxe
        bIC = TRUE;
    else {
        for(i = 52; i <= 85 ; i++){
            if(GetHasFeat(i, oPC)){
                bIC = TRUE;
                break;
            }
        }
    }
    // Overwhelming Critical
    if(GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP, oPC)) // Whip
        bOC = TRUE;
    else if(GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT, oPC))// Trident
        bOC = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE, oPC))// dwaxe
        bOC = TRUE;
    else {
        for(i = 709; i <= 746; i++){
            if(GetHasFeat(i, oPC)){
                bOC = TRUE;
                break;
            }
        }
    }
    // Devistating Critical
    if(GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_WHIP, oPC))// Whip
        bDC = TRUE;
    else if(GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT, oPC))// Trident
        bDC = TRUE;
    else if(GetHasFeat(FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE, oPC))// dwaxe
        bDC = TRUE;
    else {
        for(i = 495; i <= 532 ; i++){
            if(GetHasFeat(i, oPC)){
                bDC = TRUE;
                break;
            }
        }
    }

    // Weapon of Choice
    if(GetHasFeat(FEAT_WEAPON_OF_CHOICE_DWAXE, oPC)) // dwas
        bWC = TRUE;
    else if(GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_WHIP, oPC)) // Whip
        bWC = TRUE;
    else if(GetHasFeat(FEAT_WEAPON_OF_CHOICE_TRIDENT, oPC))// Trident
        bWC = TRUE;

    if(!bWC) {
        for(i = 919; i <= 943 ; i++){
            if(GetHasFeat(i, oPC)){
                bWC = TRUE;
                break;
            }
        }
    }
    if(!bWC) {
        for(i = 879; i <= 881 ; i++){
            if(GetHasFeat(i, oPC)){
                bWC = TRUE;
                break;
            }
        }
    }

    AddWeaponFeatsToItem(oSkin, nWeaponType, bWF, bEWF, bWS, bEWS, bIC, bOC, bDC, bWC);

}

void ApplyNaturalSpellPolymorph(object oTarget, int nPoly) {
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int nAppearance = GetAppearanceType(oTarget);
    int nNewAppearance = StringToInt(Get2DAString("polymorph.2da", "AppearanceType", nPoly));
    string sPortrait = GetPortrait(oTarget);
    string sNewPortrait = Get2DAString("polymorph.2da", "Portrait", nPoly);


}

void ApplyPolymorph(object oTarget, int nPoly, int nWeaponType){
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;
    int nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);

    //--------------------------------------------------------------------------
    // Determine which items get their item properties merged onto the shifters
    // new form.
    //--------------------------------------------------------------------------
    int bWeapon, bArmor, bItems, bCopyGlovesToClaws = FALSE;

    bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;

    if ( WS_ALWAYS_COPY_ARMOR_PROPS )
        bArmor = TRUE;
    else
        bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;

    if ( WS_ALWAYS_COPY_ITEM_PROPS )
        bItems = TRUE;
    else
        bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    // Send message to PC about which items get merged to this form
    string sMerge;
    sMerge = "Merged: "; // <c~¬þ>: This is a color code that makes the text behind it sort of light blue.
    if(bArmor) sMerge += "<cazþ>Armor, Helmet, Shield";
    if(bItems) sMerge += ",</c> <caþa>Rings, Amulet, Cloak, Boots, Belt, Bracers";
    if( bWeapon || GW_COPY_WEAPON_PROPS_TO_UNARMED == 1 )
        sMerge += ",</c> <cþAA>Weapon";
    else if ( GW_COPY_WEAPON_PROPS_TO_UNARMED == 2 )
        sMerge += ",</c> <cþAA>Gloves to unarmed attacks";
    else if (GW_COPY_WEAPON_PROPS_TO_UNARMED == 3 )
        sMerge += ",</c> <cþAA>Weapon (if you had one equipped) or gloves to unarmed attacks";
    else
        sMerge += ",</c> <cþAA>No weapon or gloves to unarmed attacks";
    SendMessageToPC(oTarget,sMerge + ".</c>");

    // Store which items should transfer to this polymorph type. (For exportallchar scripts)
    SetLocalInt(oTarget, "GW_PolyID", nPoly);
    SetLocalInt(oTarget, "GW_bWeapon", bWeapon );
    SetLocalInt(oTarget, "GW_bArmor", bArmor );
    SetLocalInt(oTarget, "GW_bItems", bItems );

    //--------------------------------------------------------------------------
    // Store the old objects so we can access them after the character has
    // changed into his new form
    //--------------------------------------------------------------------------
    object oWeaponOld, oArmorOld, oRing1Old, oRing2Old, oAmuletOld, oCloakOld,
        oBootsOld, oBeltOld, oHelmetOld, oShield, oBracerOld, oHideOld;

    //Assume the normal shape doesn't have a creature skin object.
    //If using a subracesystem or something else that places a skin on the normal shape
    //another condition is needed to decide whether or not to store current items.
    //One way could be to scan all effects to see whether one is a polymorph effect.
    int nPolyed = GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget));
    // If there is a creature armor see if it is a creature hide put
    // on the unpolymorphed player by scanning for a polymorph effect.
    if ( nPolyed )
        nPolyed = ( ScanForPolymorphEffect(oTarget) != -2 );
    if(! nPolyed)
    {
        //if not polymorphed get items worn and store on player.
        oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
        oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,oTarget);
        oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oTarget);
        oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oTarget);
        oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oTarget);
        oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oTarget);
        oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oTarget);
        oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oTarget);
        oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oTarget);
        oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget);
        oBracerOld  = GetItemInSlot(INVENTORY_SLOT_ARMS,oTarget);
        oHideOld = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
        SetLocalObject(oTarget,"GW_OldWeapon",oWeaponOld);
        SetLocalObject(oTarget,"GW_OldArmor",oArmorOld);
        SetLocalObject(oTarget,"GW_OldRing1",oRing1Old);
        SetLocalObject(oTarget,"GW_OldRing2",oRing2Old);
        SetLocalObject(oTarget,"GW_OldAmulet",oAmuletOld);
        SetLocalObject(oTarget,"GW_OldCloak",oCloakOld);
        SetLocalObject(oTarget,"GW_OldBoots",oBootsOld);
        SetLocalObject(oTarget,"GW_OldBelt",oBeltOld);
        SetLocalObject(oTarget,"GW_OldHelmet",oHelmetOld);
        SetLocalObject(oTarget,"GW_OldBracer",oBracerOld);
        SetLocalObject(oTarget,"GW_OldHide",oHideOld);
        if (GetIsObjectValid(oShield))
        {
            if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
                GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
                GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
            {
                oShield = OBJECT_INVALID;
            }
        }
        SetLocalObject(oTarget,"GW_OldShield",oShield);

    }
    else
    {
        //if already polymorphed use items stored earlier.
        oWeaponOld =     GetLocalObject(oTarget,"GW_OldWeapon");
        oArmorOld  =     GetLocalObject(oTarget,"GW_OldArmor");
        oRing1Old  =     GetLocalObject(oTarget,"GW_OldRing1");
        oRing2Old  =     GetLocalObject(oTarget,"GW_OldRing2");
        oAmuletOld =     GetLocalObject(oTarget,"GW_OldAmulet");
        oCloakOld  =     GetLocalObject(oTarget,"GW_OldCloak");
        oBootsOld  =     GetLocalObject(oTarget,"GW_OldBoots");
        oBeltOld   =     GetLocalObject(oTarget,"GW_OldBelt");
        oHelmetOld =     GetLocalObject(oTarget,"GW_OldHelmet");
        oShield    =     GetLocalObject(oTarget,"GW_OldShield");
        oBracerOld =     GetLocalObject(oTarget,"GW_OldBracer");
        oHideOld   =     GetLocalObject(oTarget,"GW_OldHide");
    }

    //--------------------------------------------------------------------------
    // Here the actual polymorphing is done
    //--------------------------------------------------------------------------
    ePoly = EffectPolymorph(nPoly);
    //--------------------------------------------------------------------------
    // Iznoghoud: Link the stackable properties as permanent bonuses to the
    // Polymorph effect, instead of putting them on the creature hide. They will
    // properly disappear as soon as the polymorph is ended.
    //--------------------------------------------------------------------------
    ePoly = AddStackablePropertiesToPoly ( oTarget, ePoly, bWeapon, bItems, bArmor, oArmorOld, oRing1Old, oRing2Old, oAmuletOld, oCloakOld, oBracerOld, oBootsOld, oBeltOld, oHelmetOld, oShield, oWeaponOld, oHideOld);


    int nABBonus;
    if(GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) > 5){
        nABBonus = GetLevelByClass(CLASS_TYPE_SHIFTER, oTarget) / 5;
        ePoly = EffectLinkEffects(ePoly, EffectAttackIncrease(nABBonus));
        WriteTimestampedLogEntry("DEBUG : Shifter AB Bonus : " + IntToString(nABBonus));
    }

    ePoly = ExtraordinaryEffect(ePoly);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget);
    SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
    object oClawLeft = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget);
    object oClawRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget);
    object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget);
    //--------------------------------------------------------------------------
    // ...Weapons
    //--------------------------------------------------------------------------
    if (bWeapon)
    {
        //----------------------------------------------------------------------
        // GZ: 2003-10-20
        // Sorry, but I was forced to take that out, it was confusing people
        // and there were problems with updating the stats sheet.
        //----------------------------------------------------------------------
        /* if (!GetIsObjectValid(oWeaponOld))
        {
            //------------------------------------------------------------------
            // If we had no weapon equipped before, remove the old weapon
            // to allow monks to change into unarmed forms by not equipping any
            // weapon before polymorphing
            //------------------------------------------------------------------
            DestroyObject(oWeaponNew);
        }
        else*/
        {
            //------------------------------------------------------------------
            // Merge item properties...
            //------------------------------------------------------------------
            WildshapeCopyWeaponProperties(oTarget, oWeaponOld,oWeaponNew);
        }
    }
    else {
        switch ( GW_COPY_WEAPON_PROPS_TO_UNARMED )
        {
        case 1: // Copy over weapon properties to claws/bite
            WildshapeCopyNonStackProperties(oWeaponOld,oClawLeft, TRUE);
            WildshapeCopyNonStackProperties(oWeaponOld,oClawRight, TRUE);
            WildshapeCopyNonStackProperties(oWeaponOld,oBite, TRUE);
            break;
        case 2: // Copy over glove properties to claws/bite
            WildshapeCopyNonStackProperties(oBracerOld,oClawLeft, FALSE);
            WildshapeCopyNonStackProperties(oBracerOld,oClawRight, FALSE);
            WildshapeCopyNonStackProperties(oBracerOld,oBite, FALSE);
            bCopyGlovesToClaws = TRUE;
            break;
        case 3: // Copy over weapon properties to claws/bite if wearing a weapon, otherwise copy gloves
            if ( GetIsObjectValid(oWeaponOld) )
            {
                WildshapeCopyNonStackProperties(oWeaponOld,oClawLeft, TRUE);
                WildshapeCopyNonStackProperties(oWeaponOld,oClawRight, TRUE);
                WildshapeCopyNonStackProperties(oWeaponOld,oBite, TRUE);
            }
            else
            {
                WildshapeCopyNonStackProperties(oBracerOld,oClawLeft, FALSE);
                WildshapeCopyNonStackProperties(oBracerOld,oClawRight, FALSE);
                WildshapeCopyNonStackProperties(oBracerOld,oBite, FALSE);
                bCopyGlovesToClaws = TRUE;
            }
            break;
        default: // Do not copy over anything
            break;
        };
    }
    //--------------------------------------------------------------------------
    // ...Armor
    //--------------------------------------------------------------------------
    if (bArmor){
        // Add Bonus Weapon Feats
        if(nWeaponType >= 0)
            DelayCommand(0.5, DoWeaponFeats(oTarget, oArmorNew, nWeaponType));

        //----------------------------------------------------------------------
        // Merge item properties from armor and helmet...
        //----------------------------------------------------------------------
        WildshapeCopyNonStackProperties(oArmorOld,oArmorNew);
        WildshapeCopyNonStackProperties(oHelmetOld,oArmorNew);
        WildshapeCopyNonStackProperties(oShield,oArmorNew);
        WildshapeCopyNonStackProperties(oHideOld,oArmorNew);
    }
    //--------------------------------------------------------------------------
    // ...Magic Items
    //--------------------------------------------------------------------------
    if (bItems)
    {
        //----------------------------------------------------------------------
        // Merge item properties from from rings, amulets, cloak, boots, belt
        // Iz: And bracers, in case oBracerOld gets set to a valid object.
        //----------------------------------------------------------------------
        WildshapeCopyNonStackProperties(oRing1Old,oArmorNew);
        WildshapeCopyNonStackProperties(oRing2Old,oArmorNew);
        WildshapeCopyNonStackProperties(oAmuletOld,oArmorNew);
        WildshapeCopyNonStackProperties(oCloakOld,oArmorNew);
        WildshapeCopyNonStackProperties(oBootsOld,oArmorNew);
        WildshapeCopyNonStackProperties(oBeltOld,oArmorNew);
        // Because Bracers can have On Hit Cast Spell type properties we should
        // avoid copying the bracers twice. Otherwise the player can get that On
        // Hit effect both when hitting, and getting hit.
        if ( bCopyGlovesToClaws == FALSE )
            WildshapeCopyNonStackProperties(oBracerOld,oArmorNew);
    }
    //--------------------------------------------------------------------------
    // Set artificial usage limits for special ability spells to work around
    // the engine limitation of not being able to set a number of uses for
    // spells in the polymorph radial
    //--------------------------------------------------------------------------
    ShifterSetGWildshapeSpellLimits(GetSpellId());
}

// **** End Functions, added by Iznoghoud ****
