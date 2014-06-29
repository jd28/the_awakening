//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//::::::::::::::::::::::: File Name: sha_subr_methds :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: Include script ::::::::::::::::::::::::::::::::::::
//:: Written by: Shayan
//:: Contributed to by: Moon, Parsec, TwentyOneScore                        :://
//:: Contact: mail_shayan@yhaoo.com                                         :://
//:: Forums: http://p2.forumforfree.com/shayan.html
//
// ::Description: Holds all the methods used in the Subrace System. DO NOT CHANGE
// ::             ANYTHING UNLESS YOU ARE CERTAIN.
// ::             This is the 'core engine script'. In updates, more than likely
// ::             this script is changed... so unless you do not plan to update to
// ::             possible future releases of this engine, it will be in your best
// ::             interest NOT to make any changes to this script. Because then you
// ::             will have to redo them again.
// ::             Should you disregard this warning and proceed to editing...
// ::             Remember that:
// ::             * If you have made a change you must recompile all scripts for
// ::               changes to take place.
//
// ::Please refer to the script file 'sha_subr_consts' to change any values of the
// ::constants or default values.

// ::Version 3.0.5: Spring cleaned by Moon.

// ::Version 1.4: Reduced the numbers of local variables, by "encoding a single integer
// ::             variable to hold several 'bits' of information". - Using Axe Murderer's Flag-sets.

// ::Version 1.2: Support for NWNX added.

//#include "sha_subr_consts - Gained through sha_misc_funcs AND sha_leto_inc

//NWNX Database script.
#include "nwnx_inc"
#include "pl_sub_inc"
#include "pl_pcstyle_inc"

//NWN standard switch library.
#include "x2_inc_switches"

#include "sha_misc_funcs"

#include "fky_chat_inc"

// :: Version 2.5: LETO Include functions.
//#include "sha_leto_inc"

// :: Version 3.0.5b3: Made Spellhooks loading a part of the OnModLoad event
// :: Thus x2_inc_switches was required
// :: 3.0.6 removed cuz its up there a few lines ago :p
//#include "x2_inc_switches"

//::****************************************************************
// 1.69 -- Support for horses
#include "x3_inc_skin"
//::****************************************************************

//:: - ALL SUBRACE RELATED METHODS MUST BE CALLED AFTER THIS METHOD! -
//:: -- The Main function. Call this OnModuleLoad.
//
// ::Race:   This is the base race that you want to create your subrace from
// ::        Use ONLY: RACIAL_TYPE_ALL, or RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF,
// ::                  RACIAL_TYPE_GNOME, RACIAL_TYPE_HALFELF, RACIAL_TYPE_HALFLING,
// ::                  RACIAL_TYPE_HALFORC, or RACIAL_TYPE_HUMAN.
// ::       If you want to add additional races that can become part of this subrace call
// ::       AddAdditionalBaseRaceToSubrace() AFTER this method.
//
// ::subrace:   The subrace's name. This is what the PC will have to type in his/her
// ::               Subrace field. DO NOT HAVE SPACES IN NAMES.
// ::               IE: Use "Dark-elf" NOT "Dark elf".
// ::               (Not case sensitive.)
//
// ::HideResRef:    This is the resref of the Creature Hide/Skin you want to equip on the PC.
// ::               This will have all the subrace traits like ability modifiers and base feats etc.
//
// ::                If you do not want a skin, write either "none" or leave it as blank.
//
// ::UniqueItemResref:   This is the resref of the item that you want given to the player. For example this item
// ::                    could hold can spells on it, or just description of the subrace. Ideally this item will not be droppable,
// ::                    and is marked as being a plot item. Regardless of what type of item this is it will be given to player when they enter the module.
// ::                    (If they lose it or drop it they will again get it back on the next time they enter).
//
// ::                    If you do not want to give the PC a unique item then, write either "none" or leave it as blank.
//
// ::IsLightSensitive:   Set to TRUE if the subrace is light senstive. IE: Blinded when in Sunlight and/or gets saves and AB decreases.
// ::                    If the PC does not pass the fort saving throw, then it is blinded for that round.
// ::                    The DC for the saving throw can be changed by changing the value of
// ::                    LIGHT_SENSITIVE_SAVING_THROW_DC in the file sha_subr_consts. Also you can change the interval (rounds) between each time the PC
// ::                    is 'struk' by light by changing the value of LIGHT_BLINDNESS_STRIKES_EVERY_ROUND.  And also you can change the number of rounds
// ::                    the PC stays blinded for if it fails the saving throw by changing tha value of LIGHT_STRUCK_BLIND_FOR_ROUNDS.
//
// ::                    If APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT is set to TRUE, then the PC also suffers
// ::                    an attack bonus decrease of LIGHT_AB_DECREASE and saving throw decrease of LIGHT_SAVE_DECREASE for a number of rounds
// ::                    determined by: LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS.
//
// ::                    Rememeber: IF YOU CHANGE ANYTHING IN THE CONSTANTS FILE, IT WILL APPLY TO ALL SUBRACES.
// ::                               (IE: If you change the DC for the saving throw then all subraces that have light sensitivity will have to make that saving throw).
//
// ::DamageTakenWhileInLight:  The amount of divine Damage the PC suffers ever round while
// ::                          it is in sunlight. Note: PC does not necessarily have to be Light Sensitive
// ::                          for this to work.
// ::                          If this value is negative then the PC will regenerate that amount.
//
// ::IsUndergroundSensitive:   Same as IsLightSenstive but this applies when the PC is in
// ::                          Underground type of areas. This does not mean the PC is affected by Night time.
//
// ::DamageTakenWhileInUnderground:  The amount of Negative Damage taken per round while in the Underground.
// ::                                 Note: This too doesn't need the PC to be Under ground sensitive to apply.
// ::                                 If this value is negative then the PC will regenerate that amount.
//
// :: ECL:          Effective Character Level: Use any integer value.
// ::                 (For those that do not know what this is...
// ::                   Effective Character Level is a way of lessening your subrace's bonus abilities
// ::                   by reducing the amount of experience points gained per kill.)
// ::                   IE: If you have a Subrace with ECL of 3, then a PC (Player character) of level 10 belonging to
// ::                       that subrace is regarded being level 13 when gaining XP points per kill.
// ::                       Thus will get less experience points.
// ::                       NOTE: This can work for negative values as well.
//
// :: IsUndead:             Mark the PC belonging to this sub-race as being Undead. It will mean that Healing spells will hurt the PC.
// ::                       And harming spells will heal the PC.
//
// :: PrestigiousSubrace:   Mark this sub-race as being prestigious. Which means players can't become part of it when they enter in with a level 1 character with this as their chosen subrace.
// ::                      (Set this to TRUE, if you are making a subrace that players can become part of once they reach a certain level in another sub-race)
// ::                       -Refer to SetupSubraceSwitch() for more information -
//
// :: Example:  You wish to create a subrace called Drow, and you have created a Creature Skin/Hide in the toolset with
// ::          resref "sha_pc_drow". The Unique item (which contains spell like abilities and information about the Drow subrace)
// ::          has the resref "sha_subrace_drow". And you want to make the Drow light sensitive and take 2 divine damage while in light areas.
// ::          Also you would like to mark the Drow as having an Effective Character level of +1.
// ::          Simply call this OnModuleLoad. (Remember to #include "sha_subr_methds", in the script)
//
// ::          CreateSubrace(RACIAL_TYPE_ELF, "drow", "sha_pc_drow", "sha_subrace_drow", TRUE, 2, FALSE, 0, 1);
void CreateSubrace(int Race, string subrace, string HideResRef = "", string UniqueItemResref = "", int IsLightSensitive = FALSE, int DamageTakenWhileInLight = 0, int IsUndergroundSensitive = FALSE, int DamageTakenWhileInUnderground = 0, int ECL = 0, int IsUndead = FALSE, int PrestigiousSubrace = FALSE);


//- Add another Race that can be part of the subrace.
// :: subrace should be the same as the Subrace's name used in  CreateSubrace()
// :: AdditionalBaseRace can only be RACIAL_TYPE_ALL, RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF, RACIAL_TYPE_GNOME,
// ::                                  RACIAL_TYPE_HALFELF, RACIAL_TYPE_HALFLING, RACIAL_TYPE_HALFORC, or RACIAL_TYPE_HUMAN.
void AddAdditionalBaseRaceToSubrace(string subrace, int AdditionalBaseRace);


// ::Limit the classes the PC can be, when trying to be part of this subrace.
// ::      subrace should be the same as the Subrace's name used in  CreateSubrace()
// ::      Set the CanBe_<Class> values as desired.
//
// ::Note: This will only check PC's first class. IE: You limit your subrace's classes to only Fighter and Rogue
// ::      A player with classes Wizard/Fighter/Cleric will not meet the criteria, nor will a Monk/Cleric/Rogue.
// ::      Only a PC with either Rogue or Fighter as their first class will meet the requirement.
// ::      IE: Rogue/WeaponMaster or Fighter/Wizard/Cleric.
void CreateSubraceClassRestriction(string subrace, int CanBe_Barbarian = TRUE, int CanBe_Bard = TRUE, int CanBe_Cleric = TRUE, int CanBe_Druid = TRUE, int CanBe_Fighter = TRUE, int CanBe_Monk = TRUE, int CanBe_Paladin = TRUE, int CanBe_Ranger = TRUE, int CanBe_Rogue = TRUE, int CanBe_Sorcerer = TRUE, int CanBe_Wizard = TRUE);


//Limit the Alignment the PC can be, when trying to be part of this subrace.
//Note this alignment restriction only applies when the PC enters the module for the first time. (A database entry is made).
// ::   IE: It will not stop the PC from being part of the subrace after the PC adventures and changes in alignment.
//
// ::   subrace should be the same as the Subrace's name used in  CreateSubrace()
// ::   Set the CanBe_<Alignment> to as desired.
void CreateSubraceAlignmentRestriction(string subrace, int CanBeAlignment_Good = TRUE , int CanBeAlignment_Neutral1 = TRUE, int CanBeAlignment_Evil = TRUE, int CanBeAlignment_Lawful = TRUE, int CanBeAlignment_Neutral2 = TRUE, int CanBeAlignment_Chaotic = TRUE);


//Use this method of Spell resistance if you want the Spell resistance to increase (or decrease) with the PC's level.
// ::   subrace should be the same as the Subrace's name used in  CreateSubrace()
//
// ::   SpellResistanceBase: Is the vaule of SR the PC gains at level 1
// ::   int SpellResistanceMax: Is the value of the SR PC gains at the maximum level achievable (default is 40, you can change the maximum level value in "sha_subr_consts")
void CreateSubraceSpellResistance(string subrace, int SpellResistanceBase, int SpellResistanceMax);


//Use this method if you want the PC's Appearance to change for the subrace.
//
// :: subrace should be the same as the Subrace's name used in  CreateSubrace()
// :: AppearanceChangeTime: Time of day you want the Appearance to change.
// ::                         if you want to have a permanent appearance change then use: TIME_BOTH.
// ::                         if you want the appearance to only change when it is night time and revert back when it is day time then use: TIME_DAY.
// ::                         if you want the appearance to only change when it is day time and revert back to the PC's original form when it is night time then use: TIME_NIGHT.
// ::                         if you plan on making a controlable appearance, then set to TIME_NONE. (Refer to manual for more information)
//
// ::MaleAppearance: This is the appearance of a Male PC. Use any of the APPEARANCE_TYPE_* values.
// ::FemaleAppearance: This is the appearance of a Female PC. Use any of the APPEARANCE_TYPE_* values.
// ::Level: From which level to apply this appearance change from...
//
// ::NOTE: Not all APPEARANCE_TYPE_* constants work in standard NWN. IE: If you use APPEARANCE_TYPE_WYRMLING_BLACK, and you only have installed just NWN (no expansions),
// ::      Then your appearance will be different... (in the case of wyrmiling, you will look like a mephit) - You have been warned.
void CreateSubraceAppearance(string subrace, int AppearanceChangeTime, int MaleAppearance, int FemaleAppearance, int Level = 1);

// - (You may use this twice per subrace. Once for TIME_DAY, and once for TIME_NIGHT) -
//
// Use this method if you want the PC's ability scores or AC or AB to change when it is either day or night.
// (The use of this function is slightly more complicated)
//
// ::   subrace: Should be the same as the Subrace's name used in CreateSubrace()
//
// ::   struct SubraceStats Stats:  (Explained below)
//
// ::   TimeToApply: if you want the stats/ability scores to only change when it is night time and revert back when it is day time then use: TIME_NIGHT.
// ::                if you want the stats/ability scores to only change when it is day time and revert back to the PC's original stats/ability scores when it is night time then use: TIME_DAY.
//
// ::   InInteriorArea:   Set to TRUE if you want these changes to ability scores to happen in Interior Areas.
// ::   InExteriorArea:   Set to TRUE if you want these changes to ability scores to happen in Exterior Areas.
// ::   InNaturalArea:    Set to TRUE if you want these changes to ability scores to happen in Natural Areas.
// ::   InArtifacialArea: Set to TRUE if you want these changes to ability scores to happen in Artifical Areas.
// ::   InUndergroundArea: Set to TRUE if you want these changes to ability scores to happen in Underground Areas.
// ::   InAbovegroundArea:  Set to TRUE if you want these changes to ability scores to happen in Above Ground Areas.
//
// :: How to use this function.
//
// :: First create a structure of SubraceStats. It can be done by:
//
// :: struct SubraceStats  mystats = CreateCustomeStats(<fill in appropriate values. Look at CreateCustomeStats method for more details>).
//
// :: then you want to add this to your subrace. So call
//
// :: CreateTemporaryStatModifier("mysubrace", mystats, TIME_DAY, TRUE, FALSE);
//
// ::Hence the PC belonging to "mysubrace" will have it's ability scores changed during day time, when they are in Exterior (IE: outdoors) areas.
void CreateTemporaryStatModifier(string subrace, struct SubraceStats Stats, int TimeToApply, int InInteriorArea = TRUE, int InExteriorArea = TRUE, int InNaturalArea = TRUE, int InArtifacialArea = TRUE, int InUndergroundArea = TRUE, int InAbovegroundArea = TRUE);


//This is the first half of CreateTemporaryStatModifier function.
//
//(The use of this function is slightly more complicated)
//
// ::       StatModiferType: Use only SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE (if you wish to increase or decrease a PC's ability scores/AC/AB based on the percentage of the PC's current ability scores)
// ::                         or SUBRACE_STAT_MODIFIER_TYPE_POINTS (if you wish to increase or decrease a PC's ability scores/AC/AB by constant number.
// ::       Fill in the values of the floats appropriately.
//
// ::Example: You wish to change reduce the PC's strength by 80% and increase it's dexterity by 50% and increase it's consitituion by 60%, whilst you want to increase the AC by 65%, but reduce the AB by 10%.
//
// ::so you create your stats:
//
// ::struct SubraceStats mystats = CreateCustomStats(SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE, -0.80, 0.50, 0.60, 0.0, 0.0, 0.0, 0.65, -0.10);
//
// ::You then use this in CreateTemporaryStatModifier().
struct SubraceStats CreateCustomStats(int StatModifierType, float StrengthModifier, float DexterityModifier, float ConstitutionModifier, float IntelligenceModifier, float WisdomModifier, float CharismaModifier, float ACModifier, float ABModifier);


// Restricing the use of Items (both weapons and armour) for a given subrace.
// Use this for each of the four TimeOfDay you want. (TIME_DAY, TIME_NIGHT, TIME_SPECIAL_APPEARANCE_NORMAL and TIME_SPECIAL_APPEARANCE_SUBRACE)
//          ItemType should be a mix of the following (mix them by using | ):
//
//            --------- Weapon Restrictions ---------
//
//
//              - ITEM_TYPE_WEAPON_MELEE           - Melee Weapons (incl. Monk Gloves) Does NOT include Bracers.
//              - ITEM_TYPE_WEAPON_RANGED_THROW    - Ranged Weapons (Throwing Weapons)
//              - ITEM_TYPE_WEAPON_RANGED_LAUNCHER - Ranged Weapons (Launchers) Does "incl." Ammonition (Ammo can still be equipped but is not usable)
//              - ITEM_TYPE_WEAPON_RANGED          - Ranged Weapons (Both Launchers and Throwing)
//              - ITEM_TYPE_WEAPON                 - All Weapons (Both Ranged and Melee)
//
//              - ITEM_TYPE_WEAPON_PROF_SIMPLE     - Simple Weapons
//              - ITEM_TYPE_WEAPON_PROF_MARTIAL    - Martial Weapons
//              - ITEM_TYPE_WEAPON_PROF_EXOTIC     - Exotic Weapons
//              - ITEM_TYPE_WEAPON_PROF_ANY        - All Weapon Prof.
//
//              - ITEM_TYPE_WEAPON_SIZE_TINY       - Tiny Weapons
//              - ITEM_TYPE_WEAPON_SIZE_SMALL      - Small Weapons
//              - ITEM_TYPE_WEAPON_SIZE_MEDIUM     - Medium Weapons
//              - ITEM_TYPE_WEAPON_SIZE_LARGE      - Large Weapons
//
//              - ITEM_TYPE_WEAPON_SIZE_SMALL_DOWN - All Small or smaller Weapons (Small, Tiny)
//              - ITEM_TYPE_WEAPON_SIZE_MEDIUM_UP  - All Medium or Larger Weapons (Medium, Large)
//              - ITEM_TYPE_WEAPON_SIZE_ANY        - All Weapon Sizes.
//
//
//
//            --------- Armour, Helm and Shield Restrictions ---------
//
//              - ITEM_TYPE_SHIELD_SMALL           - Small Shields
//              - ITEM_TYPE_SHIELD_LARGE           - Large Shields
//              - ITEM_TYPE_SHIELD_TOWER           - Tower Shields
//              - ITEM_TYPE_SHIELD_ANY             - All Shields.
//
//              - ITEM_TYPE_ARMOR                  - Torso Armour Only (AC 0-8)
//              - ITEM_TYPE_ARMOR_TYPE_CLOTH       - Cloth Torso Armour only (AC 0)
//              - ITEM_TYPE_ARMOR_TYPE_LIGHT       - Light Torso Armour only (AC 1-3)
//              - ITEM_TYPE_ARMOR_TYPE_MEDIUM      - Medium Torso Armour only (AC 4-6)
//              - ITEM_TYPE_ARMOR_TYPE_HEAVY       - Heavy Torso Armour only (AC 7-8)
//
//              - ITEM_TYPE_ARMOR_AC_0             - Torso Armour with 0 AC
//              - ITEM_TYPE_ARMOR_AC_1             - Torso Armour with 1 AC
//              - ITEM_TYPE_ARMOR_AC_2             - Torso Armour with 2 AC
//              - ITEM_TYPE_ARMOR_AC_3             - Torso Armour with 3 AC
//              - ITEM_TYPE_ARMOR_AC_4             - Torso Armour with 4 AC
//              - ITEM_TYPE_ARMOR_AC_5             - Torso Armour with 5 AC
//              - ITEM_TYPE_ARMOR_AC_6             - Torso Armour with 6 AC
//              - ITEM_TYPE_ARMOR_AC_7             - Torso Armour with 7 AC
//              - ITEM_TYPE_ARMOR_AC_8             - Torso Armour with 8 AC
//
//              - ITEM_TYPE_HELM                   - Helms
//
//              - ITEM_TYPE_FULL_ARMOR_SET         - All Armours, Shields and Helms.
//
//            --------- Misc. Restrictions ---------
//
//              - ITEM_TYPE_JEWLERY                - Rings and Amulets
//              - ITEM_TYPE_MISC_CLOTHING          - None-Torso clothing (Cloak, Braces, Boots) Does NOT include Jewlery
//              - ITEM_TYPE_NONE_BIOWARE_ITEM      - ALL None Standard Bioware Items (e.g. CEP Items)
//
//
//
//          TimeOfDay should either be any mix of TIME_DAY,TIME_NIGHT, TIME_BOTH for time-based restrictions OR
//               a mix of TIME_SPECIAL_APPEARANCE_SUBRACE, TIME_SPECIAL_APPEARANCE_SUBRACE for appearance-based restrictions.
//               Appearance-based will override Time-based in case of conflict!
//
//          Allow should be a mix of the follow constants:
//              - ITEM_TYPE_REQ_ALL - Must meet ALL requirements (applies to Weapons-req. only) e.g. only weapons that are Large Weapons AND Simple Weapons can be used
//              - ITEM_TYPE_REQ_ANY - Must just meet one of the requirements  e.g. Large Weapons or simple weapons can be used.
//              - ITEM_TYPE_REQ_DO_NOT_ALLOW - Subrace CANNOT use ItemType during TimeOfDay (input is reversed)
void SubraceRestrictUseOfItems(string subrace, int ItemType, int TimeOfDay = TIME_BOTH, int Allow = ITEM_TYPE_REQ_DO_NOT_ALLOW);


//:: Add a favored class to the subrace.
//
// (Use this only ONCE per subrace. It will not work correctly if used more than once per subrace)
// This would mean that when determining XP penalty for multiclassing, the favored
// classes do not apply when determining it (Works the same way as default NWN favored classes)
// ::(This will work ONLY if you are using the attached Shayan's XP System script).
//
//NOTE: You can use any playable base CLASS_TYPE_* constant. Do NOT USE Prestige classes,
// ::     as they are not taken into consideration when determining multiclassing penalty by NWN.
// ::     Also if you do specify a prestige class it will end up giving players a 20% boost to the XP gained.
// ::     (Thanks to Masterlexx for spotting this bug)
void AddSubraceFavoredClass(string subrace, int MaleFavoredClass, int FamaleFavoredClass);

//Add a permanent or a temporary subrace effect on the PC, during day or night or permanently.
//
//:: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
//:: EffectID: There are a limited number of effects you can use here...
//::           EFFECT_TYPE_ARCANE_SPELL_FAILURE
//::           EFFECT_TYPE_BLINDNESS
//::           EFFECT_TYPE_CHARMED
//::           EFFECT_TYPE_CONCEALMENT
//::           EFFECT_TYPE_CONFUSED
//::           EFFECT_TYPE_CUTSCENEGHOST
//::           EFFECT_TYPE_HASTE
//::           EFFECT_TYPE_IMMUNITY
//::           EFFECT_TYPE_IMPROVEDINVISIBILITY
//::           EFFECT_TYPE_INVISIBILITY
//::           EFFECT_TYPE_MISS_CHANCE
//::           EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
//::           EFFECT_TYPE_MOVEMENT_SPEED_INCREASE
//::           EFFECT_TYPE_POLYMORPH
//::           EFFECT_TYPE_REGENERATE
//::           EFFECT_TYPE_SANCTUARY
//::           EFFECT_TYPE_SLOW
//::           EFFECT_TYPE_TEMPORARY_HITPOINTS
//::           EFFECT_TYPE_TRUESEEING
//::           EFFECT_TYPE_ULTRAVISION
//::           EFFECT_TYPE_VISUALEFFECT
//
// ::  Value1: This is the value of the first parameter (from left) that you can input for the effect.
// ::          IE: If you choose EFFECT_TYPE_CONCEALMENT, which means the effect applied will be:
// ::          EffectConcealment(int nPercentage, int nMissType=MISS_CHANCE_TYPE_NORMAL)
// ::          Thus Value1 will be the value of nPercentage.
// ::          YOU MUST INPUT A VALUE! IF NOT THE SCRIPT WILL PUT IN 0!!
//
// :: Value2: This is the value of the second parameter you can input for the effect.
// ::         IE: (Refer to Value1's example) This will be the value of nMissType.
// ::         YOU MUST INPUT A VALUE! IF NOT THE SCRIPT WILL PUT IN 0!!
//
// ::nDurationType: Duration type of the effect being applied...
// ::                DURATION_TYPE_INSTANT, DURATION_TYPE_PERMANENT, or DURATION_TYPE_TEMPORARY.
//
// ::fDuration: The number of seconds the effect should last for...
// ::           (Put 0.0 if you are making it last "forever" -IE: Whole of day time, or night time or permanetly)
//
// ::TimeOfDay: The time of day you want this applied. Use TIME_BOTH if you want this permanently applied on the PC.
//
// Use as many times as desired.
void AddSubraceEffect(string subrace, int EffectID, int Value1, int Value2, int nDurationType, float fDuration, int TimeOfDay);

//Add a different skin to the subrace at specified level. (Use as many times as desired)
//
//::    subrace: Should be the same as the Subrace's name used in  CreateSubrace()
//::    SkinResRef: The Blueprint ResRef of the skin that you want the subrace to be equipped.
//::    EquipLevel: The level at which you want the skin to be applied.
//::    iTime: The time at which you want the skin to be equipped. (Use TIME_DAY, TIME_NIGHT, or TIME_BOTH.)
//
// ::Example: You want to add a skin for the subrace Illithid to use at level 15, during day time.
//
// ::Then call onModuleLoad script:
// ::        AddAdditionalSkinsToSubrace("Illithid", "my_illithid_skin", 15, TIME_DAY);
//
// ::(Where "my_illithid_skin" is the resref of the skin you want equipped.)
//
// ::::
// :::: Remeber: If you say add a skin for a subrace to be equipped at level 15, then all PCs belonging to the
// :::: subrace above level 15 will also use the same skin for that time -unless you add a different skin for those levels.)
//
// ::::Use as many times as desired.
void AddAdditionalSkinsToSubrace(string subrace, string SkinResRef, int EquipLevel, int iTime = TIME_BOTH);


//::: Add equipable creature claws to the subrace.  (Use as many times as desired)
//
// ::  This allows you to add 'Claws' to your subrace. You simply specify the Blue print resref of
// ::    the claw you want equipped on the player, and at what level.
// ::  (You can use this to equip claws/slams/gore or what ever else that maybe equipped in a PC's claw item slots
//
//
//:: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
//:: RightClawResRef: The resref of the right hand claw. (Use "" if you do not want to specify a claw, use "none" if you want any existing right claws to be removed from the player.)
//:: LeftClawResRef: The resref of the left hand claw.  (Use "" if you do not want to specify a claw, use "none" if you want any existing right claws to be removed from the player.)
//:: EquipLevel: The level at which these claws should be equipped.
//
// ::NOTE: 1. Make sure the PCs have weapon proficiency in creature weapons!!! I can't stress this enough.
// ::           (Give the feat through the subrace Skin)
//
// ::      2. If you are going to use one claw, make sure it is the right claw.
//
// ::      3. Also note that you need not change both claws at once.
// ::        (IE: Say you equipped a right and left claw at level 5, then say at level 10, if you want to change the left claw
// ::             then you only need to specify the resref of the left claw... the PC keeps the existing right claw.)
void AddClawsToSubrace(string subrace, string RightClawResRef, string LeftClawResRef , int EquipLevel, int iTime = TIME_BOTH);


