//::///////////////////////////////////////////////
//:: Greater Wild Shape, Humanoid Shape
//:: x2_s2_gwildshp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the character to shift into one of these
    forms, gaining special abilities
    Credits must be given to mr_bumpkin from the NWN
    community who had the idea of merging item properties
    from weapon and armor to the creatures new forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-02
//:://////////////////////////////////////////////
//:: Modified By: Iznoghoud
/*
What this script changes:
- Tower shields now carry over their properties just like Small and Large
shields. (Which has been a bug I believe since the original script had 2 checks
for SMALLSHIELD in it, one probably should have been TOWERSHIELD)
- Melee Weapon properties now carry over to the unarmed forms' claws and bite
attacks.
- My last (and most complicated) changes:
1) Now, items with an AC bonus (or penalty) carry over to the shifted form as
the correct type. This means if you wear an amulet of natural armor +4, and a
cloak of protection +5, and you shift to a form that gets all item properties
carried over, you will have the +4 natural armor bonus from the ammy, as well as
the +5 deflection bonus from the cloak. No longer will the highest one override
all the other AC bonuses even if they are a different type. Note that some
forms, such as the dragon, get an inherent natural AC bonus, which may still
override your amulet of natural armor, if the inherent bonus is better.
2) Other "stackable" item properties, like ability bonuses, skill bonuses and
saving throw bonuses, now correctly add up in shifted form. This means if you
have a ring that gives +2 strength, and a ring with +3 strength, and you shift
into a drow warrior, you get +5 strength in shifted form, where you used to get
only +3. (the highest)

-- Modified by StoneDK 2003.12.21
Added saving of old equip to allow items to be applied without going
through normal shape, should now get item effects even when changing
directly from wyrm to kobold shape.
Added message to player about which items are merged.

-- Modified by Iznoghoud 2003-12-26
Added storing of Polymorph ID on the player for letting exportallchars() scripts
reapply polymorphing effects when saving

-- Modified by Iznoghoud 2003-12-27
Added regeneration as a stacking property, bracers now stored correctly for re-shifting,
Added constants for easy configuration.

-- Modified by Iznoghoud January 13 2004
The bulk of the handling of stacking item properties, as well as the constants
for configuration, are now in ws_inc_shifter, which is included
by this file, and the two druid polymorphing scripts, nw_s2_elemshape and nw_s2_wildshape.
Made the message about which items are merged more explicit.
*/
//:://////////////////////////////////////////////

#include "ws_inc_shifter"
#include "x3_inc_horse"
#include "pc_funcs_inc"