//::: Switch the player from one subrace to another ::::
//
// ::(Use only once per Level)
//
// :: This allows you to switch a player from one subrace to another.
//
//:: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
//:: switchSubraceName: The syntax of the subraces, you wish to switch the player (Should be the same as whatever the new subraces' name used in it's CreateSubrace())
//:: Level: The level at which this switch should take place.
//:: MustMeetRequirements: Set to FALSE, if you want the switching to bypass any class/race/alignment restriction the new subrace might have.
//
// ::  If MustMeetRequirements set to TRUE, and the character fails to meet a requirement... then they will continue on as part of their current sub-race.
//
// ::IDEA: You can set the subrace you want the player to switch to as a hidden and unaccessible subrace for new characters, by setting
// ::      PrestigiousSubrace to TRUE, in CreateSubrace().
// ::      That way, players must earn their way to this new subrace (switchSubraceNames).
//
// ::Note: In order for this to work the subrace you wish to switch the player to does NOT have to be marked as prestigious.
//
// ::IE: If I had set up three subraces like:
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "illithid", "sha_pc_illithid", "sha_subrace_illi", TRUE, 0, FALSE, 0, 3);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "vampire", "sha_pc_vamp001", "sha_subrace_vamp", TRUE, 2, FALSE, 0, 3, TRUE);
// ::    //Can only be evil.
// ::    CreateSubraceAlignmentRestriction("vampire", FALSE, FALSE, TRUE);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "wolkier", "sha_pc_wolk", "sha_subrace_wolk", TRUE);
// ::    //Can only be Neutral;.
// ::    CreateSubraceAlignmentRestriction("wolkier", FALSE, TRUE, FALSE);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::And I wished that PCs belonging to illithid be switched to vampire or wolkier at level 15, depending on which criteria they meet, then I would call:
//
// :: SetupSubraceSwitch("illithid", "vampire_wolkier", 15, TRUE);
//
// ::If I didn't want the alignment criteria to be check during switching then I would call:
//
// ::  SetupSubraceSwitch("illithid", "vampire_wolkier", 15, FALSE);
//
// :: The order in which you choose the subrace to be switched is important. If the player can meet both requirements, it gives prioirty to the first one.
//
//
// :: You can put in any number of subraces to switch to..
// :: IE:
//        SetupSubraceSwitch("illithid", "vampire_wolkier_pixie_shadow", 8, TRUE);
//
// If a player doesn't meet the criteria for any one of the subraces, he/she wil remain part of thier usual/current subrace.
//
// You can use SetupSwitchSubrace() as many times as you like. EG:
//
//   SetupSubraceSwitch("illithid", "vampire_wolkier_pixie_shadow", 12, TRUE);
//   SetupSubraceSwitch("illithid", "air-genasi_underminion", 18, TRUE);
//   SetupSubraceSwitch("illithid", "mindbreaker_telephathest_darkmoon", 32, TRUE);
//   SetupSubraceSwitch("illithid", "greatone", 40, FALSE);
//
// Where: vampire, wolkier, pixie, shadow, air-genasi, underminion, mindbreaker,
//        telephathest, darkmoon, and greatone are all subraces.
void SetupSubraceSwitch(string subrace, string switchSubraceName, int Level, int MustMeetRequirements = TRUE);

// :: Give the player belonging to a subrace, additional unique items ::
//             (Use as many times as desired for any levels)
//
//    This allows you to give players belonging to a subrace additional unique items, at any level.
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: ItemResRef:  The blueprint res-ref of the item to give.
// :: Level:       The level at which to give the item.
//
// Example:
//
// Say I wanted to give my players belonging to the vampire subrace, an armour and a scythe at level 2.
// And then an amulet at level 10.
//       The armor's resref is: "sha_vamp_arm"
//       The scythe's resref is: "sha_vamp_scythe"
//       The amulet's resref is: "sha_vamp_ammy"
//
// So I simply call:
//    AddSubraceItem("vampire", "sha_vamp_arm", 2);
//    AddSubraceItem("vampire", "sha_vamp_scythe", 2);
//    AddSubraceItem("vampire", "sha_vamp_ammy", 10);
//
//// NOTE: You can only give ONE item of each. IE: You CAN'T do this expecting to give 2 amulets:
//
//   AddSubraceItem("vampire", "sha_vamp_ammy", 10);
//   AddSubraceItem("vampire", "sha_vamp_ammy", 10);
void AddSubraceItem(string subrace, string ItemResRef, int Level = 1);

// :: Setup an alias for your subrace.
//
//    Allows you to use two or more "names" for the same subrace without
//    having to add it twice.
//
//    See SSE_TREAT_ALIAS_AS_SUBRACE in sha_subr_consts for more info.
void SetupSubraceAlias(string subrace, string Alias);


// :: Setup a Prestige class restriction for a 'Prestige' subrace.
//
// NOTE: This will only be checked during a 'subrace switch' for obvious reasons. Refer to SetupSubraceSwitch(...)
//
//    subrace = Should be the same as the Subrace's name used in  CreateSubrace().
//    MinimumLevels = The minimum number of levels in a/any particular prestigious class allowed to pass the restriction.
//    Set CanBe_<Class> values as desired.
//
//    Example:
//
//    Say I have a subrace 'Phantasm' and I wanted to add a restriction so that only Shadow Dancers, Blackguards, and Assasin can be part of.
//    AND they must have atleast 5 levels in any of those classes.
//    So I set:
//
//    CreateSubracePrestigiousClassRestriction("phantasm", 5, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE);
//
//    * A player with class combination like <Any base class>/Assasin(2)/ShadowDancer(3) will meet this criteria.
//
//    NOTE: This can be used in combination with CreateSubraceClassRestriction(...)
//
//    If you wanted to you can also set-up a primary/base class restriction with CreateSubraceClassRestriction(...) and also create a Prestigious class restriction with this.
void CreateSubracePrestigiousClassRestriction(string subrace, int MinimumLevels = 1, int CanBe_ArcaneArcher = TRUE, int CanBe_Assasin = TRUE, int CanBe_Blackguard = TRUE, int CanBe_ChampionOfTorm = TRUE, int CanBe_RedDragonDisciple = TRUE, int CanBe_DwarvenDefender = TRUE, int CanBe_HarperScout = TRUE, int CanBe_PaleMaster = TRUE, int CanBe_ShadowDancer = TRUE, int CanBe_Shifter = TRUE, int CanBe_WeaponMaster = TRUE, int CanBe_PurpleDragonKnight = TRUE);

// :: Add wings or tail to the subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Male_Wings: The wing to be added for a male character: Use any  APPEARANCE_TYPE_ATTACHMENT_WINGS_* constant.
// :: Female_Wings: The wing to added for a female character: Use any  APPEARANCE_TYPE_ATTACHMENT_WINGS_* constant.
// :: Male_Tail: The tail to be added for a male character: Use any APPEARANCE_TYPE_ATTACHMENT_TAIL_* constant.
// :: Female_Tail: The tail to be added for a female character: Use any APPEARANCE_TYPE_ATTACHMENT_TAIL_* constant.
// :: Level: The level at which to add these attachments.
// NOTE: If you are using any of the CEP tails or wings, your server/module must have CEP.
//
// Example of Usage:
//
// Say I want to add bird like wings to the male character, and angel wings to the female character at level 21:
// I also want to change the male wings to devil and the female to red dragon disciple's, and add a bone tail to both genders at level 36.
//
//
//   AddSubraceAppearanceAttachment("mysubrace", APPEARANCE_TYPE_ATTACHMENT_WINGS_BIRD, APPEARANCE_TYPE_ATTACHMENT_WINGS_ANGEL, 0, 0, 21);
//   AddSubraceAppearanceAttachment("mysubrace", APPEARANCE_TYPE_ATTACHMENT_TAIL_DEVIL, APPEARANCE_TYPE_ATTACHMENT_WINGS_RED_DRAGON_DISCIPLE, APPEARANCE_TYPE_ATTACHMENT_TAIL_BONE, APPEARANCE_TYPE_ATTACHMENT_TAIL_BONE, 36);
//
//
//:: You may use this as many times as desired.
void ModifySubraceAppearanceAttachment(string subrace, int Male_Wings = 0, int Female_Wings = 0, int Male_Tail = 0, int Female_Tail = 0, int Level = 1);


// :: Use to restrict subrace's gender ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: CanBeMale: Set to FALSE if you do not want the subrace to be playable by Male characters
// :: CanBeFemale: Set to FALSE if you do not want the subrace to be playable by Female characters
//
// :: Example of useage:
//    Say I want my subrace "Pixie" only be playable by Female characters... then I would call:
//
//    CreateSubraceGenderRestriction("pixie", FALSE, TRUE);
void CreateSubraceGenderRestriction(string subrace, int CanBeMale = TRUE, int CanBeFemale = TRUE);

// :: Use to the portrait of a character ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: MalePortrait: Set the name of the male portrait.
// :: FemalePortrait: Set the name of the female portrait.
// :: Level: The level at which to change the portrait.
//
// List of portraits' file names can be found in portraits.2da.
//
// NOTE: This function will correclty set the portraits. But whether or not other players or the player him/herself can see
//       it depends on whether they have portrait in their portrait folder or the expansion packs containing the portraits.
//       (Like in the below for example: The Queen Shao's portrait is only included in HoTU. So if the player does not have Queen Shao's portraits in his/her
//        portrait folder will not be able to see them. And other players without HoTU will not be able to see the player's portrait)
//
// NOTE 2: If you want to use any of the standard portraits (That is any from NWN) make sure you have "po_" as prefix.
//         IE: If you want to use the portrait set 'el_f_04_' (as listed in portraits.2da) the actual name is: po_el_f_04_.
//         (Some portraits in the standard library do not use the po_ prefix... and there is no way to tell other than by trial and error)
//
// Example of Useage:
//         Say I have the Queen Shao's portraits. These portraits are po_queenshao_h, po_queenshao_l, po_queenshao_m, po_queenshao_s, and po_queenshao_t.
//         So this means that this portrait set is refered to by: po_queenshao_
//         Likewise say I have another portrait set: my_male_port_
//
//         And say I want to set Queen Shao's portrait to all the female players, and my other portrait set to the male characters
//         at level 6. So I would call:
//
//    ChangePortrait("mysubrace", "my_male_port_", "po_queenshao_", 6);
//
// :: You may use this as many times as desired.
void ChangePortrait(string subrace, string MalePortrait, string FemalePortrait, int Level = 1);

// :: Use to set-up an automated change in the subrace's faction ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: FactionCreatureTag: The tag of the creature whose perception of the subrace will be adjusted.
// :: Reputation: Use any  SUBRACE_FACTION_REPUTATION_* constants.
//
// Refer to the .PDF Guide book for a detailed example, and implementation of this function.
//
// Example of function usage:
//
//   Say I have a NPC faction called 'Drow Faction'. This faction will normally attack
//   (Hostile) player character. But I want to have the players belonging to the 'Drow' subrace
//   be treated friendly, by the NPCs belonging to this faction...
//
//   So inorder to do this; first I will need to create:
//   An NPC in a LOCKED room (IE: no player can enter), I would remove all weapons and items from this
//   NPC.
//   Set it as Immortal (NOT Plot).
//   Set it's tag to say: MY_DROW_FACTION_NPC
//   And then call this function:
//
//     ModifySubraceFaction("drow", "MY_DROW_FACTION_NPC", SUBRACE_FACTION_REPUTATION_FRIENDLY);
void ModifySubraceFaction(string subrace, string FactionCreatureTag, int Reputation = SUBRACE_FACTION_REPUTATION_HOSTILE);


// :: Setup a start location for a subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: WaypointTag: The Tag of the waypoint to which the player will be ported to.
//
//
// This will teleport the player belonging to the Subrace 'subrace' to
// the waypoint, when they enter the module.
void CreateSubraceStartLocation(string subrace, string WaypointTag);

//3.0.6.4

// :: Setup a death location for a subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: WaypointTag: The Tag of the waypoint the player will be teleported to.
//
//
// This will teleport the player belonging to the Subrace 'subrace' to
// the waypoint, when they respawn after death.
void CreateSubraceDeathLocation(string subrace, string WaypointTag);

// 3.0.6.6 - Not just for leto anymore...

// ::  Use to setup different skin and hair colors for subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Male_Hair: which color male hair is to be set to.
// :: Female_Hair: which color female hair is to be set to.
// :: Male_Skin: which color male skin is to be set to.
// :: Female_Skin: which color male skin is to be set to.
// :: Level: the level at which this change is to take place.
//
// Written by: TwentyOneScore
void ModifySubraceAppearanceColors(string subrace, int Male_Hair = -1, int Female_Hair = -1, int Male_Skin = -1, int Female_Skin = -1, int Level = 1);

//3.0.6.6

// ::  Use to setup different eye colors for subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Male_Eye: which color male eyes is to be set to.
// :: Female_Eye: which color female eyes is to be set to.
// :: use any SUBRACE_EYE_COLOR_* constant
void ModifySubraceEyeColors(string subrace, int Male_Eyes = -1, int Female_Eyes = -1, int Level = 1);

//3.0.6.9

// ::  Use to setup specific heads for subrace ::
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Male_Head: which head male is to be set.
// :: Female_Head: which head female is to be set.
void ModifySubraceHead(string subrace, int Male_Head = -1, int Female_Head = -1, int Level = 1);

//:: ----- LETO FUNCTION DEFINERS -------

// :: Add/remove a feat to/from the character belonging to a subrace ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE MANUAL FOR MORE DETAILS)
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: FeatID:  Use any FEAT_* constants.
// :: Remove: If set to TRUE, it will remove the the feat from the player.
// :: Level: Level at which to give this bonus feat.
//
// NOTE: Player must have the required expansion packs for the feats. IE: If you were to give Epic Dodge,
//       the player must have HoTU expansion pack installed inorder to recieve/use the feat.
//
// Example of Usage:
//
// Say I want to give Disarm at level 5, and improved knockdown at level 8 to the players belonging to Drow subrace.
//  I also want to remove Alterness from the player at level 10.
//
//   ModifySubraceFeat("drow", FEAT_DISARM, 5);
//   ModifySubraceFeat("drow", FEAT_IMPROVED_KNOCKDOWN, 8);
//   ModifySubraceFeat("drow", FEAT_ALERTNESS, 10, TRUE);
//
//:: You may use this as many times as desired.
void ModifySubraceFeat(string subrace, int FeatID, int Level = 1, int Remove = FALSE);


// :: Create custom base stats::
//
// >>> NEEDS LETO TO WORK (REFER TO THE MANUAL FOR MORE DETAILS)
//
// :: This is used in conjunction with CreateBaseStatModifier(...) -refer to it for more details.
//
// :: --- Fill in the Modifiers as desired.
//         For speed modification use any  MOVEMENT_SPEED_* constant.
//
// Example: I want to increase Strength by 6, decrease Dexterity by 4, increase Consitution by 4, and change the movement speed to fast.
//          So I would call:
//
//       struct SubraceBaseStatsModifier MyStats = CustomBaseStatsModifiers(6, -4, 4, 0, 0, 0, MOVEMENT_SPEED_FAST);
struct SubraceBaseStatsModifier CustomBaseStatsModifiers(int StrengthModifier, int DexterityModifier, int ConstitutionModifier, int IntelligenceModifier, int WisdomModifier, int CharismaModifier, int MovementSpeedModifier);


// :: Use to make PERMANENT changes to the ability scores or movement speed of the character::
//
// >>> NEEDS LETO TO WORK (REFER TO THE MANUAL FOR MORE DETAILS)
//
// :: This is used in conjunction with SubraceBaseStatsModifier CustomBaseStatsModifiers(...)
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: SubraceBaseStatsModifier Stats: Use CustomBaseStatsModifiers(...) to create the stats.
// :: Level: The level at which to make these changes.
// :: Set: If you set it to TRUE, then these stats will REPLACE (instead of adding or subtracting) the player's stats.
//
//
// Example of Useage:
// Say I have a subrace called: black-dragon.
//     And I want to increase Strength by 6, decrease Dexterity by 4, increase Consitution by 4,
//          and decrease charisma by 2, and change the movement speed to fast at level 10.
//
// So I would call:
//
//       struct SubraceBaseStatsModifier MyStats = CustomBaseStatsModifiers(6, -4, 4, 0, 0, -2, MOVEMENT_SPEED_FAST);
//       CreateBaseStatModifier("black-dragon", MyStats, 10);
//
// :: You may use this as many times as desired.
void CreateBaseStatModifier(string subrace, struct SubraceBaseStatsModifier Stats, int Level = 1, int Set = FALSE);


// :: Use to the soundset of the character ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE MANUAL FOR MORE DETAILS)
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: MaleSoundSet: Refer to the table in the PDF guide book and enter the 'Reference Number'.
// :: FemaleSoundSet: Refer to the table in the PDF guide book and enter the 'Reference Number'.
// :: Level: The level at which to change the soundset.
//
// Example of Useage:
//     Say I want to change the Male character's soundset to Minotaur, Chief and the Female character's
//     soundset to Succubusat level 16. And then at level 25 change it to Ogre and Nymph.
//     >>> According to the table in the PDF guide book the numbers are 65 for Minotaur Chief, 90 for the Succubus,
//         70 for Ogre, and 197 for the Nymph soundsets).
//
//     ChangeSoundSet("mysubrace", 65, 90, 16);
//     ChangeSoundSet("mysubrace", 70, 197, 25);
//
// :: You may use this as many times as desired.
void ChangeSoundSet(string subrace, int MaleSoundSet, int FemaleSoundSet, int Level = 1);


// :: Modify a skill a character belonging to a subrace has ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE MANUAL FOR MORE DETAILS)
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: SkillID: Use any  SKILL_* constants.
// :: iModifier: The value to increase or decrease or set the skill by/to.
// :: Set: If set to TRUE, the skill points in the chosen skill will be set to the value of iModifier.
//
// Example of Usage:
//
//    Say I want to increase Spot skill by 15, and decrease Search by 12 at level 10, and set Tumble to 5 at level 16.
//    I would call:
//
//    ModifySubraceSkill("mysubrace", SKILL_SPOT, 15, 10);
//    ModifySubraceSkill("mysubrace", SKILL_SEARCH, -12, 10);
//    ModifySubraceSkill("mysubrace", SKILL_TUMBLE, 5, 16, TRUE);
void ModifySubraceSkill(string subrace, int SkillID, int iModifier, int Level = 1, int Set = FALSE);


// ::  Use to setup a special subrace restriction
//
// :: subrace: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Type: The type of special restriction (e.g. item, variable etc) See SUBRACE_SPECIAL_RESTRICTION_*
// :: VarName: The variable name if a variable or the tag if item (etc.)
// :: Existance: if TRUE then this variable/item must exist, if FALSE it must not exist.
// :: Database: The name of the database or the tag of the item, which holds the variable (not used for "must have item"-restriction).
// ::   if Database is empty it will default to SUBRACE_DATABASE (if Database) or the Player (if Local var)
//                                   GetIsPCLightSensitive
// Written by: Moon
void CreateSubraceSpecialRestriction(string subrace, int Type, string VarName, int Existance=TRUE, string Database="");

/*
:::::::::::::::::::::::: Function Definers usuable anywhere ::::::::::::::::::::
*/
//:: You may use these functions anywhere, and they would work appropriately.

// ::Erases all "temporary" subracial abilities, so that after respawn or a restoring spell is cast
// ::the heartbeat script will then reapply the stats again.
void ReapplySubraceAbilities(object oPC);

//Add this on the Module OnClientEnter script.
void SubraceOnClientEnter(object oPC = OBJECT_INVALID);

//Add this to Module OnPlayerRespawn script.
void SubraceOnPlayerRespawn();

//Add this to Module OnPlayerLevelUp script.
void SubraceOnPlayerLevelUp();

//Add this to Module OnPlayerEquipItem script.
void SubraceOnPlayerEquipItem();

//Add this to the Module OnItemActivated script.
void SubraceOnItemActivated();

//Subrace Heartbeat function - For use in default.nss
void SubraceHeartbeat(object oPC = OBJECT_SELF);

//Add this to the Module OnClientLeave script.
void SubraceOnClientLeave();

//:: Returns TRUE if SSE has been disabled serverwide.
//:: This check does NOT care if SSE has been disabled in the current area.
int GetIsSSEDisabled();

//:: Returns TRUE if SSE has been disabled in Area.
//:: This check does NOT care if SSE has been disabled Serverwide.
//:: returns FALSE on error (e.g. if input is non an area)
int GetIsSSEDisabledInArea(object Area=OBJECT_SELF);

//:: Returns SSE_STATUS_OPERATIONAL if SSE is running properly.
//:: Else it returns a flag depending on the issue.
//:: See SSE_STATUS_* constants. It adds all that applies.
//:: If a non-valid area is supplied, area check is skipped.
int GetSSEStatus(object Area=OBJECT_INVALID);

//:: Force the player to properly un-equip the item.
void SHA_SubraceForceUnequipItem(object oItem);

//:: Force the player to properly equip oItem in the inventory slot: InvoSlot.
void SHA_SubraceForceEquipItem(object oItem, int InvoSlot);

//Return the XP modifier for being part of the Subrace
//(Calclates modifer value for Subrace Favored classes)
float GetSubraceXPModifier(object oPC);

//:: Returns TRUE if the player is marked as being part of an undead subrace.
//:: Returns FALSE if player is not an undead OR provided character is NOT a PC!
//:: (Shayan's Subrace Engine)
int Subrace_GetIsUndead(object oPC);

//:: Returns the Effective Character level of oPC.
//:: (Shayan's Subrace Engine)
int GetECL(object oPC);

//:: Deletes every bit of subracial information stored on the PC. Also destroys equipped skins and claws.
//:: Set ClearSubraceField to TRUE if you wish, to have their Subrace field cleared (set to "") after this is done.
//::   If you don't SSE will assume they are new to the subrace and re-initiate them to the subrace at next login (assuming they still meet the demands)
//:: (Shayan's Subrace Engine)
void DeleteSubraceInfoOnPC(object oPC, int ClearSubraceField=FALSE);

//:: Change the PC to his/her default humaniod appearance.
//:: IE: If the player is human and his/her appearance is Illithid, this will turn them back
//::     to looking like human again.
//:: (Shayan's Subrace Engine)
void ChangeToPCDefaultAppearance(object oPC);


//:: Returns TRUE if PC belongs to a subrace which is Light sensitive.
//:: (Shayan's Subrace Engine)
int GetIsPCLightSensitive(object oPC);

//:: Return the Favored class of the PC. Returns -1 if there is none.
//:: (Shayan's Subrace Engine)
int Subrace_GetFavouredClass(object oPC);

//:: Send's a message to PC, with a Subrace Engine title. Set Important to TRUE if
//:: it is an important message. (Refer to sha_subr_consts for more info.)
//:: (Shayan's Subrace Engine)
void SHA_SendSubraceMessageToPC(object oPC, string message, int Important = TRUE);

//:: Send's a message to PC with a Subrace Engine title. This will follow the new
//:: message standards and allow very selective messages. If you wish to use this
//:: for non-standard-SSE messages, MessageReference should be MESSAGE_USER_MADE.
//:: VariableText will then be directly displayed (With Subrace Engine title)
//::
//:: MessageType must contain the MESSAGE_TYPE_* constants, for user made messages!
//::
//:: NOTE: MESSAGE_TYPE_VITAL will ALWAYS be displayed REGARDLESS of settings and
//:: MESSAGE_TYPE_LOG will ALWAYS be logged! (Assuming there is a message to send/log)
//::
//::
//:: (Refer to the manual or sha_subr_consts for more info.)
//:: (Shayan's Subrace Engine)
void SSE_MessageHandler(object Receiver, int MessageReference, string VariableText="", string VariableText2="", int MessageType = MESSAGE_TYPE_DEFAULT);

//:: Traverses through oPC's inventory, destroying all Skins, and creature items.
void SearchAndDestroySkinsAndClaws(object oPC);

//:: Removes temporary subrace ability scores and AB boosts.
void ClearSubraceEffects(object oPC);

//:: Returns TIME_DAY, or TIME_NIGHT depending on the current hour of day.
int SHA_GetCurrentTime();

//:: Returns the default appearance type of oPC. (It ignores any appearance
//:: change by SetAppearance()).
//:: NOTE: oPC must be a player character in order for this to work.
int SHA_GetDefaultAppearanceType(object oPC);

//:: This will load scripts containing sub-races. You can use the Conditions parameter
//:: if you want to make the script load only if Leto is (or is not) enabled.
void LoadSubraceFromScript(string Script, int Conditions=SSE_SUBRACE_LOADER_CONDITION_ALWAYS_LOAD);

// :: Switch oTarget's subrace to Subrace
// :: Note this function does not do any checking, to see if oTarget meets
// :: any alignment or race criteria. Should be used with caution.
// :: Takes approximately 12 - 15 seconds to complete.
void ApplySubrace(object oTarget, string Subrace);

// :: Use this on the OnModuleLoad script to signal that the subraces has been loaded
// :: and we are good to go. If you do not call this one, SSE will wait forever!
// :: It has an internal delay and will wait up 30 seconds for other sub-race scripts to load.
// :: NOTE! After the first sub-race load has been detected, further 5 seconds are given to finish
// ::   the loading. After that SSE will not wait any further!
// ::   It is adviced to have all your subraces load within 5 seconds of each other!
// :: (If you use LoadSubraceFromScript(), you do not have to worry about this)
// ::
// :: doNWNXInit is used to call the NWNX Init "NWNX!INIT" with parameter "1".
// :: set to TRUE if you do not have an external call to it and plan on using NWNX (Leto or NWNX database)
void SSE_ModuleLoadEvent(int doNWNXInit=FALSE);

// :: Use this to get the base race of the alias.
// :: if Alias is the base race then it returns itself.
// :: returns "" if the Alias is not valid/no such subrace exist
// :: if Lowercase is TRUE it will return a lowercased string
string GetSubraceNameByAlias(string Alias, int Lowercase=FALSE);

// :: Use this to get the race name of the ID.
// :: returns "" if the Alias is not valid/no such subrace exist
// :: if Lowercase is TRUE it will return a lowercased string
string GetSubraceNameByID(int ID, int Lowercase=FALSE);

// :: Returns the Player's Subrace ID.
int GetPlayerSubraceID(object Player);

//This will add MessageType too the list of message types that is SSE may display
//If no list is present, a new (empty) list will be created and the type will be added to it.
//NOTE: Vital will ALWAYS be displayed and Log will ALWAYS be logged!
void SSE_Message_AddDisplayType(int MessageType);

//This will remove MessageType from the list of message types that is SSE may display
//If no list is present, it is assumed you want to use the server default without this type!
//NOTE: Vital will ALWAYS be displayed and Log will ALWAYS be logged!
void SSE_Message_RemoveDisplayType(int MessageType);

//Creates a new list of the Message types SSE that is allowed to display with MessageType as an entry
//  the old list will be deleted.
//NOTE: Vital will ALWAYS be displayed and Log will ALWAYS be logged!
void SSE_Message_SetDisplayType(int MessageType);

//returns the list of message types SSE is allowed to display.
//if no list is present, MESSAGE_TYPE_SERVER_DEFAULT or FALSE will be returned depending on DoNotReturnServerDefault
int SSE_Message_GetDisplayType(int DoNotReturnServerDefault=FALSE);


//3.0.6

// Adds horse Menu Feat to Hide of oPC
void SSE_HorseAddHorseMenu(object oPC);

// :: 3.0.6.5

// - Activate Spell-Like Ability
//
// oPC :            Ability user
//
// AbilityUsed :    SPELL_*, SPELLABILITY_*, or # from spells.2da
//
// oTarget :        Ability subject, if not provided oPC is target
//
void SubraceAbility(object oPC, int AbilityUsed, object oTarget = OBJECT_SELF);

// - Replaces subrace value of "" with SUBRACE_*_DEFAULT
// if USE_SSE_DEFAULT_RACES = TRUE
void CheckAndApplyDefaultSubrace(object oPC);

// - Returns oPC's subrace death location Waypoint
object GetSubraceDeathWaypoint(object oPC);

// - Returns oPC's subrace death location Waypoint
object GetSubraceStartWaypoint(object oPC);

// - Move oPC to subrace's death location or defaults
void Subrace_MoveToDeathLocation(object oPC);

//3.0.6.6

// Gives oPC it's subraces's hair and/or skin color
void ApplySubraceColors(object oPC);

// Gives oPC it's subraces's glowing eyes
void ApplySubraceEyeColors(object oPC);

// Gives oPC glowing eyes, use any SUBRACE_EYE_COLOR_* const
void SHA_SetEyeColor(object oPC, int iEyes = -1);

//3.0.6.9

// Gives oPC it's subraces's head
void ApplySubraceHead(object oPC);

//
//::::::::::::::::::::::::: Interal Function definers:::::::::::::::::::::::::::
//
// :: Do not use these functions outside this script. They may not work correctly.

string SSE_GetStandardMessage(int Ref, string VariableText="", string VariableText2="");
void SaveSubraceOnModule(struct Subrace shaSubrace);
void GiveSubraceUniqueItem(string SubraceStorage, object oPC);
void SaveSubraceAlignmentRestrictionOnModule(struct SubraceAlignmentRestriction shaSubraceAlignRes);
void SaveSubraceClassRestrictionOnModule(struct SubraceClassRestriction shaSubraceClassRes);
void SaveSubraceSpellResistanceOnModule(struct SubraceSpellResistance shaSubraceSpellRes);
void SaveSubraceAppearanceChangeOnModule(struct SubraceDifferentAppearance shaSubraceApp);
int CheckIfPCMeetsClassCriteria(object oPC, string SubraceStorage);
int CheckIfPCMeetsAlignmentCriteria(object oPC, string SubraceStorage);
int CheckIfPCMeetsAnySubraceCriteria(object oPC);
int CheckIfPCMeetsSpecialCriteria(object oPC, string SubraceStorage);
void SHA_ApplyTemporaryStats(object oPC, string SubraceStorage, int iCurrentTime, int iTime, int AreasReq/*int AreaUndAbove, int AreaIntExt, int AreaNatArt*/);
void ApplyTemporarySubraceStats(object oPC, string SubraceStorage, int iCurrentTime, int AreaUndAbove, int AreaIntExt, int AreaNatArt);
void ApplyStat_AbilityByPercentage(int AbilityToMod, float percentage, object oPC);
void ApplySubraceBonusStatsByPercentage(object oPC, string SubraceStorage);
void ApplyAttackBonusByPercentage(float percentage, object oPC);
void ApplyArmourClassBonusByPercentage(float percentage, object oPC);
void ApplySubraceBonusStatsByPoints(object oPC, string SubraceStorage);
void ApplyStat_AbilityByPoints(int AbilityToMod, float points, object oPC);
void ApplyAttackBonusByPoints(float points, object oPC);
void ApplyTemporarySubraceAppearance(string SubraceStorage, object oPC, int iCurrentTime);
void ApplyArmourClassBonusByPoints(float points, object oPC);
void ClearSubraceTemporaryStats(object oPC);
void LoadSubraceInfoOnPC(object oPC, string subrace);
void ApplyPermanentSubraceSpellResistance(int ID, object oPC);
void InitiateSubraceChecking(object oPC);
int GetFavoredClassExceedsGap(int Race1Favored, int Race2Favored, int Class1, int Class2, int Class3, int Class13Gap, int Class23Gap, int Class12Gap);
void ApplySubraceEffect(object oPC, string SubraceStorage, int TimeOfDay);
void CheckIfCanUseEquipedWeapon(object oPC);
void EquipTemporarySubraceClaw(string SubraceStorage, object oPC, int iTime);
void EquipTemporarySubraceSkinstring (string SubraceStorage, object oPC, int iTime);
void CheckAndSwitchSubrace(object oPC);
void SubraceCheckItemActivated(object oPC, string sTag);
string Subrace_TimeToString(int iTime);
int CheckIfPCMeetsPrestigiousClassCriteria(object oPC, string SubraceStorage);
int CheckForLetoReLog(object oPC, int Level);
string CheckAndModifyBaseStats(object oPC, string SubraceStorage, int Level);
string CheckAndModifySkills(object oPC, string SubraceStorage, int Level);
string CheckAndModifyFeats(object oPC, string SubraceStorage, int Level);
string CheckAndModifySoundSet(object oPC, string SubraceStorage, int Level);
void DelayBoot(object oPC);
void Subrace_FactionAdjustment(object oPC, string FactionTag, int Adjustment);
void ChangeSubraceFactions(object oPC, string SubraceStorage);
void Subrace_MoveToStartLocation(object oPC, string subrace = "");
//void SetSubraceDBInt(string sCampaignName, string sVarName, int nInt, object oPlayer=OBJECT_INVALID);
//int GetSubraceDBInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);
//void DeleteSubraceDBInt(string sCampaignName, string sVarName, object oPlayer);
void DeleteSubraceInfoInDatabase(object oPC, string subrace);
void CheckIfCanUseEquippedArmor(object oPC);
void ApplyPermanentSubraceAppearance(int ID, object oPC);
void ChangeMiscellaneousSubraceStuff(object oPC, int Level);
void ModifyAttachments(object oPC, string SubraceStorage, int Level);

//Memory handling - Added in 3.0.5

int GetSSEInt(string VariableName);
void DeleteSSEInt(string VariableName);
void SetSSEInt(string VariableName, int Value);
int GetSubraceID(string subrace);
void SetSubraceID(string subrace, int Value);
string GetSubraceStorageLocationByID(int SubraceID);
string GetSubraceStorageLocation(string subrace);

//::****************************************************************
// 1.69 -- Returns TRUE if oSkin is valid and has the Horse Menu Feat on it. Returns FALSE otherwise.
int GetSkinHasHorseMenu( object oSkin);
//::****************************************************************

//:: ---------------------------------------------------------------------------
//:: Functions for the Subrace Engine.
//:: ---------------------------------------------------------------------------

//Data is stored on the module for easy central access.
object oStorer = GetModule();

/*
::::::::::::::::::::::::::: Function definers ::::::::::::::::::::::::::::::::::
*/
// :: Below lies the list of all the functions useable OnModuleLoad to setup
// :: a subrace.

//3.0.6.5

void SubraceAbility(object oPC,int AbilityUsed,object oTarget = OBJECT_SELF)
{
    AssignCommand(oPC, ClearAllActions());
    if (oTarget == OBJECT_INVALID) oTarget = oPC;
    AssignCommand(oPC,ActionCastSpellAtObject(AbilityUsed,oTarget,METAMAGIC_NONE,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
}

object GetSubraceStartWaypoint(object oPC)
{
  string SubraceStorage =  GetSubraceStorageLocation(GetSubRace(oPC));
  string WPTag = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_START_LOCATION);
  object oWP = GetWaypointByTag(WPTag);
  return oWP;
}

object GetSubraceDeathWaypoint(object oPC)
{
  string SubraceStorage =  GetSubraceStorageLocation(GetSubRace(oPC));
  string WPTag = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_DEATH_LOCATION);
  object oWP = GetWaypointByTag(WPTag);
  return oWP;
}

// 3.0.6.4
void CreateSubraceDeathLocation(string subrace, string WaypointTag)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_DEATH_LOCATION, WaypointTag);
}

//3.0.6
void SSE_HorseAddHorseMenu(object oPC)
{ // PURPOSE: Add Horse Menu to the PC
    object oSkin=SKIN_SupportGetSkin(oPC);
    itemproperty iProp;
    if (GetIsPC(oPC))
    { // valid parameter
        iProp=ItemPropertyBonusFeat(40);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oSkin);
    } // valid parameter
} // HorseAddHorseMenu()


void CreateSubrace(int Race, string subrace, string HideResRef = "", string UniqueItemResRef = "", int IsLightSensitive = FALSE, int DamageTakenWhileInLight = 0, int IsUndergroundSensitive = FALSE, int DamageTakenWhileInUnderground = 0, int ECL = 0, int IsUndead = FALSE, int PrestigiousSubrace = FALSE)
{
    struct Subrace shaSubrace;

    shaSubrace.BaseRace = Race;
    shaSubrace.Name = subrace;
    shaSubrace.SkinResRef = HideResRef;
    shaSubrace.UniqueItemResRef =  UniqueItemResRef;
    shaSubrace.IsLightSensitive = IsLightSensitive;
    shaSubrace.DamageTakenWhileInLight = DamageTakenWhileInLight;
    shaSubrace.IsUndergroundSensitive = IsUndergroundSensitive;
    shaSubrace.DamageTakenWhileInUnderground = DamageTakenWhileInUnderground;
    shaSubrace.ECL = ECL;
    shaSubrace.IsUndead = IsUndead;
    shaSubrace.PrestigiousSubrace = PrestigiousSubrace;

    SaveSubraceOnModule(shaSubrace);
}

//3.0.6.7
void CreateSubraceAlignmentRestriction(string subrace, int CanBeAlignment_Good = TRUE , int CanBeAlignment_Neutral1 = TRUE, int CanBeAlignment_Evil = TRUE, int CanBeAlignment_Lawful = TRUE, int CanBeAlignment_Neutral2 = TRUE, int CanBeAlignment_Chaotic = TRUE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int restri = FLAG1 | (CanBeAlignment_Good?FLAG2:0) | (CanBeAlignment_Neutral1?FLAG3:0) | (CanBeAlignment_Evil?FLAG4:0);
   restri |= (CanBeAlignment_Lawful?FLAG5:0) | (CanBeAlignment_Neutral2?FLAG6:0) | (CanBeAlignment_Chaotic?FLAG7:0);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, restri);
}


//3.0.6.7
void CreateSubraceClassRestriction(string subrace, int CanBe_Barbarian = TRUE, int CanBe_Bard = TRUE, int CanBe_Cleric = TRUE, int CanBe_Druid = TRUE, int CanBe_Fighter = TRUE, int CanBe_Monk = TRUE, int CanBe_Paladin = TRUE, int CanBe_Ranger = TRUE, int CanBe_Rogue = TRUE, int CanBe_Sorcerer = TRUE, int CanBe_Wizard = TRUE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int restri = FLAG1 | (CanBe_Barbarian?FLAG2:0) | (CanBe_Bard?FLAG3:0) | (CanBe_Cleric?FLAG4:0);
   restri |= (CanBe_Druid?FLAG5:0) | (CanBe_Fighter?FLAG6:0) | (CanBe_Monk?FLAG7:0);
   restri |= (CanBe_Paladin?FLAG8:0) | (CanBe_Ranger?FLAG9:0) | (CanBe_Rogue?FLAG10:0);
   restri |= (CanBe_Sorcerer?FLAG11:0) | (CanBe_Wizard?FLAG12:0);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, restri);
}

//3.0.6.7
void CreateSubraceGenderRestriction(string subrace, int CanBeMale = TRUE, int CanBeFemale = TRUE)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    int GenderFlag = (CanBeMale?0:FLAG2) | (CanBeFemale?0:FLAG1);
    SetSSEInt(SubraceStorage + "_" + SUBRACE_GENDER_RES, GenderFlag);
}

void CreateSubraceSpellResistance(string subrace, int SpellResistanceBase, int SpellResistanceMax)
{
   struct SubraceSpellResistance shaSubraceSpellRes;
   shaSubraceSpellRes.subrace = subrace;
   shaSubraceSpellRes.SpellResistanceBase = SpellResistanceBase;
   shaSubraceSpellRes.SpellResistanceMax = SpellResistanceMax;
   SaveSubraceSpellResistanceOnModule(shaSubraceSpellRes);
}

void CreateSubraceAppearance(string subrace, int AppearanceChangeTime, int MaleAppearance, int FemaleAppearance, int Level = 1)
{
   struct SubraceDifferentAppearance shaSubraceApp;
   if(AppearanceChangeTime == TIME_SPECIAL_APPEARANCE_SUBRACE)
    {
    AppearanceChangeTime = TIME_NONE;
    }
   shaSubraceApp.subrace = subrace;
   shaSubraceApp.ChangeAppearanceTime = AppearanceChangeTime;
   shaSubraceApp.MaleAppearance = MaleAppearance;
   shaSubraceApp.FemaleAppearance = FemaleAppearance;
   shaSubraceApp.Level = Level;
   SaveSubraceAppearanceChangeOnModule(shaSubraceApp);
}

void AddAdditionalBaseRaceToSubrace(string subrace, int AdditionalBaseRace)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int Flag = NOFLAGS;
   switch(AdditionalBaseRace)
   {
      case RACIAL_TYPE_DWARF: Flag = FLAG1; break;
      case RACIAL_TYPE_ELF:  Flag = FLAG2;  break;
      case RACIAL_TYPE_GNOME: Flag = FLAG3;  break;
      case RACIAL_TYPE_HALFELF: Flag = FLAG4;   break;
      case RACIAL_TYPE_HALFLING: Flag = FLAG5;  break;
      case RACIAL_TYPE_HALFORC: Flag = FLAG6;  break;
      case RACIAL_TYPE_HUMAN: Flag = FLAG7;  break;
      case RACIAL_TYPE_ALL:  Flag = ALLFLAGS;  break;
      default: Flag = NOFLAGS;  break;
   }
   SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_RACE, Flag, SUBRACE_BASE_RACE_FLAGS);
}

int GetIsSSEDisabledInArea(object Area=OBJECT_SELF){
    if(!GetIsObjectValid(Area)) return FALSE;
    return GetLocalInt(Area, "DISABLE_SUBRACE_ENGINE");
}

int GetIsSSEDisabled(){
    return GetSSEInt("SHUTDOWN_SSE");
}

int GetSSEStatus(object Area=OBJECT_INVALID){
    int Value = SSE_STATUS_OPERATIONAL;
    int StatusArea = GetIsSSEDisabledInArea(Area)?SSE_STATUS_DISABLED_IN_AREA:SSE_STATUS_OPERATIONAL;
    int ServerSetting = GetIsSSEDisabled()?SSE_STATUS_DISABLED_IN_AREA:SSE_STATUS_OPERATIONAL;
    Value = StatusArea | ServerSetting;
    return Value;
}

void SetupSubraceAlias(string subrace, string Alias)
{
    //Check if sub-race already exists.
    if(GetSubraceID(Alias))
        {
        string Log="*Subrace Engine: Sub-race alias: ";
        string trueName=GetSubraceNameByAlias(Alias);
        Log+="ERROR\nAttempting to create sub-race alias [" + Alias + "] failed: Similar named sub-race ["+trueName+"] already exists";
        WriteTimestampedLogEntry(Log);
        return;
        }

    int ID = GetSubraceID(subrace);
    if(!ID)
        {
        string Log="*Subrace Engine: Sub-race alias: ";
        Log+="ERROR\nAttempting to create sub-race alias [" + Alias + "] for ["+subrace+"] failed: No sub-race with that name exists.";
        WriteTimestampedLogEntry(Log);
        return;
        }
    SetSubraceID(Alias, ID);
    if(SSE_TREAT_ALIAS_AS_SUBRACE & 2)
        {
        string SubraceStorage = GetSubraceStorageLocationByID(ID);
        int Num = GetSSEInt(SubraceStorage + "_ALIAS");
        Num++;
        SetLocalString(oStorer, SubraceStorage + "_ALIAS_" + IntToString(Num), Alias);
        SetSSEInt(SubraceStorage + "_ALIAS", Num);
        }
}

void AddSubraceEffect(string subrace, int EffectID, int Value1, int Value2, int nDurationType, float fDuration, int TimeOfDay)
{
  string SubraceStorage = GetSubraceStorageLocation(subrace);
  int Count = GetSSEInt(SubraceStorage + "_" + SUBRACE_EFFECT_COUNT);
  Count++;
  SetSSEInt(SubraceStorage + "_" + SUBRACE_EFFECT_COUNT, Count);
  SubraceStorage = SubraceStorage + IntToString(Count);
  SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT, EffectID, SUBRACE_EFFECT_FLAGSET);
  SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT, Value1, SUBRACE_EFFECT_VALUE1_FLAGSET);
  SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT, Value2, SUBRACE_EFFECT_VALUE2_FLAGSET);
  SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT, TimeOfDay, SUBRACE_EFFECT_TIME_FLAGSET);
  SetSSEInt(SubraceStorage + "_" + SUBRACE_EFFECT_DURATION_TYPE, nDurationType);
  SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT_DURATION, fDuration);
}

void AddSubraceFavoredClass(string subrace, int MaleFavoredClass, int FamaleFavoredClass)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_FAVORED_CLASS, MaleFavoredClass + 1, SUBRACE_FAVORED_CLASS_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_FAVORED_CLASS, FamaleFavoredClass + 1, SUBRACE_FAVORED_CLASS_FEMALE_FLAG);
}

void CreateSubraceSpecialRestriction(string subrace, int Type, string VarName, int Existance=TRUE, string Database="")
{
  string SubraceStorage = GetSubraceStorageLocation(subrace);
  int Count = GetSSEInt(SubraceStorage + "_" + SUBRACE_SPECIAL_RESTRICTION);
  Count++;
  SetSSEInt(SubraceStorage + "_" + SUBRACE_SPECIAL_RESTRICTION, Count);

  SubraceStorage = SubraceStorage +"_"+SUBRACE_SPECIAL_RESTRICTION+IntToString(Count);

  SetSSEInt(SubraceStorage, Type | Existance);
  SetLocalString(oStorer, SubraceStorage + SUBRACE_SPECIAL_RESTRICTION_VARNAME, VarName);
  if(Database!="" && Database!=SUBRACE_DATABASE)
    SetLocalString(oStorer, SubraceStorage + SUBRACE_SPECIAL_RESTRICTION_DATABASE, Database);
}

//3.0.6.7

void CreateSubracePrestigiousClassRestriction(string subrace, int MinimumLevels = 1, int CanBe_ArcaneArcher = TRUE, int CanBe_Assasin = TRUE, int CanBe_Blackguard = TRUE, int CanBe_ChampionOfTorm = TRUE, int CanBe_RedDragonDisciple = TRUE, int CanBe_DwarvenDefender = TRUE, int CanBe_HarperScout = TRUE, int CanBe_PaleMaster = TRUE, int CanBe_ShadowDancer = TRUE, int CanBe_Shifter = TRUE, int CanBe_WeaponMaster = TRUE, int CanBe_PurpleDragonKnight = TRUE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int restri = FLAG1 | (CanBe_ArcaneArcher?FLAG2:0) | (CanBe_Assasin?FLAG3:0) | (CanBe_Blackguard?FLAG4:0);
   restri |= (CanBe_ChampionOfTorm?FLAG5:0) | (CanBe_RedDragonDisciple?FLAG6:0) | (CanBe_DwarvenDefender?FLAG7:0);
   restri |= (CanBe_PaleMaster?FLAG8:0) | (CanBe_ShadowDancer?FLAG9:0) | (CanBe_Shifter?FLAG10:0);
   restri |= (CanBe_WeaponMaster?FLAG11:0) | (CanBe_HarperScout?FLAG12:0) | (CanBe_PurpleDragonKnight?FLAG13:0);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, restri);
}

void CreateTemporaryStatModifier(string subrace, struct SubraceStats Stats, int TimeToApply, int InInteriorArea = TRUE, int InExteriorArea = TRUE, int InNaturalArea = TRUE, int InArtifacialArea = TRUE, int InUndergroundArea = TRUE, int InAbovegroundArea = TRUE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);

   int iTime = TimeToApply | GetSSEInt(SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, iTime);

   int ModType = Stats.ModType;
   float StrengthModifier = Stats.StrengthModifier;
   float DexterityModifier = Stats.DexterityModifier;
   float ConstitutionModifier = Stats.ConstitutionModifier;
   float IntelligenceModifier = Stats.IntelligenceModifier;
   float WisdomModifier = Stats.WisdomModifier;
   float CharismaModifier = Stats.CharismaModifier;
   float ACModifier = Stats.ACModifier;
   float ABModifier = Stats.ABModifier;

   SubraceStorage = SubraceStorage + IntToString(TimeToApply);

   SetSSEInt(SubraceStorage + "_" + SUBRACE_STAT_MODIFIER_TYPE, ModType);
   //Flags
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG4, InInteriorArea);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG5, InExteriorArea);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG6, InArtifacialArea);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG7, InNaturalArea);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG8, InAbovegroundArea);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS, FLAG9, InUndergroundArea);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_STR_MODIFIER, StrengthModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_DEX_MODIFIER, DexterityModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_CON_MODIFIER, ConstitutionModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_WIS_MODIFIER, WisdomModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_INT_MODIFIER, IntelligenceModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_CHA_MODIFIER, CharismaModifier);
   SetLocalFloat(oStorer, SubraceStorage  + "_" + SUBRACE_STAT_AB_MODIFIER, ABModifier);
   SetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_AC_MODIFIER, ACModifier);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_HAS_DAY_NIGHT_EFFECTS, TRUE);
}


//For StatModiferType use only SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE or SUBRACE_STAT_MODIFIER_TYPE_POINTS
struct SubraceStats CreateCustomStats(int StatModifierType, float StrengthModifier, float DexterityModifier, float ConstitutionModifier, float IntelligenceModifier, float WisdomModifier, float CharismaModifier, float ACModifier, float ABModifier)
{
  struct SubraceStats Stats;
  Stats.ModType =  StatModifierType;
  Stats.StrengthModifier = StrengthModifier;
  Stats.DexterityModifier = DexterityModifier;
  Stats.ConstitutionModifier = ConstitutionModifier;
  Stats.IntelligenceModifier  =  IntelligenceModifier;
  Stats.WisdomModifier =  WisdomModifier;
  Stats.CharismaModifier =  CharismaModifier;
  Stats.ACModifier =  ACModifier;
  Stats.ABModifier =  ABModifier;
  return Stats;
}


void SubraceRestrictUseOfItems(string subrace, int ItemType, int TimeOfDay = TIME_BOTH, int Allow = ITEM_TYPE_REQ_DO_NOT_ALLOW)
{

   string SubraceStorage = GetSubraceStorageLocation(subrace) + "_" + SUBRACE_ITEM_RESTRICTION + "_";
   int Set = ItemType;
   if(! (Allow & ITEM_TYPE_REQ_DO_NOT_ALLOW) )
        {
        Set = (~Set);
        }

    if(Allow & ITEM_TYPE_REQ_ALL)
        {
        Set |= ITEM_TYPE_REQ_ALL;
        }
      else
        {
        Set &= (~ITEM_TYPE_REQ_ALL);
        }

    switch(TimeOfDay)
    {
        case TIME_NONE:
            //We no use TIME_NONE here, mon. Da i-da-ot mean subrace-form me thinks!
            TimeOfDay = TIME_SPECIAL_APPEARANCE_SUBRACE; //No break mon!
        case TIME_NIGHT:
        case TIME_DAY:
        case TIME_SPECIAL_APPEARANCE_SUBRACE:
        case TIME_SPECIAL_APPEARANCE_NORMAL:
            SetLocalInt( oStorer, SubraceStorage + IntToString(TimeOfDay), Set);
            break;
        case TIME_BOTH:
            SetLocalInt( oStorer, SubraceStorage + IntToString(TIME_NIGHT), Set);
            SetLocalInt( oStorer, SubraceStorage + IntToString(TIME_DAY), Set);
            break;
    }
if(GetSSEInt(SubraceStorage + IntToString(TIME_SPECIAL_APPEARANCE_NORMAL))
    && GetSSEInt(SubraceStorage + IntToString(TIME_SPECIAL_APPEARANCE_SUBRACE)) )
    {
    //Both Appearance forms have restrictions, No time based restrictions.
    if(GetSSEInt(SubraceStorage + IntToString(TIME_DAY)))
        DeleteSSEInt( SubraceStorage + IntToString(TIME_DAY));
    if(GetSSEInt(SubraceStorage + IntToString(TIME_NIGHT)))
        DeleteSSEInt( SubraceStorage + IntToString(TIME_NIGHT));
    }
}

void SetupSubraceSwitch(string subrace, string switchSubraceNames, int Level, int MustMeetRequirements = TRUE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_SWITCH_NAME + IntToString(Level), switchSubraceNames);
   if(MustMeetRequirements)
   {
      SetSSEInt( SubraceStorage + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level), TRUE);
   }
}

//:: Internal Functions
void SaveSubraceOnModule(struct Subrace shaSubrace)
{
    string subrace = (SSE_AUTO_FORMAT_SUBRACE_NAMES?CapitalizeString(shaSubrace.Name):shaSubrace.Name);

    //Check if sub-race already exists.
    if(GetSubraceID(subrace))
        {
        string Log="*Subrace Engine: Sub-race creation: ";
        string trueName=GetSubraceNameByAlias(subrace);
        if(GetStringLowerCase(trueName) == GetStringLowerCase(subrace))
            {
            //Sub-race already exists, die...
            Log+="ERROR\nAttempting to create sub-race [" + shaSubrace.Name + "] failed: Sub-race already exists";
            WriteTimestampedLogEntry(Log);
            return;
            }
        Log+="WARNING\nSub-race Alias [" + shaSubrace.Name + "] for the sub-race ["+trueName+"] was overriden, when Sub-race ["+subrace+"] was created.";
        }

    //Save the count, and the name of the subrace.
    int iCount = GetSSEInt( MODULE_SUBRACE_COUNT);
    iCount++;
    SetSubraceID(subrace, iCount);
    SetSSEInt( MODULE_SUBRACE_COUNT, iCount);
    SetLocalString(oStorer, MODULE_SUBRACE_NUMBER + IntToString(iCount), subrace);

    string SubraceStorage = GetSubraceStorageLocation(subrace);


    int Flag = NOFLAGS;
    switch(shaSubrace.BaseRace)
    {
      case RACIAL_TYPE_DWARF: Flag = FLAG1; break;
      case RACIAL_TYPE_ELF:  Flag = FLAG2;  break;
      case RACIAL_TYPE_GNOME: Flag = FLAG3;  break;
      case RACIAL_TYPE_HALFELF: Flag = FLAG4;   break;
      case RACIAL_TYPE_HALFLING: Flag = FLAG5;  break;
      case RACIAL_TYPE_HALFORC: Flag = FLAG6;  break;
      case RACIAL_TYPE_HUMAN: Flag = FLAG7;  break;
      case RACIAL_TYPE_ALL:  Flag = ALLFLAGS;  break;
      default: Flag = NOFLAGS;  break;
    }
    SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_RACE, Flag, SUBRACE_BASE_RACE_FLAGS);

    if(shaSubrace.SkinResRef != "none" && shaSubrace.SkinResRef != "")
    {
        SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_SKIN + "_1" + "_" + IntToString(TIME_BOTH), GetStringLowerCase( shaSubrace.SkinResRef ));
    }
    if(shaSubrace.UniqueItemResRef != "" && shaSubrace.UniqueItemResRef != "none")
    {
        int SubraceUniqueItemCount = 1;
        SetSSEInt( SubraceStorage + "_" + SUBRACE_UNIQUEITEM_COUNT, SubraceUniqueItemCount);
        SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_UNIQUEITEM + "_1",GetStringLowerCase( shaSubrace.UniqueItemResRef ) + "_1");
        WriteTimestampedLogEntry("DEBUG : Subrace Unique Item Resref: "+GetStringLowerCase( shaSubrace.UniqueItemResRef ) + "_1");
    }
    SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsLightSensitive);
    SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsUndergroundSensitive);
    SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDEAD, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsUndead);
    SetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.PrestigiousSubrace);

    if(shaSubrace.DamageTakenWhileInLight)
    {
        SetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_LIGHT, shaSubrace.DamageTakenWhileInLight);
    }

    if(shaSubrace.DamageTakenWhileInUnderground)
    {
        SetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND, shaSubrace.DamageTakenWhileInUnderground);
    }
    if(shaSubrace.ECL)
    {
       SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, shaSubrace.ECL,  SUBRACE_BASE_INFORMATION_ECL);
    }

    if(shaSubrace.DamageTakenWhileInUnderground  || shaSubrace.DamageTakenWhileInLight || shaSubrace.IsLightSensitive || shaSubrace.IsUndergroundSensitive)
    {
       SetSSEInt( SubraceStorage + "_" + SUBRACE_HAS_DAY_NIGHT_EFFECTS, TRUE);
    }
}

//3.0.6.7