// Main function of the script
void main()
{
    //--------------------------------------------------------------------------
    // Declare major variables
    //--------------------------------------------------------------------------
    object oPC = OBJECT_SELF;
    int    nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    int    nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);
    int    nPoly, nWeaponType = BASE_ITEM_GLOVES;

    //--------------------------------------------------------------------------
    // Determine which form to use based on spell id, gender and level
    //--------------------------------------------------------------------------
    switch (nSpell)
    {
        //-----------------------------------------------------------------------
        // Greater Wildshape I - Wyrmling Shape
        //-----------------------------------------------------------------------
        case 658:  nPoly = POLYMORPH_TYPE_WYRMLING_RED; break;
        case 659:  nPoly = POLYMORPH_TYPE_WYRMLING_BLUE; break;
        case 660:  nPoly = POLYMORPH_TYPE_WYRMLING_BLACK; break;
        case 661:  nPoly = POLYMORPH_TYPE_WYRMLING_WHITE; break;
        case 662:  nPoly = POLYMORPH_TYPE_WYRMLING_GREEN; break;
        //-----------------------------------------------------------------------
        // Greater Wildshape II  - Minotaur, Gargoyle, Harpy
        //-----------------------------------------------------------------------
        case 672: if (nShifter < X2_GW2_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_HARPY;
                  else
                     nPoly = 97;
                  break;
        case 678:
            if (nShifter < X2_GW2_EPIC_THRESHOLD)
                nPoly = POLYMORPH_TYPE_GARGOYLE;
            else
                nPoly = 98;
        break;
        case 680:
            nWeaponType = BASE_ITEM_GREATAXE;
            if (nShifter < X2_GW2_EPIC_THRESHOLD)
                nPoly = POLYMORPH_TYPE_MINOTAUR;
            else
                nPoly = 96;
        break;
        //-----------------------------------------------------------------------
        // Greater Wildshape III  - Drider, Basilisk, Manticore
        //-----------------------------------------------------------------------
        case 670: if (nShifter < X2_GW3_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_BASILISK;
                  else
                     nPoly = 99;
                  break;
        case 673:
            nWeaponType = BASE_ITEM_SHORTSPEAR;
            if (nShifter < X2_GW3_EPIC_THRESHOLD)
                nPoly = POLYMORPH_TYPE_DRIDER;
            else
                nPoly = 100;
            break;
        case 674: if (nShifter < X2_GW3_EPIC_THRESHOLD)
                     nPoly = POLYMORPH_TYPE_MANTICORE;
                  else
                     nPoly = 101;
                  break;
       //-----------------------------------------------------------------------
       // Greater Wildshape IV - Dire Tiger, Medusa, MindFlayer
       //-----------------------------------------------------------------------
        case 679: nPoly = POLYMORPH_TYPE_MEDUSA; break;
        case 691: nPoly = 68; break; // Mindflayer
        case 694: nPoly = 69; break; // DireTiger
       //-----------------------------------------------------------------------
       // Humanoid Shape - Kobold Commando, Drow, Lizard Whip Specialist
       //-----------------------------------------------------------------------
        case 682: //drow
            nWeaponType = BASE_ITEM_LONGSWORD;
            if(nShifter< 17){
                if (GetGender(OBJECT_SELF) == GENDER_MALE)
                    nPoly = 59;
                else
                    nPoly = 70;
            }
            else{
                if (GetGender(OBJECT_SELF) == GENDER_MALE) //drow
                    nPoly = 105;
                else
                    nPoly = 106;
                }
        break;
        case 683: // Lizard
            nWeaponType = BASE_ITEM_WHIP;
            nPoly = (nShifter < 17) ? 82 : 104;
        break;
        case 684: // Kobold
            nWeaponType = BASE_ITEM_DAGGER;
            nPoly = (nShifter < 17) ? 83 : 103;
        break;
        //-----------------------------------------------------------------------
        // Undead Shape - Spectre, Risen Lord, Vampire
        //-----------------------------------------------------------------------
        case 704: // Risen lord
            nWeaponType = BASE_ITEM_SCYTHE;
            nPoly = 75;
        break;
        case 705: // vampire
            if (GetGender(OBJECT_SELF) == GENDER_MALE)
                nPoly = 74;
            else
                nPoly = 77;
        break;
        case 706: // spectre
            nPoly = 76;
        break;

        //-----------------------------------------------------------------------
        // Dragon Shape - Red Blue and Green Dragons
        //-----------------------------------------------------------------------
        case 707: // Ancient Red Dragon
            if(GetPlayerInt(OBJECT_SELF, "pc_dragshape")) // kin
                nPoly = 153;
            else
                nPoly = 72;
        break;
        case 708:  // Ancient Blue  Dragon
            if(GetPlayerInt(OBJECT_SELF, "pc_dragshape")) // kin
                nPoly = 152;
            else
                nPoly = 71;
        break;
        case 709: // Ancient Green Dragon
            if(GetPlayerInt(OBJECT_SELF, "pc_dragshape")) // kin
                nPoly = 154;
            else
                nPoly = 73;
        break;

        //-----------------------------------------------------------------------
        // Outsider Shape - Rakshasa, Azer Chieftain, Black Slaad
        //-----------------------------------------------------------------------

        case 733: // Azer
            nWeaponType = BASE_ITEM_DWARVENWARAXE;
            nPoly = (GetGender(OBJECT_SELF) == GENDER_MALE) ? 85 : 86;
        break;
        case 734: // Rakasha
            nWeaponType = BASE_ITEM_RAPIER;
            nPoly = (GetGender(OBJECT_SELF) == GENDER_MALE) ? 88 : 89;
        break;
        case 735: nPoly =87; break; // slaad

        //-----------------------------------------------------------------------
        // Construct Shape - Stone Golem, Iron Golem, Demonflesh Golem
        //-----------------------------------------------------------------------
        case 738: nPoly =91; break; // stone golem
        case 739: nPoly =92; break; // demonflesh golem
        case 740: nPoly =90; break; // iron golem
    }


    ApplyPolymorph(OBJECT_SELF, nPoly, nWeaponType);
}