void SaveSubraceAlignmentRestrictionOnModule(struct SubraceAlignmentRestriction shaSubraceAlignRes)
{
   string SubraceStorage = GetSubraceStorageLocation(shaSubraceAlignRes.subrace);
   int restri = FLAG1 | (shaSubraceAlignRes.CanBeAlignment_Good?FLAG2:0) | (shaSubraceAlignRes.CanBeAlignment_Neutral1?FLAG3:0) | (shaSubraceAlignRes.CanBeAlignment_Evil?FLAG4:0);
   restri |= (shaSubraceAlignRes.CanBeAlignment_Lawful?FLAG5:0) | (shaSubraceAlignRes.CanBeAlignment_Neutral2?FLAG6:0) | (shaSubraceAlignRes.CanBeAlignment_Chaotic?FLAG7:0);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, restri);
/*
   string SubraceStorage = GetSubraceStorageLocation(shaSubraceAlignRes.subrace);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG1, TRUE);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG2, shaSubraceAlignRes.CanBeAlignment_Good);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG3, shaSubraceAlignRes.CanBeAlignment_Neutral1);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG4, shaSubraceAlignRes.CanBeAlignment_Evil);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG5, shaSubraceAlignRes.CanBeAlignment_Lawful);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG6, shaSubraceAlignRes.CanBeAlignment_Neutral2);
   SetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG7, shaSubraceAlignRes.CanBeAlignment_Chaotic);
*/
}

//3.0.6.7

void SaveSubraceClassRestrictionOnModule(struct SubraceClassRestriction shaSubraceClassRes)
{
   string SubraceStorage = GetSubraceStorageLocation(shaSubraceClassRes.subrace);
   int restri = FLAG1 | (shaSubraceClassRes.CanBe_Barbarian?FLAG2:0) | (shaSubraceClassRes.CanBe_Bard?FLAG3:0) | (shaSubraceClassRes.CanBe_Cleric?FLAG4:0);
   restri |= (shaSubraceClassRes.CanBe_Druid?FLAG5:0) | (shaSubraceClassRes.CanBe_Fighter?FLAG6:0) | (shaSubraceClassRes.CanBe_Monk?FLAG7:0);
   restri |= (shaSubraceClassRes.CanBe_Paladin?FLAG8:0) | (shaSubraceClassRes.CanBe_Ranger?FLAG9:0) | (shaSubraceClassRes.CanBe_Rogue?FLAG10:0);
   restri |= (shaSubraceClassRes.CanBe_Sorcerer?FLAG11:0) | (shaSubraceClassRes.CanBe_Wizard?FLAG12:0);
   SetSSEInt(SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, restri);
}

void SaveSubraceSpellResistanceOnModule(struct SubraceSpellResistance shaSubraceSpellRes)
{
   string SubraceStorage = GetSubraceStorageLocation(shaSubraceSpellRes.subrace);

   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_SPELL_RESISTANCE, shaSubraceSpellRes.SpellResistanceBase,SUBRACE_SPELL_RESISTANCE_BASE_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_SPELL_RESISTANCE, shaSubraceSpellRes.SpellResistanceMax, SUBRACE_SPELL_RESISTANCE_MAX_FLAGS);
}

void SaveSubraceAppearanceChangeOnModule(struct SubraceDifferentAppearance shaSubraceApp)
{
   string SubraceStorage = GetSubraceStorageLocation(shaSubraceApp.subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(shaSubraceApp.Level);
   SetLocalGroupFlag(oStorer, SubraceStorage + "_" + APPEARANCE_CHANGE, shaSubraceApp.ChangeAppearanceTime, TIME_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + APPEARANCE_TO_CHANGE, shaSubraceApp.MaleAppearance, APPEARANCE_CHANGE_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + APPEARANCE_TO_CHANGE, shaSubraceApp.FemaleAppearance, APPEARANCE_CHANGE_FEMALE_FLAG);
}

void AddAdditionalSkinsToSubrace(string subrace, string SkinResRef, int EquipLevel, int iTime = TIME_BOTH)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_SKIN + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), GetStringLowerCase( SkinResRef ) );
}

void AddClawsToSubrace(string subrace, string RightClawResRef, string LeftClawResRef , int EquipLevel, int iTime = TIME_BOTH)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    if(RightClawResRef != "")
    {
        SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), RightClawResRef);
    }
    if(LeftClawResRef != "")
    {
        SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), LeftClawResRef);
    }
}
void AddSubraceItem(string subrace, string ItemResRef, int Level = 1)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    int SubraceUniqueItemCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_UNIQUEITEM_COUNT);
    SubraceUniqueItemCount++;
    SetSSEInt( SubraceStorage + "_" + SUBRACE_UNIQUEITEM_COUNT, SubraceUniqueItemCount);
    SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(SubraceUniqueItemCount), GetStringLowerCase( ItemResRef ) + "_" + IntToString(Level));
}

//LETO STUFF
struct SubraceBaseStatsModifier CustomBaseStatsModifiers(int StrengthModifier, int DexterityModifier, int ConstitutionModifier, int IntelligenceModifier, int WisdomModifier, int CharismaModifier, int MovementSpeedModifier)
{
  struct SubraceBaseStatsModifier Stats;
  Stats.StrengthModifier = StrengthModifier;
  Stats.DexterityModifier = DexterityModifier;
  Stats.ConstitutionModifier = ConstitutionModifier;
  Stats.IntelligenceModifier  =  IntelligenceModifier;
  Stats.WisdomModifier =  WisdomModifier;
  Stats.CharismaModifier =  CharismaModifier;
  Stats.SpdModifier =  MovementSpeedModifier;
  return Stats;
}

void CreateBaseStatModifier(string subrace, struct SubraceBaseStatsModifier Stats, int Level = 1, int Set = FALSE){
    string SubraceStorage = GetSubraceStorageLocation(subrace);

    int StrengthModifier = Stats.StrengthModifier;
    int DexterityModifier = Stats.DexterityModifier;
    int ConstitutionModifier = Stats.ConstitutionModifier;
    int IntelligenceModifier = Stats.IntelligenceModifier;
    int WisdomModifier = Stats.WisdomModifier;
    int CharismaModifier = Stats.CharismaModifier;
    int SpdModifier = Stats.SpdModifier;

    SubraceStorage = SubraceStorage + "_" + IntToString(Level);
    SetSSEInt( SubraceStorage + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS, TRUE);
    if(Set){
        SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE, Set);
    }
    if(StrengthModifier)     SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_STR_MODIFIER, StrengthModifier);
    if(DexterityModifier)    SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER, DexterityModifier);
    if(ConstitutionModifier) SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_CON_MODIFIER, ConstitutionModifier);
    if(WisdomModifier)       SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER, WisdomModifier);
    if(IntelligenceModifier) SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_INT_MODIFIER, IntelligenceModifier);
    if(CharismaModifier)     SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER, CharismaModifier);
    if(SpdModifier)          SetSSEInt( SubraceStorage + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER, SpdModifier);
}

void ModifySubraceFaction(string subrace, string FactionCreatureTag, int Reputation = SUBRACE_FACTION_REPUTATION_HOSTILE)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    int Count =  GetSSEInt( SubraceStorage + "_" + SUBRACE_FACTION_COUNT);
    Count++;
    SetSSEInt( SubraceStorage + "_" + SUBRACE_FACTION_COUNT, Count);
    SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count), FactionCreatureTag);
    SetSSEInt( SubraceStorage + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count), Reputation);
}

void CreateSubraceStartLocation(string subrace, string WaypointTag)
{
    string SubraceStorage = GetSubraceStorageLocation(subrace);
    SetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_START_LOCATION, WaypointTag);
}

void ModifySubraceAppearanceAttachment(string subrace, int Male_Wings = 0, int Female_Wings = 0, int Male_Tail = 0, int Female_Tail = 0, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_ATTACHMENT_FLAGS, Male_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_ATTACHMENT_FLAGS, Female_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS_FEMALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_ATTACHMENT_FLAGS2, Male_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_ATTACHMENT_FLAGS2, Female_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL_FEMALE);
}

void ModifySubraceFeat(string subrace, int FeatID, int Level = 1, int Remove = FALSE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
   int FeatCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_BONUS_FEAT_COUNT);
   FeatCount++;
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, FeatID, SUBRACE_BONUS_FEAT_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, Remove, SUBRACE_BONUS_FEAT_REMOVE_FLAG);
   SetSSEInt( SubraceStorage + "_" + SUBRACE_BONUS_FEAT_COUNT, FeatCount);
}

void ChangePortrait(string subrace, string MalePortrait, string FemalePortrait, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SetLocalString(oStorer, SubraceStorage + "_" + IntToString(Level)+ "_" + SUBRACE_PORTRAIT_MALE, MalePortrait);
   SetLocalString(oStorer, SubraceStorage + "_" + IntToString(Level)+ "_" + SUBRACE_PORTRAIT_FEMALE , FemalePortrait);
}

void ChangeSoundSet(string subrace, int MaleSoundSet, int FemaleSoundSet, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(Level)+ "_" + SUBRACE_SOUNDSET_FLAGS, MaleSoundSet, SUBRACE_SOUNDSET_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(Level)+ "_" + SUBRACE_SOUNDSET_FLAGS, FemaleSoundSet, SUBRACE_SOUNDSET_FEMALE_FLAG);
}

void ModifySubraceSkill(string subrace, int SkillID, int iModifier, int Level = 1, int Set = FALSE)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
   int SkillCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_BONUS_SKILL_COUNT);
   SkillCount++;
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SkillID, SUBRACE_BONUS_SKILL_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, Set, SUBRACE_BONUS_SKILL_REMOVE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, iModifier, SUBRACE_BONUS_SKILL_MODIFIER_FLAG);
   SetSSEInt( SubraceStorage + "_" + SUBRACE_BONUS_SKILL_COUNT, SkillCount);
}


void ModifySubraceAppearanceColors(string subrace, int Male_Hair = -1, int Female_Hair = -1, int Male_Skin = -1, int Female_Skin = -1, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
//3.0.6.6 negative value omissions fixed
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_COLORS_FLAGS, Male_Hair, SUBRACE_COLORS_FLAGS_HAIR_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_COLORS_FLAGS, Female_Hair, SUBRACE_COLORS_FLAGS_HAIR_FEMALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_COLORS_FLAGS, Male_Skin, SUBRACE_COLORS_FLAGS_SKIN_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_COLORS_FLAGS, Female_Skin, SUBRACE_COLORS_FLAGS_SKIN_FEMALE);
}

// 3.0.6.9
void ModifySubraceHead(string subrace, int Male_Head = -1, int Female_Head = -1, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_HEAD_FLAGS, Male_Head, SUBRACE_HEAD_FLAGS_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_HEAD_FLAGS, Female_Head, SUBRACE_HEAD_FLAGS_FEMALE);
}

// 3.0.6.6
void ModifySubraceEyeColors(string subrace, int Male_Eyes = -1, int Female_Eyes = -1, int Level = 1)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   SubraceStorage = SubraceStorage + "_" + IntToString(Level);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EYE_COLORS_FLAGS, Male_Eyes, SUBRACE_EYE_COLORS_FLAGS_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EYE_COLORS_FLAGS, Female_Eyes, SUBRACE_EYE_COLORS_FLAGS_FEMALE);
}

void DelayBoot(object oPC)
{
   if(GetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG"))
   {
      BootPC(oPC);
   }
}

void SetIsInDarkness(object oPC, int Flag)
{
  int ID = GetPlayerSubraceID(oPC);
  if(!ID) { return; }
  string SubraceStorage = GetSubraceStorageLocationByID(ID);
  int IsLightSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
  int DmgTakenL = GetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_LIGHT);
  if(IsLightSens || DmgTakenL)
  {
     SetLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS, Flag);
  }
}

int Subrace_GetIsInDarkness(object oPC)
{
   return GetLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
}

void ApplyLightSensitivity(object oPC){
  if(SPELL_DARKNESS_STOPS_LIGHT_SENSITIVITY && Subrace_GetIsInDarkness(oPC)){
      return;
  }

  if(APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT && !GetLocalInt(oPC, "STRUCK_LIGHT_DEC"))
  {
      effect ABDecrease =  EffectAttackDecrease(2);
      effect ACDecrease = EffectACDecrease(4);
      effect Link = EffectLinkEffects(ABDecrease, ACDecrease);
      Link = SupernaturalEffect(Link);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, Link, oPC, RoundsToSeconds(LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS + 1));
      SetLocalInt(oPC, "STRUCK_LIGHT_DEC", TRUE);
      DelayCommand(RoundsToSeconds(LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS), SetLocalInt(oPC, "STRUCK_LIGHT_DEC", FALSE));
   }
}

int GetIsPCLightSensitive(object oPC)
{
   string SubraceStorage = GetSubraceStorageLocationByID(GetPlayerSubraceID(oPC));
   return GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
}

void ApplyUndergroundSensitivity(object oPC)
{
  if(!GetLocalInt(oPC, "STRUCK_BLIND_UND"))
  {
       if(FortitudeSave(oPC, DARK_SENSITIVE_SAVING_THROW_DC) == 0)
       {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, DARK_STRUCK_BLIND_FOR_ROUNDS*6.0);
       }
       SetLocalInt(oPC, "STRUCK_BLIND_UND", TRUE);
       DelayCommand(RoundsToSeconds(DARK_BLINDNESS_STRIKES_EVERY_ROUND), SetLocalInt(oPC, "STRUCK_BLIND_UND", FALSE));
  }
}

void SubraceSpontaneouslyCombust(object oPC)
{
   if(ReflexSave(oPC, SUBRACE_SPONTANEOUSLY_COMBUST_DC) )
   {  return; }
   effect FireDmg  = EffectDamage(d8(), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
   effect VisEffect = EffectVisualEffect(VFX_IMP_FLAME_S);
   effect iLink = EffectLinkEffects(FireDmg, VisEffect);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, iLink, oPC, 6.0);

}

void ApplyDamageWhileInLight(object oPC, int DmgTaken)
{
  if(SPELL_DARKNESS_STOPS_LIGHT_SENSITIVITY && Subrace_GetIsInDarkness(oPC))
  {
      return;
  }
  if(!GetLocalInt(oPC, "SB_LGHT_DMGED"))
  {
    SetLocalInt(oPC, "SB_LGHT_DMGED", TRUE);
    effect LightDamage;
    if(DmgTaken > 0)
    {
        LightDamage = EffectDamage(DmgTaken, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
    }
    else if(DmgTaken < 0)
    {
       DmgTaken = abs(DmgTaken);
       LightDamage = EffectRegenerate(DmgTaken, 1.0);
    }
    if(SUBRACE_SPONTANEOUS_COMBUSTION_WHILE_IN_LIGHT)
    {
        if(d100() <= SUBRACE_SPONTANEOUS_COMBUSTION_PERCENTAGE)
        {
          int i = 0;
          //Combust visual effect.
          effect eDur = EffectVisualEffect(498);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds(LIGHT_DAMAGES_EVERY_ROUNDS));

          while(i != LIGHT_DAMAGES_EVERY_ROUNDS)
          {
             DelayCommand(RoundsToSeconds(i), SubraceSpontaneouslyCombust(oPC));
             i++;
          }
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, LightDamage, oPC, 1.0);
    DelayCommand(RoundsToSeconds(LIGHT_DAMAGES_EVERY_ROUNDS), SetLocalInt(oPC,"SB_LGHT_DMGED", FALSE));
  }
}

int GetSubraceID(string subrace)
{
    return GetSSEInt( SUBRACE_TAG + "_" + GetStringLowerCase(subrace));
}

void SetSubraceID(string subrace, int Value)
{
    SetSSEInt( SUBRACE_TAG + "_" + GetStringLowerCase(subrace), Value);
}

string GetSubraceStorageLocationByID(int SubraceID)
{
    return SUBRACE_TAG + "_ID_" + IntToHexString(SubraceID);
}

string GetSubraceStorageLocation(string subrace)
{
    return GetSubraceStorageLocationByID(GetSubraceID(subrace));
}

void ApplyDamageWhileInDark(object oPC, int DmgTaken)
{
  if(!GetLocalInt(oPC, "SB_DARK_DMGED"))
  {
   SetLocalInt(oPC, "SB_DARK_DMGED", TRUE);
   effect DarkDamage;
   if(DmgTaken > 0)
   {
       DarkDamage = EffectDamage(DmgTaken, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY);
   }
   else if(DmgTaken < 0)
   {
       DmgTaken = abs(DmgTaken);
       DarkDamage = EffectRegenerate(DmgTaken, 1.0);
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, DarkDamage, oPC, 1.0);
   DelayCommand(RoundsToSeconds(DARKNESS_DAMAGES_EVERY_ROUNDS), SetLocalInt(oPC,"SB_DARK_DMGED", FALSE));
  }
}

string FlagNumberToErrorMSG(int iError)
{
    string sReturn = "";
    if(iError & SUBRACE_ERROR_UNRECOGNISED)
    {
       //Exploiting the fact that "unrecognised subrace" never gets any other "errors"
       /*sReturn +=*/return "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_UNRECOGNISED);
    }
    if(iError & SUBRACE_ERROR_ALIGNMENT)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_CRITERIA_ALIGNMENT_FAILED);
    }
    if(iError & SUBRACE_ERROR_RACE)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_CRITERIA_BASE_RACE_FAILED);
    }
    if(iError & SUBRACE_ERROR_CLASS)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_CRITERIA_CLASS_FAILED);
    }
    if(iError & SUBRACE_ERROR_PRESTIGE_FAILURE)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_FAILED_TO_MEET_PRESTIGIOUS_CLASS_RESTRICTION);
    }
    if(iError & SUBRACE_ERROR_PRESTIGE_NOT_MET)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_CANNOT_BE_PART_OF_PRESTIGIOUS_SUBRACE);
    }
    if(iError & SUBRACE_ERROR_GENDER)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_GENDER_FAILED);
    }
    if(iError & SUBRACE_ERROR_SPECIAL_RESTRICTION)
    {
        sReturn += "\n-" + SSE_GetStandardMessage(MESSAGE_SUBRACE_CRITERIA_SPECIAL_RESTRICTION_FAILED);
    }
    return sReturn;
}

//3.0.6.7
int PrestigeClassToFlags(int Class)
{
int Flag = 0;
   switch(Class)
   {
      case CLASS_TYPE_ARCANE_ARCHER:
        Flag = FLAG2;
        break;
      case CLASS_TYPE_ASSASSIN:
        Flag = FLAG3;
        break;
      case CLASS_TYPE_BLACKGUARD:
        Flag = FLAG4;
        break;
      case CLASS_TYPE_DIVINE_CHAMPION:
        Flag = FLAG5;
        break;
      case CLASS_TYPE_DRAGON_DISCIPLE:
        Flag = FLAG6;
        break;
      case CLASS_TYPE_DWARVEN_DEFENDER:
        Flag = FLAG7;
        break;
      case CLASS_TYPE_HARPER:
        Flag = FLAG8;
        break;
      case CLASS_TYPE_PALE_MASTER:
        Flag = FLAG9;
        break;
      case CLASS_TYPE_SHADOWDANCER:
        Flag = FLAG10;
        break;
      case CLASS_TYPE_SHIFTER:
        Flag = FLAG11;
        break;
      case CLASS_TYPE_WEAPON_MASTER:
        Flag = FLAG12;
        break;
      case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
        Flag = FLAG13;
        break;
   }
return Flag;
}

int RacialTypeToFlags(int Race)
{
int Flag = 0;
   switch(Race)
   {
      case RACIAL_TYPE_DWARF:
        Flag = FLAG1;
        break;
      case RACIAL_TYPE_ELF:
        Flag = FLAG2;
        break;
      case RACIAL_TYPE_GNOME:
        Flag = FLAG3;
        break;
      case RACIAL_TYPE_HALFELF:
        Flag = FLAG4;
        break;
      case RACIAL_TYPE_HALFLING:
        Flag = FLAG5;
        break;
      case RACIAL_TYPE_HALFORC:
        Flag = FLAG6;
        break;
      case RACIAL_TYPE_HUMAN:
        Flag = FLAG7;
        break;
      case RACIAL_TYPE_ALL:
        Flag = FLAG8;
        break;
   }
return Flag;
}

int CheckIfPCMeetsBaseRaceCriteria(object oPC, string SubraceStorage)
{
    int PCRace = GetRacialType(oPC);
    int iResult = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_BASE_RACE, SUBRACE_BASE_RACE_FLAGS);
    return (iResult)?(iResult & RacialTypeToFlags(PCRace)):TRUE;
}

int CheckIfPCMeetsSpecialCriteria(object oPC, string SubraceStorage)
{
  SubraceStorage = SubraceStorage +"_"+SUBRACE_SPECIAL_RESTRICTION;
  int Count = GetSSEInt( SubraceStorage);
  string Test;
  int i=1;
  int Type, TestValue;
  string Varname, Database;
  int ReturnValue=TRUE;
  for( ; (i<=Count) && ReturnValue ; i++)
    {
        Test=SubraceStorage+IntToString(i);
        Type=GetSSEInt( Test);
        Varname=GetLocalString(oStorer, Test + SUBRACE_SPECIAL_RESTRICTION_VARNAME);
        Database=GetLocalString(oStorer, Test + SUBRACE_SPECIAL_RESTRICTION_DATABASE);
        switch(Type&SUBRACE_SPECIAL_RESTRICTION_TYPE_ALL)
        {
            case SUBRACE_SPECIAL_RESTRICTION_TYPE_DATABASE:
                if(Database=="") Database=SUBRACE_DATABASE;
                    TestValue=GetDbInt(oPC, Varname, FALSE);
                break;
            case SUBRACE_SPECIAL_RESTRICTION_TYPE_ITEM:
                TestValue=GetIsObjectValid(GetItemPossessedBy(oPC, Varname));
                break;
            case SUBRACE_SPECIAL_RESTRICTION_TYPE_LOCAL_VAR:
            {
                object Temp;
                if(Database!="")
                {
                    Temp = GetItemPossessedBy(oPC, Database);
                    if(!GetIsObjectValid(Temp))
                    {
                        Temp=GetObjectByTag(Database);
                        if(!GetIsObjectValid(Temp))
                        {
                            Temp=oPC;
                        }
                    }
                }
                else Temp=oPC;
                TestValue=GetLocalInt(Temp, Varname);
                break;
            }
        }
        ReturnValue=( ((Type&1) && TestValue) || (!(Type&1) && !TestValue)  );
    }
    return ReturnValue;
}

int CheckIfPCMeetsGenderCriteria(object oPC, string SubraceStorage)
{
   int iFlag = GetSSEInt( SubraceStorage + "_" + SUBRACE_GENDER_RES);
   int PCGender = GetGender(oPC);
   switch(PCGender)
   {
        case GENDER_MALE: PCGender = FLAG2; break;
        case GENDER_FEMALE: PCGender = FLAG1; break;
        default: break;
   }
   return !(iFlag & PCGender);
}
int CheckIfPCMeetsClassCriteria(object oPC, string SubraceStorage)
{
   int PCClass = GetClassByPosition(1, oPC);
   int canBeBarbarian = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG2);
   int canBeBard = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG3);
   int canBeCleric = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG4);
   int canBeDruid = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG5);
   int canBeFighter = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG6);
   int canBeMonk =   GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG7);
   int canBePaladin = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG8);
   int canBeRanger = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG9);
   int canBeRogue =  GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG10);
   int canBeSorcerer = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG11);
   int canBeWizard =   GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG12);
   //longest return ever!
   return ((PCClass == CLASS_TYPE_BARBARIAN && canBeBarbarian) || (PCClass == CLASS_TYPE_BARD && canBeBard) || (PCClass == CLASS_TYPE_CLERIC && canBeCleric) || (PCClass == CLASS_TYPE_DRUID && canBeDruid) || (PCClass == CLASS_TYPE_FIGHTER && canBeFighter) || (PCClass == CLASS_TYPE_MONK && canBeMonk) || (PCClass == CLASS_TYPE_PALADIN && canBePaladin) || (PCClass == CLASS_TYPE_RANGER && canBeRanger) || (PCClass == CLASS_TYPE_ROGUE && canBeRogue) || (PCClass == CLASS_TYPE_SORCERER && canBeSorcerer) || (PCClass == CLASS_TYPE_WIZARD && canBeWizard));
}

int CheckIfPCMeetsPrestigiousClassCriteria(object oPC, string SubraceStorage)
{

   int MinLevel = GetSSEInt( SubraceStorage + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION_MINIMUM_LEVELS);
   int iClassType = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION,
                    MEDIUMGROUP1|TINYGROUP3);
   int i=2;
   int iMatch;
   for( ; i < 4; i++)
   {
        iMatch = PrestigeClassToFlags(GetClassByPosition(i, oPC) );
        if(iMatch & iClassType)
        {
            MinLevel -= GetLevelByPosition(i, oPC);
        }
    }
   //Returns TRUE if MinLevel is less than or equal to 0 (we have the exact or more levels than req.)
   return (MinLevel<1);
}

int CheckIfPCMeetsAlignmentCriteria(object oPC, string SubraceStorage)
{
    int PCAlign1 = GetAlignmentGoodEvil(oPC);
    int PCAlign2 = GetAlignmentLawChaos(oPC);
    int align1 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG2);
    int align2 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG3);
    int align3 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG4);
    int align4 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG5);
    int align5 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG6);
    int align6 = GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG7);
    return ((PCAlign1 == ALIGNMENT_GOOD && align1) || (PCAlign1 == ALIGNMENT_NEUTRAL && align2) || (PCAlign1 == ALIGNMENT_EVIL && align3))
    &&
    ((PCAlign2 == ALIGNMENT_LAWFUL && align4) || (PCAlign2 == ALIGNMENT_NEUTRAL && align5) || (PCAlign2 == ALIGNMENT_CHAOTIC && align6));
}

int CheckIfPCGetsAnyErrorsWithSubraceTest(object oPC, int ID)
{
   int Error=0;
   string SubraceStorage;
   //Check if the subrace exists.
   if(ID)
   {
   SubraceStorage = GetSubraceStorageLocationByID(ID);
      int IsPrestigious = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE, SUBRACE_BASE_INFORMATION_FLAGS);
      if(IsPrestigious && GetPlayerLevel(oPC) == 1)
      {
         Error |= SUBRACE_ERROR_PRESTIGE_FAILURE;
      }
      else if(IsPrestigious)
      {
          //What (if any) is the Class Restriction
          if(GetSSEInt( SubraceStorage + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION))
          {
             if(!CheckIfPCMeetsPrestigiousClassCriteria(oPC, SubraceStorage))
             {
                 Error |=SUBRACE_ERROR_PRESTIGE_NOT_MET;
             }
          }
      }
      //Check if we meet Race Req.
      if(!CheckIfPCMeetsBaseRaceCriteria(oPC, SubraceStorage))
      {
        Error |= SUBRACE_ERROR_RACE;
      }

      if(GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG1))
      {
      //Check if we meet Alignments Req.
          if(!CheckIfPCMeetsAlignmentCriteria(oPC, SubraceStorage))
          {
              Error |= SUBRACE_ERROR_ALIGNMENT;
          }
      }
      if(GetLocalFlag(oStorer, SubraceStorage + "_" + SUBRACE_CLASS_RESTRICTION, FLAG1))
      {
      //Check if we meet Class Req.
          if(!CheckIfPCMeetsClassCriteria(oPC,SubraceStorage))
          {
              Error |=SUBRACE_ERROR_CLASS;
          }
      }
      if(GetSSEInt( SubraceStorage + "_" + SUBRACE_GENDER_RES) > 0)
      {
          if(!CheckIfPCMeetsGenderCriteria(oPC, SubraceStorage))
          {
              Error |= SUBRACE_ERROR_GENDER;
          }
      }
      if(!CheckIfPCMeetsSpecialCriteria(oPC, SubraceStorage))
        {
            Error |= SUBRACE_ERROR_SPECIAL_RESTRICTION;
        }
   }  //FAILED TO FIND ANY SUCH SUBRACE
   else { Error = SUBRACE_ERROR_UNRECOGNISED; }

return Error;
}

int CheckIfPCMeetsAnySubraceCriteria(object oPC)
{
   string subrace = GetSubRace(oPC);
   int ID = GetSubraceID(subrace);
   int Error = CheckIfPCGetsAnyErrorsWithSubraceTest(oPC, ID);
   int i=1;
   string sErrorMessage;
   if((Error & SUBRACE_ERROR_UNRECOGNISED))
   {
       SSE_MessageHandler(oPC, MESSAGE_SUBRACE_UNRECOGNISED, subrace);
       return SUBRACE_UNRECOGNISED;
   }
   else if(Error > 0)
   {
       string sMsg = FlagNumberToErrorMSG(Error);
       SSE_MessageHandler(oPC, MESSAGE_SUBRACE_CRITERIA_FAILED, sMsg);
       SetSubRace(oPC, "");
       SSE_MessageHandler(oPC, MESSAGE_SUBRACE_FAILED_CRITERIA_SO_REMOVED);
   }
   else SSE_MessageHandler(oPC, MESSAGE_SUBRACE_CRITERIA_MET);
   return !(Error > 0);
}


string GetTemporarySubraceSkin(object oPC, string SubraceStorage, int iTime)
{
   int Level = GetPlayerLevel(oPC);
   string SkinResRef;
   while(Level > 0)
   {
      string resref = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(iTime));
      if(resref != "")
      {
        SkinResRef = resref;
        break;
      }
      Level--;
   }
   return SkinResRef;
}

//::****************************************************************
// 1.69 -- Returns TRUE if oSkin is valid and has the Horse Menu Feat on it. Returns FALSE otherwise.
int GetSkinHasHorseMenu( object oSkin)
{ if( !GetIsObjectValid( oSkin)) return FALSE;

  itemproperty ipHorseMenu = GetFirstItemProperty( oSkin);
  while( GetIsItemPropertyValid( ipHorseMenu))
  { if( (GetItemPropertyType( ipHorseMenu) == ITEM_PROPERTY_BONUS_FEAT) &&
        (GetItemPropertySubType( ipHorseMenu) == IP_CONST_HORSE_MENU_SSE))
      return TRUE;
    ipHorseMenu = GetNextItemProperty( oSkin);
  }
  return FALSE;
}
//::****************************************************************

void EquipTemporarySubraceSkin(string SubraceStorage, object oPC, int iTime)
{
   string sSkin = GetTemporarySubraceSkin(oPC, SubraceStorage, iTime);
   if(sSkin == "")
   {
       sSkin = GetTemporarySubraceSkin(oPC, SubraceStorage, TIME_BOTH);
   }
   object ExistingSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
   string ResrefExistingSkin = GetResRef(ExistingSkin);
   if(ResrefExistingSkin != sSkin)
   {
       object NewSkin = CreateItemOnObject(sSkin, oPC);

       //::****************************************************************
       // 1.69 -- Add horse menu to new skin if needed
       if( (GetIsPC( oPC) || GetIsDM( oPC)) && !GetSkinHasHorseMenu( NewSkin) &&
           ((!GetIsObjectValid( ExistingSkin) && !GetHasFeat( FEAT_HORSE_MENU, oPC)) ||
            GetSkinHasHorseMenu( ExistingSkin)) )
       { itemproperty iProp = ItemPropertyBonusFeat( IP_CONST_HORSE_MENU_SSE);
         AddItemProperty( DURATION_TYPE_PERMANENT, iProp, NewSkin);
       }
       //::****************************************************************

       if(GetIsObjectValid(ExistingSkin))
       {
           SetPlotFlag(ExistingSkin, FALSE);
           DestroyObject(ExistingSkin, 0.2);
       }
       SetIdentified(NewSkin, TRUE);
       DelayCommand(1.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewSkin, INVENTORY_SLOT_CARMOUR)));
   }
}

string GetTemporarySubraceClaw(object oPC, string SubraceStorage, string Claw, int iTime)
{
   int Level = GetPlayerLevel(oPC);
   string ClawResRef = "";
   while(Level > 0)
   {
      string resref = GetLocalString(oStorer, SubraceStorage + "_" + Claw + "_" + IntToString(Level) + "_" + IntToString(iTime));
      if(resref != "")
      {
        ClawResRef = resref;
        break;
      }
      Level--;
   }
   return ClawResRef;
}


void EquipTemporarySubraceClaw(string SubraceStorage, object oPC, int iTime)
{
   string sLeftClaw = GetTemporarySubraceClaw(oPC, SubraceStorage, SUBRACE_LEFT_CLAW, iTime);
   string sRightClaw = GetTemporarySubraceClaw(oPC, SubraceStorage, SUBRACE_RIGHT_CLAW, iTime);

   if(sLeftClaw == "")
   {
       sLeftClaw = GetTemporarySubraceClaw(oPC, SubraceStorage, SUBRACE_LEFT_CLAW, TIME_BOTH);
   }
   if(sRightClaw == "")
   {
       sRightClaw = GetTemporarySubraceClaw(oPC, SubraceStorage, SUBRACE_RIGHT_CLAW, TIME_BOTH);
   }
   object ExistingLeftClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
   object ExistingRightClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
   string ResrefExistingLClaw = GetStringLowerCase(GetResRef(ExistingLeftClaw));
   string ResrefExistingRClaw = GetStringLowerCase(GetResRef(ExistingRightClaw));
   if((ResrefExistingRClaw != sRightClaw) || (ResrefExistingLClaw != sLeftClaw))
   {
         SSE_MessageHandler(oPC, MESSAGE_SUBRACE_CLAWS_WAIT_FOR_CLAWS_EQUIPPING);
         if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
         {
            SSE_MessageHandler(oPC, MESSAGE_SUBRACE_CLAWS_MISSING_CREATURE_WEAPON_PROFICIENCY);
            return;
         }
         DelayCommand(9.0, SSE_MessageHandler(oPC,MESSAGE_SUBRACE_CLAWS_SUCCESSFULLY_EQUIPPED));
    }
    if(ResrefExistingRClaw != sRightClaw)
    {
           object NewRClaw = CreateItemOnObject(sRightClaw, oPC);
           if(sRightClaw == "none" || GetIsObjectValid(ExistingRightClaw))
           {
               SetPlotFlag(ExistingRightClaw, FALSE);
               DestroyObject(ExistingRightClaw, 0.2);
           }
           SetIdentified(NewRClaw, TRUE);
           DelayCommand(1.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewRClaw, INVENTORY_SLOT_CWEAPON_R)));
     }
     if(ResrefExistingLClaw != sLeftClaw)
     {
           object NewLClaw = CreateItemOnObject(sLeftClaw, oPC);
           if(sLeftClaw == "none"  || GetIsObjectValid(ExistingLeftClaw))
           {
               SetPlotFlag(ExistingLeftClaw, FALSE);
               DestroyObject(ExistingLeftClaw, 0.3);
           }
           SetIdentified(NewLClaw, TRUE);
           DelayCommand(5.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewLClaw, INVENTORY_SLOT_CWEAPON_L)));
     }
}

void SearchAndDestroySkinsAndClaws(object oPC)
{
   object oItem = GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem))
   {
       int iType = GetBaseItemType(oItem);
       if(iType == BASE_ITEM_CREATUREITEM || iType == BASE_ITEM_CPIERCWEAPON || iType == BASE_ITEM_CSLASHWEAPON || iType == BASE_ITEM_CSLSHPRCWEAP)
       {
          SetPlotFlag(oItem, FALSE);
          DestroyObject(oItem, 0.1);
       }
       oItem = GetNextItemInInventory(oPC);
   }


}

void GiveSubraceUniqueItem(string SubraceStorage, object oPC)
{
    int i = 0;
    int iLevel = GetHitDice(oPC);
    int iChk = GetDbInt(oPC, SubraceStorage + "_" + SUBRACE_UNIQUEITEM, FALSE);
    if(iChk > iLevel)
    { return; }
    i = iChk;
    int SubraceUniqueItemCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_UNIQUEITEM_COUNT);
    //SendMessageToPC(oPC, "DEBUG : Subrace Unique Item Count" + IntToString(SubraceUniqueItemCount));
    while(i <= SubraceUniqueItemCount)
    {
       i++;
       string resref = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(i));
       //SendMessageToPC(oPC, "DEBUG : Attepmting to create item with resref: " + resref);
       if(resref != "")
       {
           string sLevel = GetStringRight(resref, 2);
           if(GetStringLeft(sLevel, 1) == "_")
           {
              //resref: itemref_1
              sLevel = GetStringRight(sLevel, 1);
              resref = GetStringLeft(resref, GetStringLength(resref) - 2);
           }
           else
           {
              //resref: itemref_12
              resref = GetStringLeft(resref, GetStringLength(resref) - 3);
           }
           int iLvl = StringToInt(sLevel);
           if(iLvl == iLevel)
           {
              object oItem = CreateItemOnObject(resref, oPC);
              //SendMessageToPC(oPC, "DEBUG : Attepmting to create item with resref: " + resref);
              DelayCommand(1.0, SSE_MessageHandler(oPC, MESSAGE_SUBRACE_ACQUIRED_UNIQUE_ITEM, GetName(oItem)));
              SetDbInt(oPC, SubraceStorage + "_" + SUBRACE_UNIQUEITEM, iLevel, 0, FALSE);
              SetIdentified(oItem, TRUE);
              SetPlotFlag(oItem, TRUE);
              SetItemCursedFlag(oItem, TRUE);
           }
      }
    }
}

void CheckAndGiveSubraceItems(object oPC){
    string SubraceStorage = GetSubraceStorageLocation(GetSubRace(oPC));
    GiveSubraceUniqueItem(SubraceStorage, oPC);
}

int SHA_GetDefaultAppearanceType(object oPC)
{
   int iRace = GetRacialType(oPC);
   int DefaultAppearance;
   switch(iRace)
   {
      case RACIAL_TYPE_DWARF: DefaultAppearance = APPEARANCE_TYPE_DWARF; break;
      case RACIAL_TYPE_ELF: DefaultAppearance = APPEARANCE_TYPE_ELF; break;
      case RACIAL_TYPE_GNOME: DefaultAppearance = APPEARANCE_TYPE_GNOME;  break;
      case RACIAL_TYPE_HALFELF: DefaultAppearance = APPEARANCE_TYPE_HALF_ELF;  break;
      case RACIAL_TYPE_HALFLING: DefaultAppearance = APPEARANCE_TYPE_HALFLING; break;
      case RACIAL_TYPE_HALFORC: DefaultAppearance = APPEARANCE_TYPE_HALF_ORC;  break;
      case RACIAL_TYPE_HUMAN: DefaultAppearance = APPEARANCE_TYPE_HUMAN;  break;
      default: DefaultAppearance = APPEARANCE_TYPE_HUMAN;  break;
   }
   return DefaultAppearance;
}

int Subrace_GetFavouredClass(object oPC)
{
   return GetLocalInt(oPC, SUBRACE_FAVORED_CLASS) - 1;
}

int GetRacialFavoredClass(int Race)
{
    int Class = CLASS_TYPE_NONE;
    switch(Race)
    {
       case RACIAL_TYPE_DWARF: Class = CLASS_TYPE_FIGHTER; break;
       case RACIAL_TYPE_HUMAN: Class = CLASS_TYPE_ANY; break;
       case RACIAL_TYPE_ELF: Class = CLASS_TYPE_WIZARD; break;
       case RACIAL_TYPE_GNOME: Class = CLASS_TYPE_WIZARD; break;
       case RACIAL_TYPE_HALFELF: Class = CLASS_TYPE_ANY; break;
       case RACIAL_TYPE_HALFORC: Class = CLASS_TYPE_BARBARIAN; break;
       case RACIAL_TYPE_HALFLING: Class = CLASS_TYPE_ROGUE; break;
   }
   return Class;
}

void LoadSubraceFromScript(string Script, int Conditions=SSE_SUBRACE_LOADER_CONDITION_ALWAYS_LOAD)
{
    int Load=TRUE, Timer=0;
/*
    switch(Conditions)
    {
        case SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO:
            Load=ENABLE_LETO;
            break;
        case SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_NOT_USING_LETO:
            Load=(!ENABLE_LETO);
            break;
        default:
            Load=TRUE;
            break;
    }
*/
    if(Load)
    {
        Timer = GetSSEInt( SSE_SUBRACE_LOADER_AMOUNT);
        Timer++;
        SetSSEInt( SSE_SUBRACE_LOADER_AMOUNT, Timer);
        //A flat 0.0 delay will make the Sub-race script a separate instance.
        //But I suppose it never hurt anyone giving the module a little time...
        //10ms per script should do for any decent CPU.
        DelayCommand(Timer/100.0, ExecuteScript(Script, oStorer));
    }
}

void SetSSEInt(string VariableName, int Value)
{
    SetLocalInt(oStorer, VariableName, Value);
}

int GetSSEInt(string VariableName)
{
    return GetLocalInt(oStorer, VariableName);
}

void DeleteSSEInt(string VariableName)
{
    DeleteLocalInt(oStorer, VariableName);
}

void SSE_ModuleLoadEvent(int doNWNXInit=FALSE)
{
    /*
    if(doNWNXInit)
    {
        //Just do this instantly, other external processes may be depent of each.
        SetLocalString(oStorer, "NWNX!INIT", "1");
    }
    */
    int Scripts=GetSSEInt(SSE_SUBRACE_LOADER_AMOUNT);
    int Subraces=GetSSEInt( MODULE_SUBRACE_COUNT);
    int Delays=GetSSEInt(SSE_SUBRACE_LOADER_AMOUNT_OF_DELAYS);
    //If no scripts or no subraces have been found, then this is probably triggered
    //before our subrace load scripts.
    if(!Scripts && !Subraces && Delays<4)
    {
        Delays++;
        SetSSEInt(SSE_SUBRACE_LOADER_AMOUNT_OF_DELAYS, Delays);
        DelayCommand(10.0, SSE_ModuleLoadEvent());
    }
    //if subraces / scripts have been found, give additional 5 seconds to load the
    //remaining files.
    else if(!(Delays&0x80000000) )
    {
        Delays|=0x80000000;
        DelayCommand(5.0, SSE_ModuleLoadEvent());
        SetSSEInt(SSE_SUBRACE_LOADER_AMOUNT_OF_DELAYS, Delays);
    }
    //Okay, all subraces should be loaded by now.
    else
    {
        //Calculate time we waited for subraces to load, since this was triggered.
        if(Delays&0x80000000)
        {
            Delays= ((( (Delays&(~0x80000000) ) )<<1) +1 )*5;
        }
        else
        {
            Delays*=10;
        }
        string Output = "*Subrace Engine: Module load completed" +
                    "\n - Loaded " + IntToString(Subraces) + " subraces." +
                    "\n - Scripts Executed: " + IntToString(Scripts) +
                    "\n - Waited " + IntToString(Delays) + " seconds.";
        if(SUBRACE_SPELLHOOKS!="")
        {
            //Use spellhooks
            SetModuleOverrideSpellscript(SUBRACE_SPELLHOOKS);
            Output +="\n - Spellhook: " + SUBRACE_SPELLHOOKS;
        }
        Output += "\n NWNX info:";
/*
        if(ENABLE_LETO)
        {
            Output += "\n - Leto Enabled - testing NWNX connection..."+
                  "\n - Leto is ";
            if(LetoPingPong())
            {
                Output += "replying.";
            }
            else
            {
                Output += "NOT working!";
            }
        }
        else
        {
            Output += "\n - Leto Disabled";
        }
*/
        Output += "\n - NWNX Database " +(ENABLE_NWNX_DATABASE?"enabled":"disabled")+ ".";
        SetSSEInt( SUBRACE_INFO_LOADED_ON_MODULE, TRUE);
        Output += "\nEnd of Module Load summery";
        WriteTimestampedLogEntry(Output);
        Output = "List of loaded sub-races loaded";
        int i=1;
        for( ; i<= Subraces ; i++)
        Output += "\n - " + GetSubraceNameByID(i);
        WriteTimestampedLogEntry(Output);
        DeleteSSEInt(SSE_SUBRACE_LOADER_AMOUNT);
        DeleteSSEInt(SSE_SUBRACE_LOADER_AMOUNT_OF_DELAYS);
    }
}

int GetFavoredClassExceedsGap(int Race1Favored, int Race2Favored, int Class1, int Class2, int Class3, int Class13Gap, int Class23Gap, int Class12Gap)
{
   //Has PC got Race 1 Favored class?
   int iR1Class1Favored = FALSE;
   int iR1Class2Favored = FALSE;
   int iR1Class3Favored = FALSE;

    //Has PC got  Race 2 Favored class?
   int iR2Class1Favored = FALSE;
   int iR2Class2Favored = FALSE;
   int iR2Class3Favored = FALSE;

   if(Race1Favored == Class1)
   {
      iR1Class1Favored = TRUE;
   }
   if(Race1Favored == Class2 && Class2 != CLASS_TYPE_INVALID)
   {
      iR1Class2Favored = TRUE;
   }
   if(Race1Favored == Class3 && Class3 != CLASS_TYPE_INVALID)
   {
      iR1Class3Favored = TRUE;
   }

   if(Race2Favored == Class1)
   {
      iR2Class1Favored = TRUE;
   }
   if(Race2Favored == Class2 && Class2 != CLASS_TYPE_INVALID)
   {
      iR2Class2Favored = TRUE;
   }
   if(Race2Favored == Class3 && Class3 != CLASS_TYPE_INVALID)
   {
      iR2Class3Favored = TRUE;
   }

   int Exceed12 = FALSE;
   int Exceed13 = FALSE;
   int Exceed23 = FALSE;

   int iResult12 = FALSE;
   int iResult13 = FALSE;
   int iResult23 = FALSE;

   if(abs(Class12Gap) >=2)
   {
      Exceed12 = TRUE;
   }
   else if(abs(Class13Gap) >=2)
   {
      Exceed13 = TRUE;
   }
   else if(abs(Class23Gap) >=2)
   {
      Exceed23 = TRUE;
   }

   if(Exceed12)
   {
      if(iR1Class1Favored || iR1Class2Favored)
      {
         iResult12 = TRUE;
         if((iR2Class1Favored && Class3 != CLASS_TYPE_INVALID) || (iR2Class2Favored && Class3 != CLASS_TYPE_INVALID))
         {
           iResult12 = FALSE;
         }
      }
   }
   if(Exceed13)
   {
      if(iR1Class1Favored || iR1Class3Favored)
      {
         iResult13 = TRUE;
         if(iR2Class1Favored ||iR2Class3Favored)
         {
           iResult13 = FALSE;
         }
      }
   }
   if(Exceed23)
   {
      if(iR1Class2Favored || iR1Class3Favored)
      {
         iResult23 = TRUE;
         if(iR2Class2Favored ||iR2Class3Favored)
         {
           iResult23 = FALSE;
         }
      }
   }

   return (iResult12 || iResult13 || iResult23);
}

int XPPenaltyOrBoostForSubrace(object oPC, int FClass)
{
   int iRace = GetRacialType(oPC);
   int iRFavored = GetRacialFavoredClass(iRace);

   int iSFavored = FClass;
   if(iSFavored == iRFavored)
   {
      return SUBRACE_XP_UNCHANGED;
   }

   int Class1 = GetClassByPosition(1, oPC);
   int Class2 = GetClassByPosition(2, oPC);
   int Class3 = GetClassByPosition(3, oPC);

   int Class1Level = GetLevelByClass(Class1, oPC);
   int Class2Level = GetLevelByClass(Class2, oPC);
   int Class3Level = GetLevelByClass(Class3, oPC);

   if(iRFavored == CLASS_TYPE_ANY)
   {
       int Max1 = Max(Class1Level, Class2Level);
       int Max2 = Max(Max1, Class3Level);

       if(Max2 == Class1Level)
       {
         iRFavored = Class1;
       }
       else if(Max2 == Class2Level)
       {
          iRFavored = Class2;
       }
       else if(Max2 == Class3Level)
       {
         iRFavored = Class3;
       }
   }

   if(iSFavored == CLASS_TYPE_ANY)
   {
       int Max1 = Max(Class1Level, Class2Level);
       int Max2 = Max(Max1, Class3Level);

       if(Max2 == Class1Level)
       {
         iSFavored = Class1;
       }
       else if(Max2 == Class2Level)
       {
          iSFavored = Class2;
       }
       else if(Max2 == Class3Level)
       {
         iSFavored = Class3;
       }
   }

   int Class12Gap = Class1Level - Class2Level;
   int Class13Gap = Class1Level - Class3Level;
   int Class23Gap = Class2Level - Class3Level;

   if(Class2Level == 0)
   {
      Class12Gap = 0;
      Class23Gap = 0;
   }
   if(Class3Level == 0)
   {
      Class13Gap = 0;
   }
   int SubraceFClassExcGap = FALSE;
   int RacialFClassExcGap = FALSE;

   if(SUBRACE_IGNORE_BASE_RACE_FAVORED_CLASS)
   {
       RacialFClassExcGap = GetFavoredClassExceedsGap(iRFavored, iSFavored, Class1, Class2, Class3, Class13Gap, Class23Gap, Class12Gap);
   }

   SubraceFClassExcGap = GetFavoredClassExceedsGap(iSFavored, iRFavored, Class1, Class2, Class3, Class13Gap, Class23Gap, Class12Gap);
   //Racial Favored Class Exceeds the Multiclass Level gap, and Subrace Favored class does not
   //So give a decrease in XP to counter NWN engine XP distribution.
   if(RacialFClassExcGap && !SubraceFClassExcGap)
   {
      return SUBRACE_XP_DECREASE;
   }
   //Subrace Favored Class Exceeds the Multiclass Level gap, and Racial Favored class does not
   //So give a boost in XP to override the NWN engine XP distribution.
   else if(!RacialFClassExcGap && SubraceFClassExcGap)
   {
      return SUBRACE_XP_BOOST;
   }
   //Both exceed the Multiclass Level gap or do not.
   //So since the effects of both exceeding cancel each other out, return normal XP.
   return SUBRACE_XP_UNCHANGED;
}

float GetSubraceXPModifier(object oPC)
{
  int FClass = Subrace_GetFavouredClass(oPC);
  float iMod = 1.0;
  if(FClass != -1)
  {
      int XPMod = XPPenaltyOrBoostForSubrace(oPC, FClass);

      if(XPMod == SUBRACE_XP_BOOST)
      {
          iMod = 1.25;
      }
      else if(XPMod == SUBRACE_XP_DECREASE)
      {
          iMod = 0.8;
      }
  }
  return iMod;

}

int GetECL(object oPC)
{
   string SubraceStorage = GetSubraceStorageLocationByID(GetPlayerSubraceID(oPC));
   return GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_ECL);
}

int Subrace_GetIsUndead(object oPC)
{
  if(!GetIsPC(oPC)) { return FALSE; }
  int ID = GetPlayerSubraceID(oPC);
  if(!ID) { return FALSE; }
  string SubraceStorage = GetSubraceStorageLocationByID(ID);
  return GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDEAD, SUBRACE_BASE_INFORMATION_FLAGS);

}
void ApplyUniqueSubraceEffect(object oPC, string SubraceStorage, int iEffect)
{
     if(iEffect == 0)
     { return; }
     int Value1 = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT,SUBRACE_EFFECT_VALUE1_FLAGSET);
     int Value2 = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT,SUBRACE_EFFECT_VALUE2_FLAGSET);
     int DurationType = GetSSEInt( SubraceStorage + "_" + SUBRACE_EFFECT_DURATION_TYPE);
     float fDuration = GetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_EFFECT_DURATION);
     effect eEffect = SHA_GetEffectFromID(iEffect, Value1, Value2);
     effect eEffectApp = SupernaturalEffect(eEffect);
     AssignCommand(oStorer, ApplyEffectToObject(DurationType, eEffectApp, oPC, fDuration));
}
void ApplySubraceEffect(object oPC, string SubraceStorage, int TimeOfDay)
{
   int EffectCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_EFFECT_COUNT);
   if(EffectCount == 0)
   {
       return;
   }
   ClearSubraceEffects(oPC);
   int i = 0;
   while(i != EffectCount)
   {
     i++;
     string SubraceStorage1 = SubraceStorage + IntToString(i);
     int EffectID =  GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_EFFECT,SUBRACE_EFFECT_FLAGSET);
     int EffectTimeOfDay = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_EFFECT,SUBRACE_EFFECT_TIME_FLAGSET);
     if(EffectTimeOfDay == TIME_BOTH || EffectTimeOfDay == TimeOfDay)
     {
        ApplyUniqueSubraceEffect(oPC, SubraceStorage1, EffectID);
     }
  }
  SSE_MessageHandler(oPC, MESSAGE_SUBRACE_EFFECTS_APPLIED);
}

void ApplySubrace(object oTarget, string subrace)
{
    subrace = GetStringLowerCase(subrace);
/*
    if(ENABLE_LETO)
    {
        SetLocalString(oTarget, "SUBR_PlayerName", GetPCPlayerName(oTarget));
        DelayCommand(4.0, SetLocalString(oTarget, "SUBR_FileName", GetBicFileName(oTarget)));
    }
*/
    DeleteSubraceInfoOnPC(oTarget);
    int ID = GetSubraceID(subrace);
    DelayCommand(1.5, LoadSubraceInfoOnPC(oTarget, subrace));
    DelayCommand(2.6, SetDbInt(oTarget, SUBRACE_TAG + "_" + GetSubraceNameByAlias(subrace, TRUE), SUBRACE_ACCEPTED, 0, FALSE));
    DelayCommand(4.0, ApplyPermanentSubraceSpellResistance(ID, oTarget));
    DelayCommand(5.5, ApplyPermanentSubraceAppearance(ID, oTarget));
// 3.0.6.6
    DelayCommand(6.0, ApplySubraceColors(oTarget));
    DelayCommand(6.5, ApplySubraceEyeColors(oTarget));

//3.0.6.9
    DelayCommand(7.0, ApplySubraceHead(oTarget));

    DelayCommand(7.5, CheckIfCanUseEquipedWeapon(oTarget));
    DelayCommand(11.5,CheckIfCanUseEquippedArmor(oTarget));
}

//3.0.6.6

void ApplySubraceColors(object oPC)
{
    string SubraceStorage = GetSubraceStorageLocation(GetStringLowerCase(GetSubRace(oPC)));
    int Level = GetPlayerLevel(oPC);
    //SendMessageToPC(oPC, "Attempting to Apply Subrace Colors for level "+IntToString(Level));

    while (Level)
    {
        string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
        int Gender = GetGender(oPC);
        if(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_COLORS_FLAGS) )
        {
           int Hair = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_COLORS_FLAGS, (Gender==GENDER_MALE?SUBRACE_COLORS_FLAGS_HAIR_MALE:SUBRACE_COLORS_FLAGS_HAIR_FEMALE) );
           int Skin = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_COLORS_FLAGS, (Gender==GENDER_MALE?SUBRACE_COLORS_FLAGS_SKIN_MALE:SUBRACE_COLORS_FLAGS_SKIN_FEMALE) );

           //SendMessageToPC(oPC, "Attempting to Apply Subrace Colors Hair: " + IntToString(Hair) + " and Skin: " + IntToString(Skin));

           if ((Hair>-1)||(Skin>-1))
           {
               if (Hair>-1)
               {
                    SetColor(oPC, COLOR_CHANNEL_HAIR, Hair);
               }
               if (Skin>-1)
               {
                    SetColor(oPC, COLOR_CHANNEL_SKIN, Skin);
               }
               return;
           }
        }
        Level--;
     }
}

//3.0.6.6
void SHA_SetEyeColor(object oPC, int iEyes = -1)
{
    effect eEffect, eVisEyes;
    int iGender = GetGender(oPC), iSub, iType;
    switch (iEyes)
    {
        case SUBRACE_EYE_COLOR_CYAN:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_CYN_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
        case SUBRACE_EYE_COLOR_GREEN:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_GREEN_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
        case SUBRACE_EYE_COLOR_ORANGE:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_ORG_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
               case SUBRACE_EYE_COLOR_PURPLE:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_PUR_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
        case SUBRACE_EYE_COLOR_RED:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_RED_FLAME_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
        case SUBRACE_EYE_COLOR_WHITE:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_WHT_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
        case SUBRACE_EYE_COLOR_YELLOW:
        {
            switch(GetRacialType(oPC))
            {
                case RACIAL_TYPE_DWARF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_DWARF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_DWARF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_ELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_ELF_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_ELF_FEMALE);
                    break;
                }
                case RACIAL_TYPE_GNOME:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_GNOME_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_GNOME_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFELF:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HUMAN_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFLING:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HALFLING_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HALFLING_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HALFORC:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HALFORC_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HALFORC_FEMALE);
                    break;
                }
                case RACIAL_TYPE_HUMAN:
                {
                    if (iGender == GENDER_MALE) eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HUMAN_MALE);
                    else eVisEyes = EffectVisualEffect(VFX_EYES_YEL_HUMAN_FEMALE);
                    break;
                }
            }
            break;
        }
    }
    eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        iType = GetEffectType(eEffect);
        iSub = GetEffectSubType(eEffect);
        if (iType == EFFECT_TYPE_VISUALEFFECT && iSub == SUBTYPE_SUPERNATURAL)
        {
            RemoveEffect(oPC, eEffect);
        }
        eEffect = GetNextEffect(oPC);
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eVisEyes), oPC);
}

//3.0.6.9
void ApplySubraceHead(object oPC)
{
    string SubraceStorage = GetSubraceStorageLocation(GetStringLowerCase(GetSubRace(oPC)));
    int Level = GetPlayerLevel(oPC);
    while (Level)
    {
        string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
        int Gender = GetGender(oPC);
        if(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_HEAD_FLAGS) )
        {
           int iHead = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_HEAD_FLAGS, (Gender==GENDER_MALE?SUBRACE_HEAD_FLAGS_MALE:SUBRACE_HEAD_FLAGS_FEMALE) );
           if (iHead>-1)
           {
             SetCreatureBodyPart(CREATURE_PART_HEAD,iHead,oPC);
             return;
           }
        }
        Level--;
     }
}

//3.0.6.6
void ApplySubraceEyeColors(object oPC)
{
    string SubraceStorage = GetSubraceStorageLocation(GetStringLowerCase(GetSubRace(oPC)));
    int Level = GetPlayerLevel(oPC);
    while (Level)
    {
        string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
        int Gender = GetGender(oPC);
        if(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_EYE_COLORS_FLAGS) )
        {
           int iEyes = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_EYE_COLORS_FLAGS, (Gender==GENDER_MALE?SUBRACE_EYE_COLORS_FLAGS_MALE:SUBRACE_EYE_COLORS_FLAGS_FEMALE) );
           if (iEyes>-1)
           {
             SHA_SetEyeColor(oPC, iEyes);
             return;
           }
        }
        Level--;
     }
}

//3.0.6.9 - Rewrite by moon
void LoadSubraceInfoOnPC(object oPC, string subrace){
    if(GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC)){
        ReapplySubraceAbilities(oPC);
        return;
    }

    if(subrace == ""){
        return;
    }

    //    subrace = GetStringLowerCase(subrace); //DATABASE req. lowercase for compatibility with < 3.0.5
    //3.0.6.9 extra optimazation
    int ID = GetSubraceID(subrace);
    string subraceBaseName = GetSubraceNameByID(ID);
    string subraceBaseNameLower = GetStringLowerCase(subraceBaseName);
    //Oh oh, someone has removed the subrace! >.<
    if(!ID){
        SSE_MessageHandler(oPC, MESSAGE_SUBRACE_IS_MISSING_FROM_SERVER);
        return;
    }

    if(!(SSE_TREAT_ALIAS_AS_SUBRACE & 1)){
        //SSE_MessageHandler(oPC, MESSAGE_SUBRACE_ALIAS_UNIFORMIZING,subrace, subraceBaseName );
        SetSubRace(oPC, subraceBaseName);
        subrace = subraceBaseName;
    }
    else if (subrace != subraceBaseName){
        //SSE_MessageHandler(oPC, MESSAGE_SUBRACE_ALIAS_DIVERSITY, subraceBaseName );
    }

    SetSubRace(oPC, subrace);
    string SubraceStorage = GetSubraceStorageLocation(subrace);

    //SSE_MessageHandler(oPC, MESSAGE_SUBRACE_LOADING_DATA, subrace );

    int Gender = GetGender(oPC);

    GiveSubraceUniqueItem(SubraceStorage, oPC);
    int iTime = SHA_GetCurrentTime();
    DelayCommand(3.0, SetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC, TRUE));
    DelayCommand(4.0, ApplyTemporarySubraceAppearance(SubraceStorage, oPC, iTime));
    DelayCommand(4.5, ChangeMiscellaneousSubraceStuff(oPC, GetPlayerLevel(oPC)));
    DelayCommand(5.5, ApplySubraceEffect(oPC, SubraceStorage, iTime));
    DelayCommand(6.5, ApplyPermanentSubraceSpellResistance(ID, oPC));
    DelayCommand(7.5, ApplyPermanentSubraceAppearance(ID, oPC));

//3.0.6.6
    DelayCommand(8.0, ApplySubraceColors(oPC));
    DelayCommand(8.5, ApplySubraceEyeColors(oPC));

//3.0.6.9
    DelayCommand(9.0, ApplySubraceHead(oPC));

    DelayCommand(10.0, EquipTemporarySubraceSkin(SubraceStorage, oPC, iTime));
    DelayCommand(13.0, EquipTemporarySubraceClaw(SubraceStorage, oPC, iTime));
    DelayCommand(14.0, SendChatLogMessage(oPC, C_GREEN+"Subrace loaded."+C_END, oPC, 5));
    DelayCommand(20.0, ChangeSubraceFactions(oPC, subrace));

    int Level = GetPlayerLevel(oPC);
    int NeedsToRelog = CheckForLetoReLog(oPC, Level);
    SetDbInt(oPC, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL + "_" + subraceBaseNameLower, Level);
/*
    if(NeedsToRelog)
    {
       if(!LETO_ACTIVATE_PORTAL)
       {
           DelayCommand(24.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, SUBRACE_ENGINE + SSE_GetStandardMessage(MESSAGE_LETO_PLEASE_RELOG)));
           if(LETO_AUTOMATICALLY_BOOT)
           {
               DelayCommand(24.2, SSE_MessageHandler(oPC, MESSAGE_LETO_AUTOBOOT, IntToString(LETO_AUTOMATIC_BOOT_DELAY) ));
               DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_BOOT_DELAY), DelayBoot(oPC));
           }
       }
       else
       {
              if(!LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE)
              {
                  DelayCommand(24.2, SSE_MessageHandler(oPC, MESSAGE_LETO_AUTOPORTAL, IntToString(LETO_AUTOMATIC_PORTAL_DELAY) ));
                  DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, LETO_PORTAL_WAYPOINT, TRUE));
              }
              else
              {
                   int RandomNumber = d100(1);
                   string sWPTag = "WP_SUBRACE_P" + IntToString(RandomNumber);
                   object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);
                   DelayCommand(24.2, SSE_MessageHandler(oPC, MESSAGE_LETO_DONT_PANIC_JUSTPORTING));
                   DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, sWPTag, TRUE));
                   DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), DestroyObject(oWaypoint, 0.1));
              }
       }

    }
*/
}

void DeleteSubraceInfoInDatabase(object oPC, string subrace)
{
    DeleteDbVariable(oPC, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL + "_" + subrace, FALSE);
    DeleteDbVariable(oPC, SUBRACE_TAG + subrace, FALSE);
}

void DeleteSubraceInfoOnPC(object oPC, int ClearSubraceField=FALSE)
{
    string subrace = GetSubRace(oPC);
    string SubraceStorage = GetSubraceStorageLocation(subrace);

    if(subrace == "")
    { return; }

    DelayCommand(0.2, DeleteSubraceInfoInDatabase(oPC, GetSubraceNameByAlias(subrace, TRUE)));

    SSE_MessageHandler(oPC, MESSAGE_SUBRACE_PURGING);
    ClearSubraceTemporaryStats(oPC);
    ClearSubraceEffects(oPC);
    ChangeToPCDefaultAppearance(oPC);
    effect iEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(iEffect))
    {
         int iEffectType = GetEffectType(iEffect);
         if(iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
         iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE)
         {
             RemoveEffect(oPC, iEffect);
         }
      iEffect = GetNextEffect(oPC);
    }

    DeleteLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);

    object Skin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    SetPlotFlag(Skin, FALSE);
    DestroyObject(Skin, 0.1);

    //::****************************************************************
    // 1.69 -- Add horse menu and new skin if needed
    if( (GetIsPC( oPC) || GetIsDM( oPC)) &&
        (GetSkinHasHorseMenu( Skin) || (!GetIsObjectValid( Skin) && !GetHasFeat( FEAT_HORSE_MENU, oPC))))
    { SSE_HorseAddHorseMenu( oPC);
    }
    //::****************************************************************

    object ClawLeft =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    object ClawRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    SetPlotFlag(ClawLeft, FALSE);
    SetPlotFlag(ClawRight, FALSE);
    DestroyObject(ClawLeft, 0.5);
    DestroyObject(ClawRight, 0.5);

    int SubraceUniqueItemCount = GetSSEInt( SubraceStorage + "_" + SUBRACE_UNIQUEITEM_COUNT);
    int i = 0;
    while(i <= SubraceUniqueItemCount)
    {
       i++;
       string resref = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(i));
       if(resref != "")
       {
           string sLevel = GetStringRight(resref, 2);
           if(GetStringLeft(sLevel, 1) == "_")
           {
              sLevel = GetStringRight(sLevel, 1);
           }
           int iLevel = StringToInt(sLevel);
           resref = GetStringLeft(resref, GetStringLength(resref) - 2);
           if(iLevel <= GetPlayerLevel(oPC))
           {
               object oItem = GetFirstItemInInventory(oPC);
               while(GetIsObjectValid(oItem))
               {
                   if(GetResRef(oItem) == resref)
                   {
                      SetPlotFlag(oItem, FALSE);
                      DestroyObject(oItem, 0.1);
                   }
                  oItem = GetNextItemInInventory(oPC);
               }
           }
      }
    }
   SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
   SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oPC);
   DeleteLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE");
   DeleteLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE");

   DeleteLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
   DeleteLocalInt(oPC, "SUB_EFCT_D_APD");
   DeleteLocalInt(oPC, "SUB_EFCT_N_APD");

   DeleteLocalInt(oPC,"SB_LGHT_DMGED");

   DeleteLocalInt(oPC,"SB_DARK_DMGED");

   DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
   if(ClearSubraceField)
    {
        if(subrace == "")
        {
            //3.0.6.5
            if (USE_SSE_DEFAULT_RACES)
            {
                DelayCommand(0.5, SetSubRace(oPC, ""));
                DelayCommand(0.6, CheckAndApplyDefaultSubrace(oPC));
            }
            else
            {
                DelayCommand(0.5, SetSubRace(oPC, ""));
            }
        }
    }
   DelayCommand(1.0, SSE_MessageHandler(oPC, MESSAGE_SUBRACE_PURGED));

}


string Subrace_TimeToString(int iTime)
{
   string ret = "ERROR";
   switch(iTime)
   {
       case TIME_DAY: ret = "Day time"; break;
       case TIME_NIGHT: ret = "Night time"; break;
       case TIME_BOTH: ret = "Day & Night time"; break;
       case TIME_NONE: ret = "None"; break;
       case TIME_SPECIAL_APPEARANCE_NORMAL: ret = "Special - Normal Appearance"; break;
       case TIME_SPECIAL_APPEARANCE_SUBRACE: ret = "Special - Subrace Appearance"; break;
   }
   return ret;
}

void ChangePCAppearance(object oPC, string SubraceStorage)
{
    if(GetPlayerInt(oPC, "pc_no_appear_change"))
        return;
         
   int App = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + APPEARANCE_TO_CHANGE, (GetGender(oPC)==GENDER_MALE?APPEARANCE_CHANGE_MALE_FLAG:APPEARANCE_CHANGE_FEMALE_FLAG) );
   if(App == 0)
   {
      SSE_MessageHandler(oPC, MESSAGE_SUBRACE_APPEARANCE_DATA_ERROR);
      return;
   }
   if(App == GetAppearanceType(oPC))
   { return; }
   if(!DISABLE_VISUAL_EFFECTS_WHEN_CHANGING_IN_APPEARANCE)
   {
       int Alignment = GetAlignmentGoodEvil(oPC);
       int VFX_ID = VFX_IMP_UNSUMMON;
       if(Alignment == ALIGNMENT_GOOD)
       {
           VFX_ID = VFX_IMP_GOOD_HELP;
       }
       else if (Alignment == ALIGNMENT_NEUTRAL)
       {
            VFX_ID = VFX_FNF_SUMMON_MONSTER_3;
       }
       else if (Alignment == ALIGNMENT_EVIL)
       {
            VFX_ID = VFX_IMP_EVIL_HELP;
       }
        effect VisualBurst = EffectVisualEffect(VFX_ID);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, VisualBurst, oPC);
   }

   if(PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE)
   {
     AssignCommand(oPC, SpeakString(SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_MONSTER));
   }
   SetCreatureAppearanceType(oPC, App);
   if(GetAppearanceType(oPC) == App)
    SSE_MessageHandler(oPC, MESSAGE_SUBRACE_APPEARANCE_CHANGED);
}

void ChangeToPCDefaultAppearance(object oPC)
{

    if(GetPlayerInt(oPC, "pc_no_appear_change"))
        return;

   int App = GetRacialType(oPC);
   if(App == GetAppearanceType(oPC))
   { return; }

   if(!DISABLE_VISUAL_EFFECTS_WHEN_CHANGING_IN_APPEARANCE)
   {
       int Alignment = GetAlignmentGoodEvil(oPC);
       int VFX_ID = VFX_IMP_UNSUMMON;
       if(Alignment == ALIGNMENT_GOOD)
       {
           VFX_ID = VFX_IMP_GOOD_HELP;
       }
       else if (Alignment == ALIGNMENT_NEUTRAL)
       {
            VFX_ID = VFX_FNF_SUMMON_MONSTER_3;
       }
       else if (Alignment == ALIGNMENT_EVIL)
       {
            VFX_ID = VFX_IMP_EVIL_HELP;
       }
       effect VisualBurst = EffectVisualEffect(VFX_ID);
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, VisualBurst, oPC);
   }
   if(PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE)
   {
        AssignCommand(oPC, SpeakString(SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_DEFAULT_RACIAL_TYPE));
   }

   SetCreatureAppearanceType(oPC, App);
   SSE_MessageHandler(oPC, MESSAGE_SUBRACE_APPEARANCE_REVERTED);
}


void ApplyPermanentSubraceAppearance(int ID, object oPC)
{
    if(GetPlayerInt(oPC, "pc_no_appear_change"))
        return;

    string SubraceStorage = GetSubraceStorageLocationByID(ID);
    int Level = GetPlayerLevel(oPC);
    while(Level)
    {
        string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
        int iTime = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
        if(iTime == TIME_BOTH)
        {
            ChangePCAppearance(oPC, SubraceStorage1);
            return;
        }
        Level--;
    }
    ChangeToPCDefaultAppearance(oPC);
}

void ApplyTemporarySubraceAppearance(string SubraceStorage, object oPC, int iCurrentTime)
{

    if(GetPlayerInt(oPC, "pc_no_appear_change"))
        return;

   int Level = GetPlayerLevel(oPC);
   while(Level)
   {
       string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
       int iTime = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
       if(iTime && iTime != TIME_NONE && iTime!= TIME_BOTH )
       {
           if(iTime == iCurrentTime)
           {
                ChangePCAppearance(oPC, SubraceStorage1);
           }
           else if(iTime != iCurrentTime)
           {
                ChangeToPCDefaultAppearance(oPC);
           }
           return;
       }
       Level--;
   }
}



void ApplyPermanentSubraceSpellResistance(int ID, object oPC)
{
   string SubraceStorage = GetSubraceStorageLocationByID(ID);


    if(GetSSEInt( SubraceStorage + "_" + SUBRACE_SPELL_RESISTANCE) == 0)
    { return; }

    effect iEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(iEffect))
    {
       int iEffectType = GetEffectType(iEffect);
       if(iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
           iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE)
           {
              RemoveEffect(oPC, iEffect);
           }
       iEffect = GetNextEffect(oPC);
    }
    int SpellResAtLevel1 = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_SPELL_RESISTANCE, SUBRACE_SPELL_RESISTANCE_BASE_FLAGS);
    int SpellResAtLevelMax = GetLocalGroupFlagValue(oStorer, SubraceStorage + "_" + SUBRACE_SPELL_RESISTANCE, SUBRACE_SPELL_RESISTANCE_MAX_FLAGS);
    float AvgSR;
    effect SpellResistance;
    float baseSR =  IntToFloat(SpellResAtLevel1);
    float maxSR =   IntToFloat(SpellResAtLevelMax);
    AvgSR = maxSR - baseSR;
    float SRPerLevel = AvgSR/IntToFloat(MAXIMUM_PLAYER_LEVEL);
    float PCLevel = IntToFloat(GetPlayerLevel(oPC));
    float SR = (PCLevel*SRPerLevel)+ baseSR;
    int SR_int = FloatToInt(SR);
    if(SUBRACE_SPELL_RESISTANCE_STACKS)
    {
       SR_int = SR_int + GetSpellResistance(oPC);

    }
    if(SR_int < 0)
    {
       SpellResistance = EffectSpellResistanceDecrease(abs(SR_int));
    }
    else
    {
       SpellResistance = EffectSpellResistanceIncrease(SR_int);
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(SpellResistance), oPC);
    SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SPELL_RESISTANCE_APPLIED);
}

void ApplyTemporarySubraceStats(object oPC, string SubraceStorage, int iCurrentTime, int AreaUndAbove, int AreaIntExt, int AreaNatArt)
{
   int  iTime =  GetSSEInt( SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS);
   iTime = iTime & ~FLAG12;
   if(iTime > 0)
   {
       int CurrentState =  0;
       if(AreaIntExt) CurrentState = CurrentState | FLAG4;
       if(!AreaIntExt) CurrentState = CurrentState | FLAG5;
       if(AreaUndAbove == AREA_UNDERGROUND) CurrentState = CurrentState | FLAG9;
       if(AreaUndAbove == AREA_ABOVEGROUND) CurrentState = CurrentState | FLAG8;
       if(AreaNatArt == AREA_NATURAL)  CurrentState = CurrentState | FLAG7;
       if(AreaNatArt == AREA_ARTIFICIAL)  CurrentState = CurrentState | FLAG6;
       SHA_ApplyTemporaryStats(oPC, SubraceStorage, iCurrentTime, iTime, CurrentState);
   }
}

void TemporaryStatsVisualFX(object oPC)
{
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect Vfx = EffectLinkEffects(eVis, eDur);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, Vfx, oPC);

}

void SHA_ApplyTemporaryStats(object oPC, string SubraceStorage, int iCurrentTime, int iTime, int AreasReq/*int AreaUndAbove, int AreaIntExt, int AreaNatArt*/)
{
    string SubraceStorage1 = SubraceStorage + IntToString(iCurrentTime);
    int AreasCan = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_STAT_MODIFIERS);

    int CurrentStatus = GetLocalInt(oPC, SUBRACE_STATS_STATUS);

    switch(iCurrentTime)
    {
      case TIME_DAY:
      {
           if(!(iTime & TIME_DAY) && !(iTime & TIME_NIGHT))
           {
              return;
           }
           if((CurrentStatus == TIME_SPECIAL_APPEARANCE_SUBRACE) || (CurrentStatus == TIME_SPECIAL_APPEARANCE_NORMAL))
           {
             return;
           }
           if((CurrentStatus == TIME_NIGHT) || ((CurrentStatus == TIME_DAY) && (~AreasCan & AreasReq)))
           {
               ClearSubraceTemporaryStats(oPC);
               SSE_MessageHandler(oPC, MESSAGE_ABILITY_SCORES_REVERTED);
               DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
           }
           if((iTime & TIME_DAY) && (AreasCan & AreasReq) && (CurrentStatus == TIME_DAY))
           {
               return;
           }
           break;
      }

      case TIME_NIGHT:
      {
          if(!(iTime & TIME_DAY) && !(iTime & TIME_NIGHT))
          {
              return;
          }
          if((CurrentStatus == TIME_SPECIAL_APPEARANCE_SUBRACE) || (CurrentStatus == TIME_SPECIAL_APPEARANCE_NORMAL))
          {
             return;
          }
          if((CurrentStatus == TIME_DAY) || ((CurrentStatus == TIME_NIGHT) && (~AreasCan & AreasReq)))
           {
               ClearSubraceTemporaryStats(oPC);
               SSE_MessageHandler(oPC, MESSAGE_ABILITY_SCORES_REVERTED);
               DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
           }
           if((iTime & TIME_NIGHT) && (AreasCan & AreasReq) && (CurrentStatus == TIME_NIGHT))
           {
               return;
           }
           break;
      }

      case TIME_SPECIAL_APPEARANCE_SUBRACE:
      {
         //appearance ability score takes priority...
         //normal appearance ability score takes priority...
         if((CurrentStatus == TIME_SPECIAL_APPEARANCE_NORMAL) || (CurrentStatus == TIME_DAY) || (CurrentStatus == TIME_NIGHT) || (~AreasCan & AreasReq))
         {
             ClearSubraceTemporaryStats(oPC);
             SSE_MessageHandler(oPC, ((CurrentStatus & TIME_SPECIAL_APPEARANCE_NORMAL)?MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_REVERTED:MESSAGE_ABILITY_SCORES_REVERTED));
             DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
         }
         //appearance is not normal, area requirements are met, and status says the stats have been applied, then return;
         CurrentStatus = GetLocalInt(oPC, SUBRACE_STATS_STATUS);
         if((GetAppearanceType(oPC) != SHA_GetDefaultAppearanceType(oPC)) && (AreasReq & AreasCan) && (CurrentStatus == TIME_SPECIAL_APPEARANCE_SUBRACE))
         {
               return;
         }
         if(!(iTime & TIME_SPECIAL_APPEARANCE_SUBRACE))
         {
            return;
         }
         break;
      }
      case TIME_SPECIAL_APPEARANCE_NORMAL:
      {
         //normal appearance ability score takes priority...
         if((CurrentStatus == TIME_SPECIAL_APPEARANCE_SUBRACE) || (CurrentStatus == TIME_DAY) || (CurrentStatus == TIME_NIGHT) || (~AreasCan & AreasReq))
         {
             ClearSubraceTemporaryStats(oPC);
             SSE_MessageHandler(oPC, ((CurrentStatus == TIME_SPECIAL_APPEARANCE_SUBRACE)?MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_REVERTED:MESSAGE_ABILITY_SCORES_REVERTED));
             DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
         }
         if((GetAppearanceType(oPC) == SHA_GetDefaultAppearanceType(oPC)) && (AreasReq & AreasCan) && (CurrentStatus == iCurrentTime))
         {
               return;
         }
         if(!(iTime & TIME_SPECIAL_APPEARANCE_NORMAL))
         {
            return;
         }
         break;
      }
    }

    if(!(iTime & iCurrentTime))
    {
        return;
    }
    if((~AreasCan & AreasReq))
    {
        return;
    }

    SetLocalInt(oPC, SUBRACE_STATS_STATUS, iCurrentTime);
    int iType = GetSSEInt( SubraceStorage  + IntToString(iCurrentTime) + "_" + SUBRACE_STAT_MODIFIER_TYPE);
    SubraceStorage = SubraceStorage + IntToString(iCurrentTime);
    if(GetIsResting(oPC))
    {
       AssignCommand(oPC, ClearAllActions(TRUE));
    }
    ClearSubraceTemporaryStats(oPC);
    if(iType == SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE)
    {
         AssignCommand(oPC, ApplySubraceBonusStatsByPercentage(oPC, SubraceStorage));
    }
    else if(iType == SUBRACE_STAT_MODIFIER_TYPE_POINTS)
    {
        AssignCommand(oPC, ApplySubraceBonusStatsByPoints(oPC, SubraceStorage));
    }
    //STAT MODIFIER TYPE Unrecognised
    else return;
    DelayCommand(1.0, TemporaryStatsVisualFX(oPC));
    DelayCommand(1.0, SSE_MessageHandler(oPC, MESSAGE_ABILITY_SCORES_CHANGED) );

}


void ClearSubraceEffects(object oPC)
{
    effect eBad = GetFirstEffect(oPC);
    while(GetIsEffectValid(eBad))
    {
        int iType = GetEffectType(eBad);
              //Remove effect if it is a subracial effect
        if(GetEffectCreator(eBad) == oStorer &&
                ( GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL) ||
                ( iType == EFFECT_TYPE_VISUALEFFECT ) )
          {
                if (iType == EFFECT_TYPE_ARCANE_SPELL_FAILURE ||
                    iType == EFFECT_TYPE_BLINDNESS ||
                    iType == EFFECT_TYPE_CHARMED ||
                    iType == EFFECT_TYPE_CONCEALMENT ||
                    iType == EFFECT_TYPE_CONFUSED ||
                    iType == EFFECT_TYPE_CUTSCENEGHOST ||
                    iType == EFFECT_TYPE_HASTE ||
                    iType == EFFECT_TYPE_IMMUNITY ||
                    iType == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
                    iType == EFFECT_TYPE_INVISIBILITY ||
                    iType == EFFECT_TYPE_MISS_CHANCE  ||
                    iType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE  ||
                    iType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
                    iType == EFFECT_TYPE_POLYMORPH  ||
                    iType == EFFECT_TYPE_REGENERATE ||
                    iType == EFFECT_TYPE_SANCTUARY ||
                    iType == EFFECT_TYPE_SLOW ||
                    iType == EFFECT_TYPE_TEMPORARY_HITPOINTS  ||
                    iType == EFFECT_TYPE_TRUESEEING ||
                    iType == EFFECT_TYPE_ULTRAVISION  ||
                    iType == EFFECT_TYPE_VISUALEFFECT ||
                    iType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ||
                    iType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
                  {

                        RemoveEffect(oPC, eBad);
                  }
          }
        eBad = GetNextEffect(oPC);
     }
}

void ClearSubraceTemporaryStats(object oPC)
{
    effect eBad = GetFirstEffect(oPC);
    while(GetIsEffectValid(eBad))
    {
        int iType = GetEffectType(eBad);

        if (iType == EFFECT_TYPE_ABILITY_DECREASE ||
            iType == EFFECT_TYPE_ABILITY_INCREASE ||
            iType == EFFECT_TYPE_AC_DECREASE ||
            iType == EFFECT_TYPE_AC_INCREASE ||
            iType == EFFECT_TYPE_ATTACK_INCREASE ||
            iType == EFFECT_TYPE_ATTACK_DECREASE ||
            iType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            iType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
            iType == EFFECT_TYPE_SAVING_THROW_DECREASE)
          {
               //Remove effect if it is a subracial effect
                if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                {
                    if(GetEffectCreator(eBad) == oPC)
                    {
                        RemoveEffect(oPC, eBad);
                    }
                }
          }
        eBad = GetNextEffect(oPC);
     }
}

void ApplySubraceBonusStatsByPoints(object oPC, string SubraceStorage)
{
int i=0;
for( ; i < 6 ; i++)
    {
    float statMod = GetLocalFloat(oStorer, SubraceStorage + "_" + GetSubraceStatStorageName(i, FALSE) );
    if(statMod != 0.0)
        {
            ApplyStat_AbilityByPoints(i, statMod, oPC);
        }
    }
   float ABMod = GetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_AB_MODIFIER);
   float ACMod = GetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_AC_MODIFIER);

   if(ABMod != 0.0)
   {
      ApplyAttackBonusByPoints(ABMod, oPC);
   }
   if(ACMod != 0.0)
   {
     ApplyArmourClassBonusByPoints(ACMod, oPC);
   }
}

void ApplyStat_AbilityByPoints(int AbilityToMod, float points, object oPC)
{
    int StatIncrease = FloatToInt(points);
    effect StatEffect;
    if(StatIncrease > 0)
    {
        StatEffect = EffectAbilityIncrease(AbilityToMod, StatIncrease);
    }
    else if(StatIncrease < 0)
    {
        int StatIncrease1 = abs(StatIncrease);
        StatEffect = EffectAbilityDecrease(AbilityToMod, StatIncrease1);
    }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
    }

void ApplyAttackBonusByPoints(float points, object oPC)
{
   int ABChange = FloatToInt(points);
   effect StatEffect;
   effect StatEffect1;
   if(ABChange > 0)
   {
      StatEffect = EffectAttackIncrease(ABChange, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackIncrease(ABChange, ATTACK_BONUS_OFFHAND);
   }
   else if(ABChange < 0)
   {
      int ABChange1 = abs(ABChange);
      StatEffect = EffectAttackDecrease(ABChange1, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackDecrease(ABChange1, ATTACK_BONUS_OFFHAND);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect1), oPC);
}

void ApplyArmourClassBonusByPoints(float points, object oPC)
{
   int ACChange = FloatToInt(points);
   effect StatEffect;
   if(ACChange > 0)
   {
        StatEffect = EffectACIncrease(ACChange, AC_NATURAL_BONUS);
   }
   else if(ACChange < 0)
   {
        int ACChange1 = abs(ACChange);
        StatEffect = EffectACDecrease(ACChange1, AC_NATURAL_BONUS);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}

void ApplySubraceBonusStatsByPercentage(object oPC, string SubraceStorage)
{
int i=0;
for( ; i < 6 ; i++)
    {
    float statMod = GetLocalFloat(oStorer, SubraceStorage + "_" + GetSubraceStatStorageName(i, FALSE) );
    if(statMod != 0.0)
        {
        ApplyStat_AbilityByPercentage(i, statMod, oPC);
        }
    }
   float ABMod = GetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_AB_MODIFIER);
   float ACMod = GetLocalFloat(oStorer, SubraceStorage + "_" + SUBRACE_STAT_AC_MODIFIER);

   if(ABMod != 0.0)
   {
        ApplyAttackBonusByPercentage(ABMod, oPC);
   }
   if(ACMod != 0.0)
   {
        ApplyArmourClassBonusByPercentage(ACMod, oPC);
   }
}

void ApplyStat_AbilityByPercentage(int AbilityToMod, float percentage, object oPC)
{
       int currentStat = GetAbilityScore(oPC, AbilityToMod);
       float cStat = IntToFloat(currentStat);

       float Stat = cStat*percentage;
       int newStat = FloatToInt(Stat);
       effect StatEffect;
       if(newStat > 0)
       {
         StatEffect = EffectAbilityIncrease(AbilityToMod, newStat);
       }
       else if(newStat < 0)
       {
         int newStat1 = abs(newStat);
         StatEffect = EffectAbilityDecrease(AbilityToMod, newStat1);
       }
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}

void ApplyAttackBonusByPercentage(float percentage, object oPC)
{
   float currentAB = IntToFloat(GetBaseAttackBonus(oPC));
   int Neg = FALSE;
   int Neg2 = FALSE;
   if(currentAB < 0.0 ) { Neg = TRUE; }
   if(percentage < 0.0 ) { Neg2 = TRUE; }
   int newAB = FloatToInt(currentAB*percentage);
   if(Neg && Neg2 ) { newAB = -newAB; }
   effect StatEffect;
   effect StatEffect1;
   if(newAB > 0)
   {
      StatEffect = EffectAttackIncrease(newAB, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackIncrease(newAB, ATTACK_BONUS_OFFHAND);
   }
   else if(newAB < 0)
   {
      int newAB1 = abs(newAB);
      StatEffect = EffectAttackDecrease(newAB1, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackDecrease(newAB1, ATTACK_BONUS_OFFHAND);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect1), oPC);
}

void ApplyArmourClassBonusByPercentage(float percentage, object oPC)
{
   float currentAC =  IntToFloat(GetAC(oPC));
   int newAC = FloatToInt(currentAC*percentage);
   effect StatEffect;
   if(newAC > 0)
   {
      StatEffect = EffectACIncrease(newAC, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
   }
   else if(newAC < 0)
   {
     int newAC1 = abs(newAC);
     StatEffect = EffectACDecrease(newAC1, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}



void SHA_SubraceForceUnequipItem(object oItem)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 0.1);
    ClearAllActions(TRUE);
    ActionUnequipItem(oItem);
    ActionDoCommand(SetCommandable(TRUE));
    SetCommandable(FALSE);
}

void SHA_SubraceForceEquipItem(object oItem, int InvoSlot)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 0.1);
    ClearAllActions(TRUE);
    ActionEquipItem(oItem, InvoSlot);
    ActionDoCommand(SetCommandable(TRUE));
    SetCommandable(FALSE);
}


void CheckCanUseItem(object oItem, object oPC, int iType = 1)
{
   int ID = GetPlayerSubraceID(oPC);
   if(!ID || !GetIsObjectValid(oItem))
   { return; }
   //ingore creature items.
   switch(GetBaseItemType(oItem))
   {
     case BASE_ITEM_CPIERCWEAPON:
     case BASE_ITEM_CSLASHWEAPON:
     case BASE_ITEM_CSLSHPRCWEAP:
     case BASE_ITEM_CBLUDGWEAPON:
     case BASE_ITEM_CREATUREITEM: return;
   }
   string SubraceStorage = GetSubraceStorageLocationByID(ID) + "_" + SUBRACE_ITEM_RESTRICTION + "_";

   int Restrictions;
   int Time = SHA_GetCurrentTime();


   if(SHA_GetDefaultAppearanceType(oPC) == GetAppearanceType(oPC))
    {
    //Normal form
    Restrictions = GetSSEInt( SubraceStorage + IntToString(TIME_SPECIAL_APPEARANCE_NORMAL) );
    }
   else
    {
    //Special form
    Restrictions = GetSSEInt( SubraceStorage + IntToString(TIME_SPECIAL_APPEARANCE_SUBRACE) );
    }

//No Special Restrictions based on appearance, try loading a time-based one!
if(!Restrictions)
    {
    Restrictions = GetSSEInt( SubraceStorage + IntToString(Time) );
    }

//If no restrictions at all for the current time and form, Restrictions will be FALSE
   if(Restrictions)
    {
       if(SHA_TestItemReq(GetItemType(oItem), Restrictions))
       {
          string sMsg;
          switch(iType)
          {
             case 1:  sMsg  = "weapon"; break;
             case 2:  sMsg  = "armor (or shield)"; break;
             case 3:  sMsg  = "jewlery (or misc item)"; break;
             default: sMsg  = "item"; break;
          }
          SSE_MessageHandler(oPC, MESSAGE_SUBRACE_CANNOT_EQUIP_ITEM, sMsg);
          DelayCommand(0.3, AssignCommand(oPC, SHA_SubraceForceUnequipItem(oItem)));
       }
   }

}


void SubraceOnPlayerEquipItem()
{
   object oItem = GetPCItemLastEquipped();
   object oPC = GetPCItemLastEquippedBy();
   if(!GetPlayerSubraceID(oPC) || GetIsSSEDisabled()) return;

   int iType = 1;
   switch(GetBaseItemType(oItem))
   {
      case BASE_ITEM_ARMOR:
      case BASE_ITEM_HELMET:
      case BASE_ITEM_LARGESHIELD:
      case BASE_ITEM_SMALLSHIELD:
      case BASE_ITEM_TOWERSHIELD: iType = 2; break;
      case BASE_ITEM_RING:
      case BASE_ITEM_AMULET:
      case BASE_ITEM_CLOAK:
      case BASE_ITEM_GLOVES:
      case BASE_ITEM_BRACER: iType = 3; break;
   }
   CheckCanUseItem(oItem, oPC, iType);
}

void CheckIfCanUseEquipedWeapon(object oPC)
{
    if(!GetPlayerSubraceID(oPC)) return;

    object Wep1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object Wep2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    CheckCanUseItem (Wep1, oPC, 1);
    DelayCommand(3.0, CheckCanUseItem (Wep2, oPC, 1));
}

void CheckIfCanUseEquippedArmor(object oPC)
{
    if(!GetPlayerSubraceID(oPC))
        { return; }

   object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
   CheckCanUseItem(oItem, oPC, 2);
}

string GetSubraceNameByID(int ID, int Lowercase=FALSE)
{
    string Name=GetLocalString(oStorer, MODULE_SUBRACE_NUMBER + IntToString(ID) );
    return Lowercase?GetStringLowerCase(Name):Name;
}

string GetSubraceNameByAlias(string Alias, int Lowercase=FALSE)
{
    //Aliases have same ID as the Subrace, however only the base name
    //  is recorded at the "Subrace-Index"
    return GetSubraceNameByID(GetSubraceID(Alias), Lowercase );
}

// 3.0.6.5 moons fix
void InitiateSubraceChecking(object oPC)
{
    string subraceAlias = GetStringLowerCase(GetSubRace(oPC));
    string subraceCased = GetSubraceNameByAlias(subraceAlias);
    string subrace      = GetStringLowerCase(subraceCased);

//3.0.6.5 - added default race changes
    if (USE_SSE_DEFAULT_RACES){
        if(subrace == ""){
            CheckAndApplyDefaultSubrace(oPC);
            subraceAlias = GetStringLowerCase(GetSubRace(oPC));
            subrace = GetSubraceNameByAlias(subraceAlias);
        }
    }

    if(subrace != ""){ //3.0.6.9 fix
        int check1 = GetDbInt(oPC, SUBRACE_TAG + "_" + subraceCased, FALSE);
        if(check1 != SUBRACE_UNINITIALIZED){
            SetDbInt(oPC, SUBRACE_TAG + "_" + subrace, check1, 0, FALSE);

            //3.0.6.7 fix
            if(check1 == SUBRACE_UNINITIALIZED){
                SetDbInt(oPC, SUBRACE_TAG + "_" + subrace, check1, 0, FALSE);
                DeleteDbVariable(oPC, SUBRACE_TAG + "_" + subraceCased, FALSE);
            }
        }
        if(check1 == SUBRACE_UNINITIALIZED){
            int check2 = CheckIfPCMeetsAnySubraceCriteria(oPC);
            if(check2 == SUBRACE_UNRECOGNISED){
                // If Unrecognized change to default...
                SetSubRace(oPC, "");
                InitiateSubraceChecking(oPC);
                return;
            }
            else if(!check2){
                // If Rejected change to default...
                SetSubRace(oPC, "");
                InitiateSubraceChecking(oPC);
                //SetDbInt(oPC, SUBRACE_TAG + "_" + subrace, SUBRACE_REJECTED, 0, FALSE);
                return;
            }
            else if(check2){
                SetDbInt(oPC, SUBRACE_TAG + "_" + subrace, SUBRACE_ACCEPTED, 0, FALSE);
            }
        }
        else if(check1 == SUBRACE_ACCEPTED)
        {
        }
        else if(check1 == SUBRACE_REJECTED)
        {
            //SUBRACE was rejected previously.
            return;
        }
        if(SEARCH_AND_DESTROY_SKINS_IN_INVENTORY)
        {
            SearchAndDestroySkinsAndClaws(oPC);
        }
        DelayCommand(1.0, LoadSubraceInfoOnPC(oPC, subraceAlias));
        DelayCommand(22.0, Subrace_MoveToStartLocation(oPC, subraceAlias));
    }
}

void Subrace_MoveToStartLocation(object oPC, string subrace = "")
{
// 3.0.6.5
  if (subrace == "")
  {
    string subrace = GetSubraceNameByAlias(GetSubRace(oPC));
  }
  string SubraceStorage =  GetSubraceStorageLocation(subrace);
  string WPTag = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_START_LOCATION);
  object oWP = GetWaypointByTag(WPTag);
  if( GetIsObjectValid(oWP) )
  {
     DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(oWP))));
     DelayCommand(0.5, SSE_MessageHandler(oPC, MESSAGE_SUBRACE_MOVE_TO_START_LOCATION, CapitalizeString(subrace)) );
  }
}

//3.0.6.4
//3.0.6.5 fix - string subrace removed
void Subrace_MoveToDeathLocation(object oPC)
{
  string subraceAlias = GetSubRace(oPC);
  string subrace = GetSubraceNameByAlias(subraceAlias, TRUE);
  string SubraceStorage =  GetSubraceStorageLocation(subrace);
  string WPTag = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_DEATH_LOCATION);
  object oWP = GetWaypointByTag(WPTag);
  object oDefaultWP = GetWaypointByTag(SUBRACE_DEATH_DEFAULT);
  if( GetIsObjectValid(oWP) )
  {
     DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(oWP))));
  }
  else
  {
//3.0.6.5 fix - defaults to GetStartingLocation()
     if( GetIsObjectValid(oWP) )
     {
        DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(oDefaultWP))));
     }
     else
     {
        DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetStartingLocation())));
     }
  }

}

void ChangeSubraceFactions(object oPC, string subrace)
{
   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int Count =  GetSSEInt( SubraceStorage + "_" + SUBRACE_FACTION_COUNT);
   if(Count)
   {
        float fDelay;
        while(Count != 0)
        {
            fDelay += 0.10;
            string  FactionCreatureTag = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count));
            int Reputation = GetSSEInt( SubraceStorage + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count));
            DelayCommand(fDelay, Subrace_FactionAdjustment(oPC, FactionCreatureTag, Reputation));
            Count--;
        }
        SHA_SendSubraceMessageToPC(oPC, SSE_GetStandardMessage(MESSAGE_SUBRACE_FACTION_ADJUSTED), FALSE);
    }

}

void Subrace_FactionAdjustment(object oPC, string FactionTag, int Adjustment)
{
   object Faction = GetObjectByTag(FactionTag);
   if( GetIsObjectValid(Faction) )
   {
      ClearPersonalReputation(oPC, Faction);
      ClearPersonalReputation(Faction, oPC);
      //Make friendly first..
      AdjustReputation(oPC, Faction, 100);

      //Now adjust
      AdjustReputation(oPC, Faction, Adjustment);
   }

}

void CheckAndSwitchSubrace(object oPC)
{
   string subrace = GetStringLowerCase(GetSubRace(oPC));

// 3.0.6.5
    if(subrace == "")
    {
        if (USE_SSE_DEFAULT_RACES)
        {
            CheckAndApplyDefaultSubrace(oPC);
            subrace = GetStringLowerCase(GetSubRace(oPC));
        }
        else { return; }
    }

   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int Level = GetPlayerLevel(oPC);
   string switchSubraceNames = GetLocalString(oStorer, SubraceStorage + "_" + SUBRACE_SWITCH_NAME + IntToString(Level));
   if(switchSubraceNames != "")
   {
       while(switchSubraceNames != "")
       {
           int iPos = FindSubString(switchSubraceNames, "_");
           string sSubrace;
           if(iPos != -1)
           {
              sSubrace = GetStringLeft(switchSubraceNames, iPos);
           }
           else
           {
              sSubrace = switchSubraceNames;
           }
           switchSubraceNames = GetStringRight(switchSubraceNames, GetStringLength(switchSubraceNames) - iPos - 1);
           string CurrentSubrace = GetSubRace(oPC);
           string NewSubrace = sSubrace;
           //SetSubRace(oPC, NewSubrace);
           //subrace = GetStringLowerCase(GetSubRace(oPC));
           SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS, NewSubrace);


           int check = FALSE;
           int NeedToMeetRequirements = GetSSEInt( SubraceStorage + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level));
          //only check restrictions if need be.
           if(NeedToMeetRequirements)
           {
               check = CheckIfPCMeetsAnySubraceCriteria(oPC);
           }
           if(!check)
           {
               subrace = GetStringLowerCase(NewSubrace);
               SetDbInt(oPC, SUBRACE_TAG + "_" + subrace, SUBRACE_ACCEPTED, 0, FALSE);
               DeleteSubraceInfoOnPC(oPC);

               DelayCommand(4.2, SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SWITCHING, NewSubrace + "..."));
               DelayCommand(4.3, SetSubRace(oPC, NewSubrace));
               DelayCommand(5.1, LoadSubraceInfoOnPC(oPC, NewSubrace));
               DelayCommand(15.0, CheckIfCanUseEquipedWeapon(oPC));
               DelayCommand(18.5, CheckIfCanUseEquippedArmor(oPC));
               DelayCommand(21.5, SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SWITCHED));
               return;
           }
       }
   }
}

void ModifyAttachments(object oPC, string SubraceStorage, int Level){
    string script = "";
    string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);

    //SendMessageToPC(oPC, "Attempting to Apply Wings/Tails for level "+IntToString(Level));
    //SendMessageToPC(oPC, "Wing Group: " +IntToString(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS))
    //    + "Tail Group: "+ IntToString(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS2)));

    //SendMessageToPC(oPC, SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS + " "
    //    + SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS2);

    if(GetSSEInt( SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS) ||
       GetSSEInt( SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS2)){
        int Gender = GetGender(oPC);
        int Wings = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS,
            (Gender==GENDER_MALE ? SUBRACE_ATTACHMENT_FLAGS_WINGS_MALE : SUBRACE_ATTACHMENT_FLAGS_WINGS_FEMALE ) );
        int Tail = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_ATTACHMENT_FLAGS2,
            (Gender==GENDER_MALE?SUBRACE_ATTACHMENT_FLAGS_TAIL_MALE:SUBRACE_ATTACHMENT_FLAGS_TAIL_FEMALE ) );

        //SendMessageToPC(oPC, "Attempting to Apply Subrace Wings: " + IntToString(Wings) + " and Tail: " + IntToString(Tail));

        if(Wings) {
            SetCreatureWingType(Wings, oPC);
            SSE_MessageHandler(oPC, MESSAGE_SUBRACE_NEW_WINGS_GAINED);
        }
        if(Tail) {
            SetCreatureTailType(Tail, oPC);
            SSE_MessageHandler(oPC, MESSAGE_SUBRACE_NEW_TAIL_GAINED);
        }
    }
}

void ModifyPortrait(object oPC, string SubraceStorage, int Level)
{
  string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
  string Gender = (GetGender(oPC)==GENDER_MALE?SUBRACE_PORTRAIT_MALE:SUBRACE_PORTRAIT_FEMALE);
  string Portrait = GetLocalString(oStorer, SubraceStorage1 + "_" + SUBRACE_PORTRAIT + "_" + Gender);
  if(Portrait != "")
  {
      SetPortraitResRef(oPC, Portrait);
      SSE_MessageHandler(oPC, MESSAGE_SUBRACE_NEW_PORTRAIT_GAINED);
  }
}

void ChangeMiscellaneousSubraceStuff(object oPC, int Level)
{
 string SubraceStorage = GetSubraceStorageLocationByID(GetPlayerSubraceID(oPC));
 ModifyAttachments(oPC, SubraceStorage, Level);
 ModifyPortrait(oPC, SubraceStorage, Level);
}

void SubraceOnPlayerLevelUp()
{
    object oPC = GetPCLevellingUp();
    if(!GetPlayerSubraceID(oPC))
    {
        return;
    }
    if(GetIsSSEDisabled())
    {
        SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SSE_IS_SHUTDOWN);
        return;
    }

    int Level = GetPlayerLevel(oPC);
    ReapplySubraceAbilities(oPC);
    DelayCommand(2.5, ChangeMiscellaneousSubraceStuff(oPC, Level));

    DelayCommand(2.0, CheckAndGiveSubraceItems(oPC));
    int NeedsToRelog = CheckForLetoReLog(oPC, Level);
/*
    if(NeedsToRelog)
    {
       if(!LETO_ACTIVATE_PORTAL)
       {
           DelayCommand(5.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, SUBRACE_ENGINE + SSE_GetStandardMessage(MESSAGE_LETO_PLEASE_RELOG)));
           if(LETO_AUTOMATICALLY_BOOT)
           {
               DelayCommand(5.2, SSE_MessageHandler(oPC, MESSAGE_LETO_AUTOBOOT, IntToString(LETO_AUTOMATIC_BOOT_DELAY)));
               DelayCommand(5.2 + IntToFloat(LETO_AUTOMATIC_BOOT_DELAY), DelayBoot(oPC));
           }
       }
       else
       {
              if(!LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE)
              {
                  DelayCommand(5.2, SSE_MessageHandler(oPC, MESSAGE_LETO_AUTOPORTAL, IntToString(LETO_AUTOMATIC_PORTAL_DELAY)));
                  DelayCommand(5.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, LETO_PORTAL_WAYPOINT, TRUE));
              }
              else
              {
                   int RandomNumber = d100(1);
                   string sWPTag = "WP_SUBRACE_P" + IntToString(RandomNumber);
                   object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);
                   DelayCommand(5.2, SSE_MessageHandler(oPC, MESSAGE_LETO_DONT_PANIC_JUSTPORTING));
                   DelayCommand(5.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, sWPTag, TRUE));
                   DelayCommand(15.0 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), DestroyObject(oWaypoint, 0.1));
              }
       }

       DelayCommand(5.0, SetDbInt(SUBRACE_DATABASE, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL + "_" + GetStringLowerCase(GetSubRace(oPC)), Level, oPC));
    }
*/
    DelayCommand(5.0, CheckAndSwitchSubrace(oPC));
}

string LetoSubraceModifications(object oPC, string SubraceStorage, int Level, int LastLetoLevelChanges)
{
  string ScriptForLeto = "";
  LastLetoLevelChanges++;
  while(LastLetoLevelChanges <= Level)
  {
     ScriptForLeto += CheckAndModifyBaseStats(oPC, SubraceStorage, LastLetoLevelChanges);
     ScriptForLeto += CheckAndModifyFeats(oPC, SubraceStorage, LastLetoLevelChanges);
     ScriptForLeto += CheckAndModifySoundSet(oPC, SubraceStorage, LastLetoLevelChanges);
     ScriptForLeto += CheckAndModifySkills(oPC, SubraceStorage, LastLetoLevelChanges);
     //3.0.6.6
     // ScriptForLeto += CheckAndModifyColors(oPC, SubraceStorage, LastLetoLevelChanges);
     LastLetoLevelChanges++;
  }
  return  ScriptForLeto;
}

int CheckForLetoReLog(object oPC, int Level)
{
//   if(!ENABLE_LETO)
//   { return FALSE; }

    //Need lowercase sub-race name for database.
   string subrace = GetStringLowerCase(GetSubRace(oPC));
   string SubraceStorage = GetSubraceStorageLocation(GetSubRace(oPC));
   int LetoChanges = GetDbInt(oPC, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL + "_" + subrace, FALSE);

   if(LetoChanges >= Level)
   { return FALSE; }

   int NeedsToRelog = FALSE;

   string LetoScriptToFile =  LetoSubraceModifications(oPC, SubraceStorage, Level, LetoChanges);
   if(LetoScriptToFile != "")
   {
      NeedsToRelog = TRUE;
      SetLocalString(oPC, "LETO_SCRIPT_TO_FILE", LetoScriptToFile);
   }
   SetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG", NeedsToRelog);
   return NeedsToRelog;
}

void SubraceOnClientLeave()
{
   object oPC = GetExitingObject();
   int LetoChanges = GetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG");
   //Is Leto Enabled? Is there any changes to be made?
   //No ID check needed, since SSE do not make Leto requests for sub-raceless players.
//   if(!ENABLE_LETO && !LetoChanges)
//   {  return; }
   if(LetoChanges)
   {
       int Level = GetPlayerLevel(oPC);
       string SubraceStorage = GetSubraceStorageLocationByID(GetPlayerSubraceID(oPC));
/*
       string BicFile = LETO_GetBicPath(oPC);
       string ScriptForLeto = GetLocalString(oPC, "LETO_SCRIPT_TO_FILE");

       WriteTimestampedLogEntry("*Subrace Engine LETOScript call for " + GetName(oPC) + " | " + GetLocalString(oPC, "SUBR_PlayerName") + " | " + BicFile + "* ");
       string LetoError = LetoScript("%char= q!"+BicFile+"!; "+ScriptForLeto+"%char = '>'; close %char; ");
       if(LetoError != "")
       {
          WriteTimestampedLogEntry("*Subrace Engine LETOScript Error: " + LetoError + "*");
       }
       DeleteLocalString(oPC, "LETO_SCRIPT_TO_FILE");
       DeleteLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG");
*/
   }
}

// Modified by pope_leo you use Exalt in memory edits.
string CheckAndModifyBaseStats(object oPC, string SubraceStorage, int Level){
    //string script = "";
    string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
    int HasBMods = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS);
    if(HasBMods){
        int StrengthModifier = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_STR_MODIFIER);
        int DexterityModifier = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER);
        int ConstitutionModifier =  GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_CON_MODIFIER);
        int IntelligenceModifier =  GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_INT_MODIFIER);
        int WisdomModifier =  GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER);
        int CharismaModifier =  GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER);
        int SpdModifier =   GetSSEInt( SubraceStorage1  + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER);
        int Set = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE);
        if(StrengthModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_STRENGTH, StrengthModifier);
            else ModifyAbilityScore (oPC, ABILITY_STRENGTH, StrengthModifier);
           //script += LETO_ModifyProperty("Str", StrengthModifier, Set);
        }
        if(DexterityModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_DEXTERITY, DexterityModifier);
            else ModifyAbilityScore (oPC, ABILITY_DEXTERITY, DexterityModifier);
           //script += LETO_ModifyProperty("Dex", DexterityModifier, Set);
        }
        if(ConstitutionModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_CONSTITUTION, ConstitutionModifier);
            else ModifyAbilityScore (oPC, ABILITY_CONSTITUTION, ConstitutionModifier);
            //script += LETO_ModifyProperty("Con", ConstitutionModifier, Set);
        }
        if(WisdomModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_WISDOM, WisdomModifier);
            else ModifyAbilityScore (oPC, ABILITY_WISDOM, WisdomModifier);
           //script += LETO_ModifyProperty("Wis", WisdomModifier, Set);
        }
        if(IntelligenceModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_INTELLIGENCE, IntelligenceModifier);
            else ModifyAbilityScore (oPC, ABILITY_INTELLIGENCE, IntelligenceModifier);
           //script += LETO_ModifyProperty("Int", IntelligenceModifier, Set);
        }
        if(CharismaModifier){
            if(Set) SetAbilityScore (oPC, ABILITY_CHARISMA, CharismaModifier);
            else ModifyAbilityScore (oPC, ABILITY_CHARISMA, CharismaModifier);
           //script += LETO_ModifyProperty("Cha", CharismaModifier, Set);
        }
        if(SpdModifier != MOVEMENT_SPEED_CURRENT)
            SetMovementRate (oPC, SpdModifier);
            //script += LETO_SetMovementSpeed(SpdModifier);
   }
   return "";
}

// Modified by pope_leo you use Exalt in memory edits.
string CheckAndModifyFeats(object oPC, string SubraceStorage, int Level)
{
   string script = "";
   string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
   int FeatCount = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BONUS_FEAT_COUNT);
   if(FeatCount > 0)
   {
      while(FeatCount)
      {
         int Feat = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, SUBRACE_BONUS_FEAT_FLAG);
         int Remove = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, SUBRACE_BONUS_FEAT_REMOVE_FLAG);
         FeatCount--;

         if(Remove == 0) AddKnownFeat (oPC, Feat, 0);
         else RemoveKnownFeat (oPC, Feat);
         //script += LETO_ModifyFeat(Feat, Remove);
      }

   }
   return "";
}

string CheckAndModifySkills(object oPC, string SubraceStorage, int Level)
{
   string script = "";
   string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
   int SkillCount = GetSSEInt( SubraceStorage1 + "_" + SUBRACE_BONUS_SKILL_COUNT);
   if(SkillCount > 0)
   {
      while(SkillCount)
      {
         int Skill = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_FLAG);
         int Remove = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_REMOVE_FLAG);
         int Mod = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_MODIFIER_FLAG);
         SkillCount--;
         if(Remove == 0) ModifySkillRank (oPC, Skill, Mod);
         else SetSkillRank (oPC, Skill, Mod);
         //script += LETO_ModifySkill(Skill, Mod, Remove);
      }

   }
   return "";
}

string CheckAndModifySoundSet(object oPC, string SubraceStorage, int Level)
{
   string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
   int Gender = (GetGender(oPC)==GENDER_MALE)?SUBRACE_SOUNDSET_MALE_FLAG:SUBRACE_SOUNDSET_FEMALE_FLAG;

   int SoundSet = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + SUBRACE_SOUNDSET_FLAGS, Gender);
   if(SoundSet)
   {
        SetSoundset (oPC, SoundSet);
      //return LETO_SetSoundSet(SoundSet);
   }
   return "";
}

void SubraceOnPlayerRespawn()
{
    object oPC = GetLastRespawnButtonPresser();
    ReapplySubraceAbilities(oPC);
    DelayCommand(2.0, ChangeSubraceFactions(oPC, GetStringLowerCase(GetSubRace(oPC))));
}

void ReapplySubraceAbilities(object oPC)
{
     int ID = GetPlayerSubraceID(oPC);
     if(!ID)
         { return; }
     if(GetIsSSEDisabled())
     {
        SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SSE_IS_SHUTDOWN);
        return;
     }
     DeleteLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);
     DeleteLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
     string SubraceStorage = GetSubraceStorageLocationByID(ID);
     int IsLightSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
     int IsUndergSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
     if(IsLightSens)
     {
        DeleteLocalInt(oPC,"SB_LGHT_DMGED");
     }
     if(IsUndergSens)
     {
         DeleteLocalInt(oPC,"SB_DARK_DMGED");
     }
     ApplyPermanentSubraceSpellResistance(ID, oPC);
     int HasDiffStats = GetSSEInt( SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS);
     if(HasDiffStats > 0)
     {
        DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
        ClearSubraceTemporaryStats(oPC);
     }
     ClearSubraceEffects(oPC);
     int iTime = SHA_GetCurrentTime();
     DelayCommand(1.5, ApplyTemporarySubraceAppearance(SubraceStorage, oPC, iTime ));
     DelayCommand(2.0, ApplyPermanentSubraceAppearance(ID, oPC));
// 3.0.6.6
     DelayCommand(2.5, ApplySubraceColors(oPC));
     DelayCommand(3.0, ApplySubraceEyeColors(oPC));

// 3.0.6.9
     DelayCommand(3.5, ApplySubraceHead(oPC));

     DelayCommand(4.0, SearchAndDestroySkinsAndClaws(oPC));
     DelayCommand(4.5, ApplySubraceEffect(oPC, SubraceStorage, iTime));
     DelayCommand(5.0, EquipTemporarySubraceSkin(SubraceStorage, oPC, iTime));
     DelayCommand(6.0, EquipTemporarySubraceClaw(SubraceStorage, oPC, iTime));
     DelayCommand(6.1, SetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC, TRUE));
}

int SHA_GetCurrentTime()
{
   if(GetIsNight() || GetIsDusk())
   {
       return TIME_NIGHT;
   }
   return TIME_DAY;
}

void SwapAppearance(object oPC, string subrace)
{

   string SubraceStorage = GetSubraceStorageLocation(subrace);
   int Level = GetPlayerLevel(oPC);
   while(Level)
   {
       string SubraceStorage1 = SubraceStorage + "_" + IntToString(Level);
       int iTime = GetLocalGroupFlagValue(oStorer, SubraceStorage1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
       if(iTime)
       {
           if(SHA_GetDefaultAppearanceType(oPC) == GetAppearanceType(oPC))
           {
               ChangePCAppearance(oPC, SubraceStorage1);
               object oArea = GetArea(oPC);
               int AreaLocation = GetIsAreaAboveGround(oArea);
               int Interior = GetIsAreaInterior(oArea);
               int Natural = GetIsAreaNatural(oArea);
               ApplyTemporarySubraceStats(oPC, SubraceStorage, TIME_SPECIAL_APPEARANCE_SUBRACE, AreaLocation, Interior, Natural);
               DelayCommand(3.0, CheckIfCanUseEquipedWeapon(oPC));
               DelayCommand(6.0, CheckIfCanUseEquippedArmor(oPC));
           }
           else
           {
               ChangeToPCDefaultAppearance(oPC);
               object oArea = GetArea(oPC);
               int AreaLocation = GetIsAreaAboveGround(oArea);
               int Interior = GetIsAreaInterior(oArea);
               int Natural = GetIsAreaNatural(oArea);
               ApplyTemporarySubraceStats(oPC, SubraceStorage, TIME_SPECIAL_APPEARANCE_NORMAL, AreaLocation, Interior, Natural);
               DelayCommand(3.0, CheckIfCanUseEquipedWeapon(oPC));
               DelayCommand(6.0, CheckIfCanUseEquippedArmor(oPC));
           }
           return;
       }
       Level--;
   }

}
void SubraceCheckItemActivated(object oPC, string sTag)
{
   string subrace = GetStringLowerCase(GetSubRace(oPC));
   if(subrace == "")
   { return; }
   if(subrace == sTag)
   {
      SwapAppearance(oPC, subrace);
   }

}

void SubraceOnItemActivated()
{
   object oPC =  GetItemActivator();
   object oItem = GetItemActivated();
   object oTarget = GetItemActivatedTarget();
   string sTag = GetStringLowerCase(GetTag(oItem));

    //Will still recognise the old tag!
   if(sTag == "swand" || sTag == "_dm_subrace_wand")
   {
       //Moved all of this code into the Subrace Wand's swand_StartConversation() call (see sw_main_inc or sw_proto_inc)
       AssignCommand(oPC, ActionStartConversation(oPC, "swand", FALSE, FALSE));
   }
   if(GetIsSSEDisabled())
   {
        return;
   }
   int iAbility = StringToInt(sTag);
   if (iAbility > 0 )
    {
        SubraceAbility(oPC,iAbility,oTarget);
    }
   else
   if(sTag == "_potion_blood")
   {
        effect eDmg;
        effect eVisual = EffectVisualEffect(VFX_IMP_HARM);
        if(Subrace_GetIsUndead(oPC))
        {
           eDmg = EffectHeal(GetMaxHitPoints(oPC));
        }
        else
        {
           int iDmg = GetCurrentHitPoints(oPC) - d4();
           if(iDmg < 1)
           {
              iDmg = 1;
           }
           eDmg =  EffectDamage(iDmg, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY);
        }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmg, oPC);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVisual, GetLocation(oPC));
  }
     else if(sTag == "dimension_door")
   {
        location lTarget = GetItemActivatedTargetLocation();
        if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
        AssignCommand(oPC, ClearAllActions());
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), oPC);
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
        DelayCommand(1.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), oPC));
   }

   else if(sTag == "faerie_fire_blue")
    {
        float FFDuration = IntToFloat(GetHitDice(oPC)*60);
        effect FaerieAura = MagicalEffect(EffectVisualEffect(VFX_DUR_AURA_BLUE));
        effect FaerieGlow = MagicalEffect(EffectVisualEffect(VFX_DUR_LIGHT_BLUE_5));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieAura,oTarget,FFDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieGlow,oTarget,FFDuration);
    }
   else if(sTag == "faerie_fire_green")
    {
        float FFDuration = IntToFloat(GetHitDice(oPC)*60);
        effect FaerieAura = MagicalEffect(EffectVisualEffect(VFX_DUR_AURA_GREEN));
        effect FaerieGlow = MagicalEffect(EffectVisualEffect(VFX_DUR_LIGHT_GREY_5));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieAura,oTarget,FFDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieGlow,oTarget,FFDuration);
    }
   else if(sTag == "faerie_fire_violet")
    {
        float FFDuration = IntToFloat(GetHitDice(oPC)*60);
        effect FaerieAura = MagicalEffect(EffectVisualEffect(VFX_DUR_AURA_PURPLE));
        effect FaerieGlow = MagicalEffect(EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_5));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieAura,oTarget,FFDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,FaerieGlow,oTarget,FFDuration);
    }
  else SubraceCheckItemActivated(oPC, sTag);

}

//3.0.6.5
void CheckAndApplyDefaultSubrace(object oPC)
{
    switch (GetRacialType(oPC))
    {
        case RACIAL_TYPE_DWARF:
        {
            SetSubRace(oPC,SUBRACE_DWARF_DEFAULT);
        }
        break;
        case RACIAL_TYPE_ELF:
        {
            SetSubRace(oPC,SUBRACE_ELF_DEFAULT);
        }
        break;
        case RACIAL_TYPE_GNOME:
        {
            SetSubRace(oPC,SUBRACE_GNOME_DEFAULT);
        }
        break;
        case RACIAL_TYPE_HALFELF:
        {
            SetSubRace(oPC,SUBRACE_HALFELF_DEFAULT);
        }
        break;
        case RACIAL_TYPE_HALFLING:
        {
            SetSubRace(oPC,SUBRACE_HALFLING_DEFAULT);
        }
        break;
        case RACIAL_TYPE_HALFORC:
        {
            SetSubRace(oPC,SUBRACE_HALFORC_DEFAULT);
        }
        break;
        case RACIAL_TYPE_HUMAN:
        {
            SetSubRace(oPC,SUBRACE_HUMAN_DEFAULT);
        }
        break;
    }
}

void SubraceOnClientEnter(object oPC = OBJECT_INVALID){
   if(!GetIsObjectValid(oPC)){
      oPC = GetEnteringObject();
   }
   if(!GetIsPC(oPC)) { return; }
   string subrace = GetSubRace(oPC);

//3.0.6.5
    if(subrace == ""){
        if (USE_SSE_DEFAULT_RACES){
            CheckAndApplyDefaultSubrace(oPC);
            subrace = GetSubRace(oPC);
        }
        else{
            return;
        }
   }
   object oArea = GetArea(oPC);
   if(!GetIsObjectValid(oArea))
   {
        //wait for the PC to enter properly...
        DelayCommand(2.0, SubraceOnClientEnter(oPC));
        return;
   }
   if(!GetSSEInt( SUBRACE_INFO_LOADED_ON_MODULE))
   {
          //SSE_MessageHandler(oPC, MESSAGE_MODLOAD_NOT_COMPLETE);
          DelayCommand(2.0, SubraceOnClientEnter(oPC));
          return;
   }
   DeleteLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG");
   int infoLoaded = GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);
/*
   if(ENABLE_LETO && !infoLoaded)
   {
       ExportSingleCharacter(oPC);
       SetLocalString(oPC, "SUBR_PlayerName", GetPCPlayerName(oPC));
       DelayCommand(5.0, SetLocalString(oPC, "SUBR_FileName", GetBicFileName(oPC)));
   }
*/
    if(GetIsSSEDisabled()){
        SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SSE_IS_SHUTDOWN);
        return;
    }
    if(GetIsSSEDisabledInArea(oArea)){
        SSE_MessageHandler(oPC, MESSAGE_SUBRACE_SSE_IS_SHUTDOWN_IN_AREA);
        SetLocalInt(oPC, "LOAD_SUBRACE", TRUE);
        return;
    }
    if(!infoLoaded){
        DelayCommand(1.0, InitiateSubraceChecking(oPC));
    }
    else if(infoLoaded && RELOAD_SUBRACE_INFORMATION_UPON_RELOGIN){
        DeleteLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);
        DelayCommand(1.0, LoadSubraceInfoOnPC(oPC, subrace));
    }
    else{
        DelayCommand(1.0, ReapplySubraceAbilities(oPC));
    }
}

void SHA_SendSubraceMessageToPC(object oPC, string message, int Important = TRUE)
{
   if(MINIMALISE_SUBRACE_MESSAGES_TO_PC)
   {
      if(Important)
      {
         SendMessageToPC(oPC, SUBRACE_ENGINE + message);
      }
   }
   else
   {
      SendMessageToPC(oPC, SUBRACE_ENGINE + message);
   }
}

void SSE_Message_RemoveDisplayType(int MessageType)
{
    int Display = SSE_Message_GetDisplayType();
    Display &= (~MessageType);
    SSE_Message_SetDisplayType(Display);
}

void SSE_Message_SetDisplayType(int MessageType)
{
    SetSSEInt(MESSAGE_DISPLAY_CONTROL, MessageType);
}

void SSE_Message_AddDisplayType(int MessageType)
{
    int Display = SSE_Message_GetDisplayType(TRUE);
    Display |= (~MessageType);
    SSE_Message_SetDisplayType(Display);
}

int SSE_Message_GetDisplayType(int DoNotReturnServerDefault=FALSE)
{
    int Types = GetSSEInt(MESSAGE_DISPLAY_CONTROL);
    if(Types)
        return Types;
    return DoNotReturnServerDefault?FALSE:MESSAGE_TYPE_SERVER_DEFAULT;
}

void SSE_MessageHandler(object Receiver, int MessageReference, string VariableText="", string VariableText2="", int MessageType = MESSAGE_TYPE_DEFAULT)
{
    //Use MessageType's Type instead of MessageReference, if MessageType is not "default"
    int Type = ( MessageType == MESSAGE_TYPE_DEFAULT ?
        MessageReference & MESSAGE_HANDLER_GET_MESSAGE_TYPE
        :
        MessageType & MESSAGE_HANDLER_GET_MESSAGE_TYPE
        );
    int Message = MessageReference & MESSAGE_HANDLER_GET_MESSAGE;
    //No type or no message -> nothing to do.
    if(!Type || !Message) return;
    int DisplayTypes = SSE_Message_GetDisplayType();
    string Text = SSE_GetStandardMessage(MessageReference, VariableText, VariableText2);
    //Log?
    if(MESSAGE_TYPE_LOG & Type)
    {
        //Log is not enough to get it sent to the player as well.
        Type&= (~MESSAGE_TYPE_LOG);
        WriteTimestampedLogEntry(Text);
    }
    //Send only if we should
    if( (DisplayTypes & Type) || (Type & MESSAGE_TYPE_VITAL) )
    {
        SendMessageToPC(Receiver, SUBRACE_ENGINE + Text);
    }
}

string SSE_GetStandardMessage(int Ref, string VariableText="", string VariableText2="")
{
    string Message;
    switch(Ref)
    {
        case MESSAGE_SUBRACE_APPEARANCE_CHANGED:
            Message="Your appearance has been changed to better suit your "+ SUBRACE_WHEN_ADJECTIVE +" features.";
            break;
        case MESSAGE_SUBRACE_APPEARANCE_REVERTED:
            Message="Your appearance has been reverted back to your typical " + SUBRACE_WHEN_ADJECTIVE +" appearance.";
            break;
        case MESSAGE_SUBRACE_CRITERIA_FAILED:
            Message="Character has failed to meet the following criteria(s) required to be part of the " + SUBRACE_WHEN_NOUN+":";
            break;
        case MESSAGE_CANNOT_BE_PART_OF_PRESTIGIOUS_SUBRACE:
            Message="The sub-race you had chosen was a prestigious "+SUBRACE_WHEN_NOUN+". You cannot become part of this " + SUBRACE_WHEN_NOUN +" directly (Contact a DM for more info)!";
            break;
        case MESSAGE_FAILED_TO_MEET_PRESTIGIOUS_CLASS_RESTRICTION:
            Message="You have failed to meet the prestigious class restrictions!";
            break;
        case MESSAGE_SUBRACE_CRITERIA_MET:
            Message="You have met all the requirements for your chosen "+SUBRACE_WHEN_NOUN+"!";
            break;
        case MESSAGE_SUBRACE_CRITERIA_CLASS_FAILED:
            Message="You have not met the class requirements for your chosen "+SUBRACE_WHEN_NOUN+".";
            break;
        case MESSAGE_SUBRACE_CRITERIA_SPECIAL_RESTRICTION_FAILED:
            Message="You have not met the 'special' requirements for your chosen "+SUBRACE_WHEN_NOUN+". Further details on this restriction may be available from SChooser/SWand or the DMs";
            break;
        case MESSAGE_SUBRACE_CRITERIA_ALIGNMENT_FAILED:
            Message="You have not met the alignment requirements for your chosen "+SUBRACE_WHEN_NOUN+".";
            break;
        case MESSAGE_SUBRACE_CRITERIA_BASE_RACE_FAILED:
            Message="You are not part of the base race required in order to be part of your chosen "+SUBRACE_WHEN_NOUN+".";
            break;
        case MESSAGE_SUBRACE_UNRECOGNISED:
            Message="You have chosen an unrecognised " + SUBRACE_WHEN_NOUN+": " + VariableText;
            break;
        case MESSAGE_SUBRACE_CLAWS_WAIT_FOR_CLAWS_EQUIPPING:
            Message="Please wait... while your "+ SUBRACE_WHEN_ADJECTIVE +" claws are checked and " +VariableText+".";
            break;
        case MESSAGE_SUBRACE_CLAWS_MISSING_CREATURE_WEAPON_PROFICIENCY:
            Message="You do not have creature weapon proficiency... yet your "+SUBRACE_WHEN_NOUN+" wants to equip a creature claw. Inform a DM!";
            break;
        case MESSAGE_SUBRACE_CLAWS_SUCCESSFULLY_EQUIPPED:
            Message="Your new "+SUBRACE_WHEN_ADJECTIVE+" claws should have now been properly " + VariableText +".";
            break;
        case MESSAGE_SUBRACE_ACQUIRED_UNIQUE_ITEM:
            Message="You have acquired "+ ColourString(VariableText,"cä") + "; a "+SUBRACE_WHEN_ADJECTIVE +" item.";
            break;
        case MESSAGE_SUBRACE_EFFECTS_APPLIED:
            Message=SUBRACE_WHEN_ADJECTIVE +" effects have been appiled";
            break;
        case MESSAGE_SUBRACE_IS_MISSING_FROM_SERVER:
            Message="Data for your "+SUBRACE_WHEN_NOUN+" is missing or support for your "+ SUBRACE_WHEN_NOUN +" has been removed from the server! Contact a DM";
            break;
        case MESSAGE_SUBRACE_LOADING_DATA:
            Message="Loading your " + SUBRACE_WHEN_NOUN+ "; " + VariableText + "'s data...";
            break;
        case MESSAGE_SUBRACE_DATA_LOADED:
            Message="Your "+ SUBRACE_WHEN_ADJECTIVE +" data has been loaded on your character.";
            break;
        case MESSAGE_LETO_AUTOPORTAL:
            Message=ColourString("Changes need to be made to your character; you are about to be teleported in: "+VariableText + " seconds." +"cä");
            break;
        case MESSAGE_LETO_AUTOBOOT:
            Message=ColourString("You will be automatically booted in: " + VariableText + " seconds.", "cä");
            break;
        case MESSAGE_LETO_DONT_PANIC_JUSTPORTING:
            Message=ColourString("Changes need to be made to your character; You are about to undergo an area transition... don't worry you should end up right where you are.","cä");
            break;
        case MESSAGE_LETO_PLEASE_RELOG:
            Message="Changes need to be made to your character; Please re-log into the sever.";
            break;
        case MESSAGE_SUBRACE_PURGING:
            Message="Purging sub-race...";
            break;
        case MESSAGE_SUBRACE_PURGED:
            Message="Purging sub-race...DONE.";
            break;
        case MESSAGE_SUBRACE_SPELL_RESISTANCE_APPLIED:
            Message="Your spell resistance has been modified to fit your "+ SUBRACE_WHEN_ADJECTIVE +" features.";
            break;
        case MESSAGE_ABILITY_SCORES_REVERTED:
            Message="Your day/night ability scores have been reverted.";
            break;
        case MESSAGE_ABILITY_SCORES_CHANGED:
            Message="Your day/night ability scores have changed...";
            break;
        case MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_REVERTED:
            Message="Your special appearance ability scores have been reverted.";
            break;
        case MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_CHANGED:
            Message="Your special appearance scores have changed...";
            break;
        case MESSAGE_SUBRACE_CANNOT_EQUIP_ITEM:
            Message="You cannot equip this " +VariableText +" because of your "+SUBRACE_WHEN_NOUN+"'s limitations.";
            break;
        case MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS:
            Message="Checking whether your character meets the requirements for the '" + VariableText + "' "+SUBRACE_WHEN_NOUN+"...";
            break;
        case MESSAGE_SUBRACE_FAILED_REQUIREMENTS_ALIGNMENT_FOR_SWITCH:
            Message="Your character has failed to meet criteria for the '" + VariableText + "' " + SUBRACE_WHEN_NOUN;
            break;
        case MESSAGE_SUBRACE_SWITCHING:
            Message="Switching sub-races to: " + VariableText;
            break;
        case MESSAGE_SUBRACE_SWITCHED:
            Message="Sub-race was switched!";
            break;
        case MESSAGE_SUBRACE_FACTION_ADJUSTED:
            Message="Your faction has been adjusted to fit your "+SUBRACE_WHEN_NOUN+".";
            break;
        case MESSAGE_SUBRACE_MOVE_TO_START_LOCATION:
            Message="Welcome to " + VariableText + " " +SUBRACE_WHEN_NOUN +"'s start location.";
            break;
        case MESSAGE_SUBRACE_NEW_WINGS_GAINED:
            Message="You have gained new wings.";
            break;
        case MESSAGE_SUBRACE_NEW_TAIL_GAINED:
            Message="You have gained a new tail";
            break;
        case MESSAGE_SUBRACE_NEW_PORTRAIT_GAINED:
            Message="Your character portrait has changed";
            break;
        case MESSAGE_SUBRACE_SSE_IS_SHUTDOWN:
            Message="Subrace Engine has been switched off by a DM. Your " + SUBRACE_WHEN_NOUN + " will not function.";
            break;
        case MESSAGE_SUBRACE_SSE_IS_SHUTDOWN_IN_AREA:
            Message="Subrace Engine is switched off in this area.";
            break;
        case MESSAGE_SUBRACE_APPEARANCE_DATA_ERROR:
            Message="Appearance data error! Re-login to fix this problem.";
            break;
        case MESSAGE_SUBRACE_GENDER_FAILED:
            Message="You have not met the gender requirements for the chosen " + SUBRACE_WHEN_NOUN + ".";
            break;
        case MESSAGE_SUBRACE_FAILED_CRITERIA_SO_REMOVED:
            Message="Your " + SUBRACE_WHEN_NOUN + " has been removed because you did not meet the criteria(s).";
            break;
        case MESSAGE_SUBRACE_ALIAS_UNIFORMIZING:
            Message=VariableText + " is an alias for " + VariableText2 + ". Uniformizing.";
            break;
        case MESSAGE_SUBRACE_ALIAS_DIVERSITY:
            Message="Alias detected, using: " + VariableText + "'s properties.";
            break;
        case MESSAGE_MODLOAD_NOT_COMPLETE:
            Message="Waiting for Module to load subraces...";
            break;
        case MESSAGE_USER_MADE:
            Message=VariableText + VariableText2;
            break;
    }
    return Message;
}


int GetPlayerSubraceID(object Player)
{
    return GetSubraceID(GetSubRace(Player));
}

//Subrace Default Heartbeat. (For use in default.nss)
//
//Version 2.7 Alpha: Much improved version of the heartbeat.
//                   Some of the weights of the checks and things are taken off
//                   the script by an external timer object that triggers during
//                   day night transition.
//
//            Added: SubraceStorage + "_" + SUBRACE_HAS_DAY_NIGHT_EFFECTS -- an int
//                   that stores TRUE if the subrace has temporary stats or
//                   has light sensitivity, damaged by light etc (IE: Like Drow or Vampire)
//
//--- These should reduce the weight on the CPU significantly.
void SubraceHeartbeat(object oPC = OBJECT_SELF)
{
    if(GetLocalInt(oPC, "LOAD_SUBRACE"))
    {
       if(!GetSSEStatus(GetArea(oPC)) )
       {
           DelayCommand(1.0, InitiateSubraceChecking(oPC));
           DeleteLocalInt(oPC, "LOAD_SUBRACE");
       }
       return;
    }
    int ID = GetPlayerSubraceID(oPC);
    if(!ID || !GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC))
    { return; }
    object oArea = GetArea(oPC);
    if(GetSSEStatus(oArea))
    {
         return;
    }
    string SubraceStorage = GetSubraceStorageLocationByID(ID);
    if(GetSSEInt( SubraceStorage + "_" + SUBRACE_HAS_DAY_NIGHT_EFFECTS))
    {
        int iTime = SHA_GetCurrentTime();
        int AreaLocation = GetIsAreaAboveGround(oArea);
        int Interior = GetIsAreaInterior(oArea);
        int Natural = GetIsAreaNatural(oArea);
        int HasDiffStats = GetSSEInt( SubraceStorage + "_" + SUBRACE_STAT_MODIFIERS);
        if(HasDiffStats > 0)
        {
             ApplyTemporarySubraceStats(oPC, SubraceStorage, iTime, AreaLocation, Interior, Natural);
        }

        if(GetSubRace(oPC) == "Elf-wood"){
            if(GetIsAreaAboveGround(oArea) && GetIsAreaNatural(oArea)
                && !GetHasSpellEffect(TASPELL_WOODELF_CONCEAL, oPC))
            {
                int nConceal = 10 + GetSkillRank(SKILL_HIDE, oPC, TRUE);
                if(nConceal > 60) nConceal = 60;
                effect eConceal = EffectConcealment(nConceal);
                eConceal = SupernaturalEffect(eConceal);
                SetEffectSpellId(eConceal, TASPELL_WOODELF_CONCEAL);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oPC);
            }
            else if(GetHasSpellEffect(TASPELL_WOODELF_CONCEAL, oPC)
                    && !GetIsAreaAboveGround(oArea) && !GetIsAreaNatural(oArea)){
                RemoveEffectsOfSpells(oPC, TASPELL_WOODELF_CONCEAL);
            }
        }
        if(iTime == TIME_DAY)
        {
           if(AreaLocation == AREA_ABOVEGROUND && !Interior)
           {
              int IsLightSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
              int DmgTakenL = GetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_LIGHT);
              if(IsLightSens)
              {
                  ApplyLightSensitivity(oPC);
              }
              if(DmgTakenL)
              {
                  ApplyDamageWhileInLight(oPC, DmgTakenL);
              }
           }
           else if(AreaLocation == AREA_UNDERGROUND)
           {
              int IsUndergSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
              int DmgTakenU = GetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);

              if(IsUndergSens)
              {
                 ApplyUndergroundSensitivity(oPC);
              }
              if(DmgTakenU)
              {
                ApplyDamageWhileInDark(oPC, DmgTakenU);
              }
           }
      }
      else if(iTime == TIME_NIGHT)
      {
          if(AreaLocation == AREA_UNDERGROUND)
          {
              int IsUndergSens = GetLocalGroupFlag(oStorer, SubraceStorage + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
              int DmgTakenU = GetSSEInt( SubraceStorage + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);
              if(IsUndergSens)
              {
                 ApplyUndergroundSensitivity(oPC);
              }
              if(DmgTakenU)
              {
                 ApplyDamageWhileInDark(oPC, DmgTakenU);
              }
          }
       }
   }
}
