//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::File Name: sha_subr_consts ::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: include script :::::::::::::::::::::::::::::::::::::::::
//:: Written by: Shayan, Moon                                               :://
//:: Contact: mail_shayan@yhaoo.com                                         :://
//:: Forums: http://p2.forumforfree.com/shayan.html
//
// Description: Holds all the constants used in the Subrace System.
//              If you have made a change you must recompile all scripts for
//              changes to take place.

#include "_flagsets_inc"

//::--------------------------------------------------------------------------::
//----------------------- Subrace Engine LETO Settings -------------------------
//::::::::---------------------------------------------------------:::::::::::::
/*
//:: Set to TRUE to enable LETO functions.
const int ENABLE_LETO = FALSE;

//:: The path to your NWN folder:
//:: Example: C:/NeverwinterNights/NWN/
const string NWNPATH = "C:/NeverwinterNights/NWN/";

// :: If set to TRUE then players will not have to re-login to the server manually...
// :: it would be a seemless transistion.
const int LETO_ACTIVATE_PORTAL = TRUE;

//****---- You MUST fill in these settings if LETO_ACTIVATE_PORTAL to TRUE -----****

// :: The IP address of your server.
// :: Example: "192.168.0.100:5121"
const string LETO_PORTAL_IP_ADDRESS = "10.1.1.2:5121";

// :: The server's log-in password for the player:
const string LETO_PORAL_SERVER_PASSWORD = "";

// :: If this is set to TRUE, then the character isn't teleported to a different area
// :: instead just will have a superfical area transistion and will end up in the same area
// :: as he/she was in. And will have undergone all the LETO changes necessary.
const int LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE = TRUE;

// :: Number of seconds to wait porting the player.
const int LETO_AUTOMATIC_PORTAL_DELAY = 10;

// :: (You need not fill this is  LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE is set to TRUE)
// :: This is the tag of the waypoint the player 'teleports' to.
// :: The waypoint's tag must be in Captial letters (uppercase letters) for it to work!
// :: Example: "PORTAL_WAYPOINT";
// :: Naming it "portal_waypoint" will NOT work!
const string LETO_PORTAL_WAYPOINT = "PORTAL_WAYPOINT";


//****--------------------------------------------------------------------------****

//****---- Ignore these settings if you have set LETO_ACTIVATE_PORTAL to TRUE -----***
// :: Since Leto needs to make changes to the character file, it cannot do it while the PC
// :: is logged in. There fore the player must log out. The Subrace engine will give a message to the player
// :: but if this is set to TRUE, it will also boot the player from the server in LETO_AUTOMATIC_BOOT_DELAY.
const int LETO_AUTOMATICALLY_BOOT = FALSE;

// :: If you have set to automatic boot, then how long (in seconds) do you want to
// :: wait before kicking the player?
const int LETO_AUTOMATIC_BOOT_DELAY = 20;
//------------------------------------------------------------------------------


// :: Set this to TRUE if you want to use localvault characters instead of servervault.
// :: Use it only if you are using the Subrace Engine's Leto features for single player purposes.
// :: THIS WILL NOT ALWAYS WORK ON A SERVER RUNNING WITH LOCAL VAULT CHARACTERS ENABLED,
// :: AS PLAYERS' NWN INSTALLATION DIRECTORY MAY VARY.
const int USE_LOCAL_VAULT_CHARACTERS = FALSE;
*/

//--------------------------------------------------------------------------------------------
//::::::::::::::::::::::::::::::: Engine Wide Settings :::::::::::::::::::::::::::::::::::::::
//--------------------------------------------------------------------------------------------
//:: The following list of constants are responsible for what I call "Engine Wide settings".
//:: What this means is that these constants control specific settings that apply to ALL the
//:: subraces. IE: The saving throw DC for light sensitivity, etc.
//:: You may change them as you will.
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

const string SUBRACE_ENGINE_VERSION = "Starry Night 3.0.6.9";

// :: Engine Name. (It will preceed any sub-race message sent to a player)
// :: '<cÜ>' Is a green color.
const string SUBRACE_ENGINE = "<cÜ>Shayan's Subrace Engine: </c>";

// :: This is what SSE will call sub-races ("sub-race" or "clan" etc.). Use lowercase characters
// :: Do NOT prefix with "the" or add any surfixes! (e.g. NOT "the sub-races" but "sub-race")
const string SUBRACE_WHEN_NOUN = "sub-race";

// :: This is what SSE will call sub-races when used as adjectives ("[sub-]racial"). Use lowercase characters
const string SUBRACE_WHEN_ADJECTIVE = "sub-racial";

// :: Highest Level achievable by a player in this module
// :: Default value: 40
const int MAXIMUM_PLAYER_LEVEL = 40;

// :: If set to TRUE it will use SQL NWNX databases.
// :: NWNX must be installed for this to work! Refer to sha_subr_methds for more
// :: details.
const int ENABLE_NWNX_DATABASE = TRUE;

// :: If different from "", SSE will add this script as a spellhook during
// ::   the OnModLoad event.
// :: DISABLE THIS IF YOU DO NOT USE SPELLHOOKS! (e.g. did not import it.)
// :: To disable, use ""
const string SUBRACE_SPELLHOOKS = "";

// :: Name of the Subrace Database.
// :: Default Value: SUBRACE_DB
const string SUBRACE_DATABASE = "SUBRACE_DB";

// :: String stored in the SUBRACE_DATABASE to indicate that changes to character file
// :: have already been done.
const string LETO_CHANGES_MADE_FOR_THIS_LEVEL = "LTO_D";

//:: An internal tag used as starting name of the Local <Strings, Int and Float>
//:: stored on the PC/Storer.
//:: Default Value: SBRCE
const string SUBRACE_TAG = "SBRCE";

//:: Sometimes (very rarely) data corruption occurs during gameplay. For whatever reason NWN might not
//:: apply subrace stats or some subrace feature goes "missing".
//:: Set this to TRUE only if you are running a persistent world
//:: and you wish to reload the subrace information again upon the PC's relogin so
//:: your players' character can get their subrace reapplied on relog.
//:: NOTE: This may lead to necessary burden on the CPU.
const int RELOAD_SUBRACE_INFORMATION_UPON_RELOGIN = FALSE;

// :: Too many subrace related messages going to the PC is not always a good thing...
// :: Set this to TRUE if you want to reduce the number of messages recieved by the players
// :: to just the important ones.
// :: !!Obsolete!!
const int MINIMALISE_SUBRACE_MESSAGES_TO_PC = FALSE;

// :: A server running with 'Enforce Legal Characters' automatically destroys creature
// :: skins on PC when they log out. The Subrace Engine does reload information, and skin
// :: on re-entry. But if the PC can't equip the skin (IE: Is paralysed or stunned on entry) then
// :: the skin ends up in their inventory.
// :: Set this value to TRUE if you want the Engine to automatically search PC's inventory
// :: and destroy those skins.
// :: Default Value: TRUE
const int SEARCH_AND_DESTROY_SKINS_IN_INVENTORY = FALSE;

// :: Does spell resistance gained from being part of the subrace, stack with PC's
// :: existing spell resistance? (IE: Like Monk Spell resistance or spell resistance
// :: gained from items, etc)
// :: Default Value: FALSE
const int SUBRACE_SPELL_RESISTANCE_STACKS = FALSE;

// :: Set this to TRUE if you want the XP system to ignore NWN's default favored class
// :: for a particular race.
// :: IE: Say you have sub-race of Elves called Myra'therendi...
//        And the sub-race's (Myra'therendi's) favored Class is: Sorcerer.
//        Now imagine there was a PC -call him A- part of that sub-race: Wizard(10)/Figher(5)
//           and another PC -call him B- who is also part of that sub-race: Socerer(9)/Cleric(6).
//        Since Elves defaultly have Wizard as their favored Class, with
//        SUBRACE_IGNORE_BASE_RACE_FAVORED_CLASS set to FALSE, PC A will not incur a multiclassing
//        XP penalty. While SUBRACE_IGNORE_BASE_RACE_FAVORED_CLASS set to TRUE, PC A will
//        incur the 20% reduction in XP for multiclassing... while PC B will not.
// :: Default Value: TRUE
const int SUBRACE_IGNORE_BASE_RACE_FAVORED_CLASS = TRUE;

// :: Set this to TRUE if you want the PC to scream when their appearance is changing...
// :: Like "AAAARGH! What is happening to me?!", when they 'morph'. (Look below)
const int PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE = TRUE;

// :: If the PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE, then what does it scream?
// :: (When changing from default racial appearance to the "monster" appearance.)
const string SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_MONSTER = "AARGH! What is happening to me?!";

// :: (When changing from "monster" appearance to the default racial appearance.)
const string SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_DEFAULT_RACIAL_TYPE = "AARGH!!";

// :: Set to TRUE if you want to disable the visual effects when changing from one
// :: appearance to another.
const int DISABLE_VISUAL_EFFECTS_WHEN_CHANGING_IN_APPEARANCE = FALSE;

// :: Set to TRUE if you want Light sensitive subraces to also get a chance of being
// :: Blinded by light when in open outdoor areas, suring day time.
const int APPLY_LIGHT_BLINDNESS = FALSE;

// :: Does the spell Darkness stop Light sensitivity and Light Damage from being
// :: applied to the PC?
// :: Default Value: TRUE
const int SPELL_DARKNESS_STOPS_LIGHT_SENSITIVITY = TRUE;

// :: The Difficulty Check for Light sensitivity. All subraces with Light sensitivity will
// :: have to make a save against this DC or be blinded when in above ground outdoor areas, during daylight.
// :: (It is a Fortitude Saving throw)
// :: Default Value: 20
const int LIGHT_SENSITIVE_SAVING_THROW_DC = 20;

// :: How often do you want the PC to be potentially be blinded by 'light' while in
// :: above ground outdoor areas, during daylight?
// :: (How often does the PC have to save against the blindness?)
// :: Default Value: Once every 6 rounds.
const int LIGHT_BLINDNESS_STRIKES_EVERY_ROUND = 6;

// :: If the PC fails the saving throw, how long do you want the blindness to last?
// :: Default Value: 1
const int LIGHT_STRUCK_BLIND_FOR_ROUNDS = 1;

// :: Set to TRUE if you want Light sensitive subraces to also get an attack bonus,
// :: and saving throw decrease, when in light areas.
// :: (They automatically get the penalty when in Sunlight. They do not have to fail a
// ::  saving throw.)
const int APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT = TRUE;

// :: Set this to true if you want sub-races that get light damaged to also
// :: "spontaneously" (SUBRACE_SPONTANEOUS_COMBUSTION_PERCENTAGE chance every LIGHT_DAMAGES_EVERY_ROUNDS) to combust
// :: and take d8() fire damage for the number of LIGHT_DAMAGES_EVERY_ROUNDS rounds.
// :: Default value: FALSE.
const int SUBRACE_SPONTANEOUS_COMBUSTION_WHILE_IN_LIGHT = FALSE;

// :: If SUBRACE_SPONTANEOUS_COMBUSTION_WHILE_IN_LIGHT, then
// :: what is the chance that they will catch on fire once every LIGHT_DAMAGES_EVERY_ROUNDS rounds
// :: Default value: 10%.
const int SUBRACE_SPONTANEOUS_COMBUSTION_PERCENTAGE = 10;

// :: If the PC is failed to roll... then what is the DC she/he must roll against to
// :: save?  (It is a reflex saving throw)
// :: Default Value: 20
const int SUBRACE_SPONTANEOUSLY_COMBUST_DC = 20;

// :: The amount of which the PC's attack bonus is decreased by.
const int LIGHT_AB_DECREASE = 2;

// :: The amount of which the PC's saving throws are decreased by.
const int LIGHT_SAVE_DECREASE = 2;

// :: If you have APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT to TRUE then, how long does the
// :: decreases last?
// :: Remember every LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS, the decreases are applied again.
// :: If the PC is in the sun. (The decreases do not stack)
const int LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS = 4;

// :: The Difficulty check for Dark sensitivity. All subraces with Dark sensitivity will
// :: have to make a save against this DC or be blinded when in Underground areas.
// :: (It is a Fortitude Saving throw)
// :: Default Value: 20
const int DARK_SENSITIVE_SAVING_THROW_DC = 20;

// :: How often do you want the PC to be potentially be blinded by 'dark' while
// :: in Underground areas?
// :: (How often does the PC have to save against the blindness)
// :: Default Value: Once every 6 rounds.
const int DARK_BLINDNESS_STRIKES_EVERY_ROUND = 6;

// :: If the PC fails the saving throw, how long do you want the blindness to last?
// :: Default Value: 1
const int DARK_STRUCK_BLIND_FOR_ROUNDS = 1;

// :: How often does Light Damage the PC when in above ground outdoor areas,
// :: during daylight?
// :: Default Value: Once every 1 Round(s).
const int LIGHT_DAMAGES_EVERY_ROUNDS = 1;

// :: How often does Darkness damage the PC when in Underground?
// :: Default Value: Once every 1 Round(s).
const int DARKNESS_DAMAGES_EVERY_ROUNDS = 1;

// :: Determines how SSE handles aliases.
// :: Setting this to:
// ::   0 will make SSE uniformize aliases into the "correct" subrace name.
// ::   1 will make SSE keep the diversity in the subrace fields.
// ::   2 will make SSE register aliases, so SWand (or similar) can find them.
// ::   3 counts as both 1 and 2.
// ::
// :: Default Value: 1 (Keep diversity)
const int SSE_TREAT_ALIAS_AS_SUBRACE = 0;

// :: Determines how SSE formats the names of sub-races
// :: Setting this to:
// ::   FALSE will make SSE store the name EXACTLY as you write it.
// ::   TRUE will make SSE format the names (First character capitilized, rest lowercase)
// ::
// :: Default Value: TRUE (Auto Format)
const int SSE_AUTO_FORMAT_SUBRACE_NAMES=TRUE;

//3.0.6.5

// If TRUE, will send a subrace with no death waypoint to its subrace death,
// subrace start or module start. if waypoint tagged NW_DEATH_TEMPLE exists,
// the script aborts.

// Set USE_SSE_DEATH_RESPAWN FALSE if using afterlife area with an entry waypoint
// NW_DEATH_TEMPLE and subrace respawn placable for Multiplayer Servers,
// if no NW_DEATH_TEMPLE then uses death/start waypoints or module start.

// Set USE_SSE_DEATH_RESPAWN = TRUE for single player modules without afterlife
// Set USE_SSE_DEATH_RESPAWN = FALSE for online modules using afterlife object
    const int USE_SSE_DEATH_RESPAWN = FALSE;

// If TRUE, sends a PC with no death waypoint to it's subrace start
// If FALSE, sends PC to module start
    const int USE_SSE_DEATH_DEFAULT_TO_SUBRACE_START = TRUE;

// Apply default subraces to PCs with blank subraces as per DMG 3.5
    const int USE_SSE_DEFAULT_RACES = TRUE;

    const string SUBRACE_DWARF_DEFAULT     = "Dwarf";
    const string SUBRACE_ELF_DEFAULT       = "Elf";
    const string SUBRACE_GNOME_DEFAULT     = "Gnome";
    const string SUBRACE_HALFELF_DEFAULT   = "Half-Elf";
    const string SUBRACE_HALFLING_DEFAULT  = "Halfling";
    const string SUBRACE_HALFORC_DEFAULT   = "Half-Orc";
    const string SUBRACE_HUMAN_DEFAULT     = "Human";
//3.0.6.4
    const string SUBRACE_DEATH_DEFAULT  = "";
// 3.0.6.2
    const int   USE_SSE_CLOCK_HEARTBEATS = TRUE;

// :: Messages sent out by the Subrace Engine ::

const int MESSAGE_TYPE_DEFAULT = 0;
const int MESSAGE_TYPE_VITAL = 0x40000000;
const int MESSAGE_TYPE_LOG = 0x20000000;
const int MESSAGE_TYPE_ERROR = 0x10000000;
const int MESSAGE_TYPE_REQUIREMENT = 0x08000000;
const int MESSAGE_TYPE_CHARACTER_NON_LETO_MODIFICATION = 0x04000000;
const int MESSAGE_TYPE_CHARACTER_LETO_MODIFICATION = 0x02000000;
const int MESSAGE_TYPE_CHARACTER_APPEARANCE_MODIFICATION = 0x01000000;
const int MESSAGE_TYPE_CHARACTER_ITEM = 0x00800000;
const int MESSAGE_TYPE_SUBRACE_CHANGE = 0x00400000;
const int MESSAGE_TYPE_SSE_ENGINE_STATUS = 0x00200000;
const int MESSAGE_TYPE_SUBRACE_ALIAS = 0x00100000;
const int MESSAGE_TYPE_SERVER_DEFAULT = 0xFFFF0000;

const int MESSAGE_HANDLER_GET_MESSAGE = 0x000000FF;
const int MESSAGE_HANDLER_GET_MESSAGE_TYPE = 0xFFFFFF00;

const int MESSAGE_SUBRACE_APPEARANCE_CHANGED = 0x01000001;
const int MESSAGE_SUBRACE_APPEARANCE_REVERTED = 0x01000002;
const int MESSAGE_SUBRACE_CRITERIA_FAILED = 0x08000003;
const int MESSAGE_CANNOT_BE_PART_OF_PRESTIGIOUS_SUBRACE = 0x08000004;
const int MESSAGE_FAILED_TO_MEET_PRESTIGIOUS_CLASS_RESTRICTION = 0x08000005;
const int MESSAGE_SUBRACE_CRITERIA_MET = 0x08000006;
const int MESSAGE_SUBRACE_CRITERIA_CLASS_FAILED = 0x08000007;
const int MESSAGE_SUBRACE_CRITERIA_ALIGNMENT_FAILED = 0x08000008;
const int MESSAGE_SUBRACE_CRITERIA_BASE_RACE_FAILED = 0x08000009;
const int MESSAGE_SUBRACE_UNRECOGNISED = 0x1000000A;
const int MESSAGE_SUBRACE_CLAWS_WAIT_FOR_CLAWS_EQUIPPING = 0x0080000B;
const int MESSAGE_SUBRACE_CLAWS_MISSING_CREATURE_WEAPON_PROFICIENCY = 0x1000000C;
const int MESSAGE_SUBRACE_CLAWS_SUCCESSFULLY_EQUIPPED = 0x0080000D;
const int MESSAGE_SUBRACE_ACQUIRED_UNIQUE_ITEM = 0x0080000E;
const int MESSAGE_SUBRACE_EFFECTS_APPLIED = 0x0400000F;
const int MESSAGE_SUBRACE_IS_MISSING_FROM_SERVER = 0x10000010;
const int MESSAGE_SUBRACE_LOADING_DATA = 0x00400011;
const int MESSAGE_SUBRACE_DATA_LOADED = 0x00400012;
const int MESSAGE_LETO_AUTOPORTAL = 0x42000013;
const int MESSAGE_LETO_AUTOBOOT = 0x42000014;
const int MESSAGE_LETO_DONT_PANIC_JUSTPORTING = 0x40000015;
const int MESSAGE_LETO_PLEASE_RELOG = 0x42000016;
const int MESSAGE_SUBRACE_PURGING =  0x00400017;
const int MESSAGE_SUBRACE_PURGED = 0x00400018;
const int MESSAGE_SUBRACE_SPELL_RESISTANCE_APPLIED = 0x04000019;
const int MESSAGE_ABILITY_SCORES_REVERTED = 0x0400001A;
const int MESSAGE_ABILITY_SCORES_CHANGED =  0x0400001B;
const int MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_REVERTED = 0x0100001C;
const int MESSAGE_ABILITY_SCORES_APPEARANCE_TRIGGERED_CHANGED =  0x0100001D;
const int MESSAGE_SUBRACE_CANNOT_EQUIP_ITEM = 0x4000001E;
const int MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS = 0x0800001F;
const int MESSAGE_SUBRACE_FAILED_REQUIREMENTS_ALIGNMENT_FOR_SWITCH = 0x08000020;
const int MESSAGE_SUBRACE_SWITCHING = 0x00400021;
const int MESSAGE_SUBRACE_SWITCHED = 0x00400022;
const int MESSAGE_SUBRACE_FACTION_ADJUSTED = 0x00400023;
const int MESSAGE_SUBRACE_MOVE_TO_START_LOCATION = 0x00400024;
const int MESSAGE_SUBRACE_NEW_WINGS_GAINED = 0x01000025;
const int MESSAGE_SUBRACE_NEW_TAIL_GAINED = 0x01000026;
const int MESSAGE_SUBRACE_NEW_PORTRAIT_GAINED = 0x01000027;
const int MESSAGE_SUBRACE_SSE_IS_SHUTDOWN = 0x00200028;
const int MESSAGE_SUBRACE_SSE_IS_SHUTDOWN_IN_AREA = 0x00200029;
const int MESSAGE_SUBRACE_APPEARANCE_DATA_ERROR = 0x1010002A;
const int MESSAGE_SUBRACE_GENDER_FAILED = 0x0800002B;
const int MESSAGE_SUBRACE_FAILED_CRITERIA_SO_REMOVED = 0x4040002C;
const int MESSAGE_SUBRACE_ALIAS_UNIFORMIZING = 0x0010002D;
const int MESSAGE_SUBRACE_ALIAS_DIVERSITY = 0x0010002E;
const int MESSAGE_SUBRACE_CRITERIA_SPECIAL_RESTRICTION_FAILED = 0x0800002F;
const int MESSAGE_MODLOAD_NOT_COMPLETE = 0x00200030;
const int MESSAGE_USER_MADE = 0x000000FF;

const string MESSAGE_DISPLAY_CONTROL = "MSG_DIS_CON";


// :: XP CONSTANTS --- DO NOT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING.
// :: These constants taken from xptable.2da
const float BASE_XP = 32.5;

const float XP_LEVEL1 = 5.0;
const float XP_LEVEL2 = 10.0;
const float XP_LEVEL3 = 15.0;
const float XP_LEVEL4 = 17.0;
const float XP_LEVEL5 = 20.0;
const float XP_LEVEL6 = 22.5;
const float XP_LEVEL7 = 25.0;
const float XP_LEVEL8 = 27.5;

const float XP_LEVEL_8 = -32.1;
const float XP_LEVEL_7 = -30.5;
const float XP_LEVEL_6 = -28.5;
const float XP_LEVEL_5 = -27.5;
const float XP_LEVEL_4 = -20.0;
const float XP_LEVEL_3 = -15.0;
const float XP_LEVEL_2 = -10.0;
const float XP_LEVEL_1 = -5.0;


//The following list of constants control the internal settings of the engine.
//Do not change unless you are sure of what you are doing. If you change the values
//you may find the some information will not get stored on a player character....
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::DO NOT CHANGE UNLESS NECESSARY::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::

const int SUBRACE_EFFECT_VALUE1_FLAGSET =  LARGEGROUP1;
const int SUBRACE_EFFECT_VALUE2_FLAGSET =  LARGEGROUP2;
const int SUBRACE_EFFECT_FLAGSET =  LARGEGROUP3;
const int SUBRACE_EFFECT_TIME_FLAGSET = LARGEGROUPX;

const int SSE_STATUS_OPERATIONAL = NOFLAGS;
const int SSE_STATUS_SHUTDOWN = FLAG1;
const int SSE_STATUS_DISABLED_IN_AREA = FLAG2;

//TwentyOneScore's hair skin color constants

const string SUBRACE_COLORS_FLAGS = "SUB_CLR_FS";
const int SUBRACE_COLORS_FLAGS_SKIN_MALE = MEDIUMGROUP1;
const int SUBRACE_COLORS_FLAGS_SKIN_FEMALE = MEDIUMGROUP2;
const int SUBRACE_COLORS_FLAGS_HAIR_MALE = MEDIUMGROUP3;
const int SUBRACE_COLORS_FLAGS_HAIR_FEMALE = MEDIUMGROUP4;
const int SUBRACE_COLORS_FLAGS_SKIN = MEDIUMGROUP1;
const int SUBRACE_COLORS_FLAGS_HAIR = MEDIUMGROUP2;

//3.0.6.9 - Head constants

const string SUBRACE_HEAD_FLAGS = "SUB_HEAD";
const int SUBRACE_HEAD_FLAGS_MALE = MEDIUMGROUP1;
const int SUBRACE_HEAD_FLAGS_FEMALE = MEDIUMGROUP2;

//3.0.6.6 - Eye color constants

const string SUBRACE_EYE_COLORS_FLAGS = "SUB_CLR_EYE";
const int SUBRACE_EYE_COLORS_FLAGS_MALE = MEDIUMGROUP1;
const int SUBRACE_EYE_COLORS_FLAGS_FEMALE = MEDIUMGROUP2;
const int SUBRACE_EYE_COLOR_CYAN = 1;
const int SUBRACE_EYE_COLOR_GREEN = 2;
const int SUBRACE_EYE_COLOR_ORANGE = 3;
const int SUBRACE_EYE_COLOR_PURPLE = 4;
const int SUBRACE_EYE_COLOR_RED = 5;
const int SUBRACE_EYE_COLOR_WHITE = 6;
const int SUBRACE_EYE_COLOR_YELLOW = 7;

const string SUBRACE_ALIGNMENT_RESTRICTION = "ALN_RS";

const string MODULE_SUBRACE_COUNT = "SBR_COUNT";

const string MODULE_SUBRACE_NUMBER = "SBR_NUM";

const int SUBRACE_BASE_RACE_FLAGS = MEDIUMGROUP1;

const string SUBRACE_BASE_RACE = "BASE_RACE";

const string SUBRACE_SKIN = "SKN";

const string SUBRACE_RIGHT_CLAW = "RCLAW";

const string SUBRACE_LEFT_CLAW = "LCLAW";

const string SUBRACE_UNIQUEITEM = "UITEM";
const string SUBRACE_UNIQUEITEM_COUNT = "UITEM_C";

const string SUBRACE_BASE_INFORMATION = "SUB_BIN";

const int SUBRACE_BASE_INFORMATION_FLAGS = TINYGROUP1;
const int SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE = FLAG1;
const int SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE = FLAG2;
const int SUBRACE_BASE_INFORMATION_UNDEAD = FLAG3;
const int SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE = FLAG4;
const int SUBRACE_BASE_INFORMATION_ECL = TINYGROUP2;

const string SUBRACE_HAS_DAY_NIGHT_EFFECTS = "S_DAYNIGHT";
const string DAMAGE_AMOUNT_IN_LIGHT = "DMG_IN_LGHT";
const string DAMAGE_AMOUNT_IN_UNDERGROUND = "DMG_IN_UNDG";

const string SUBRACE_SPELL_RESISTANCE = "SPELL_RES";
const int SUBRACE_SPELL_RESISTANCE_BASE_FLAGS = MEDIUMGROUP1;
const int SUBRACE_SPELL_RESISTANCE_MAX_FLAGS = MEDIUMGROUP2;

const string APPEARANCE_DEFAULT_APPEARANCE = "CRE_DEF";

const string APPEARANCE_CHANGE = "CRE_APP";
const string APPEARANCE_TO_CHANGE = "CRE_APP_X";
const int APPEARANCE_CHANGE_MALE_FLAG = HUGEGROUP1;
const int APPEARANCE_CHANGE_FEMALE_FLAG = HUGEGROUP2;
const int APPEARANCE_CHANGE_APPEARANCE_FLAG = HUGEGROUP1;

const string SUBRACE_IN_SPELL_DARKNESS = "SBR_DARKNESS";

const string SUBRACE_ECL = "S_ECL";


const string SUBRACE_FAVORED_CLASS = "FAV_CLSS";
const int SUBRACE_FAVORED_CLASS_MALE_FLAG = MEDIUMGROUP1;
const int SUBRACE_FAVORED_CLASS_FEMALE_FLAG = MEDIUMGROUP2;

const int TIME_FLAGS =  TINYGROUP1;

const int TIME_DAY = FLAG1;
const int TIME_NIGHT = FLAG2;
const int TIME_NONE = 4;
const int TIME_BOTH = 3;

const int TIME_SPECIAL_APPEARANCE_SUBRACE = FLAG10;
const int TIME_SPECIAL_APPEARANCE_NORMAL = FLAG11;

const int CLASS_TYPE_ANY = 78;
const int CLASS_TYPE_NONE = 79;

const int SUBRACE_XP_BOOST = 98;
const int SUBRACE_XP_DECREASE = 99;
const int SUBRACE_XP_UNCHANGED = 100;

const int SUBRACE_ACCEPTED = 11;
const int SUBRACE_REJECTED = 12;
const int SUBRACE_UNINITIALIZED = FALSE;
const int SUBRACE_UNRECOGNISED = 15;

const string SUBRACE_INFO_LOADED_ON_PC = "SRCE_INIT";
const string SUBRACE_INFO_LOADED_ON_MODULE = "SRCE_MMML";
const string SUBRACE_UNCHANGEABLE_INFO_LOADED_ON_PC = "SBRCE_IMP_INFO";

const string SUBRACE_CLASS_RESTRICTION = "CLASS_RES";
const string SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION = "P_CLASS_RES";
const string SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION_MINIMUM_LEVELS = "P_CLASS_RES_ML";

const string SUBRACE_STATS_STATUS = "BNS_STAT_S";
const int SUBRACE_DAY_STATS_APPLIED = FLAG1;
const int SUBRACE_NIGHT_STATS_APPLIED = FLAG2;
const int SUBRACE_SPECIAL_STATS_APPEARANCE_SUBRACE_APPLIED = FLAG3;
const int SUBRACE_SPECIAL_STATS_APPEARANCE_NORMAL_APPLIED = FLAG4;

const int SUBRACE_SPECIAL_RESTRICTION_TYPE_DATABASE = 0x30000000;
const int SUBRACE_SPECIAL_RESTRICTION_TYPE_LOCAL_VAR = 0x20000000;
const int SUBRACE_SPECIAL_RESTRICTION_TYPE_ITEM = 0x10000000;
//const int SUBRACE_SPECIAL_RESTRICTION_TYPE_LEVEL = 0x10000000;
const int SUBRACE_SPECIAL_RESTRICTION_TYPE_ALL = 0xF0000000;

const string SUBRACE_SPECIAL_RESTRICTION = "SPEC_RESTRICT";
const string SUBRACE_SPECIAL_RESTRICTION_VARNAME = "VAR";
const string SUBRACE_SPECIAL_RESTRICTION_DATABASE = "DB";

const string SUBRACE_EFFECT = "SUB_EFF";
const string SUBRACE_EFFECT_COUNT = "SUB_EFF_C";
const string SUBRACE_EFFECT_VALUE_1 = "SUB_EFFV1";
const string SUBRACE_EFFECT_VALUE_2 = "SUB_EFFV2";
const string SUBRACE_EFFECT_DURATION_TYPE = "SUB_EFF_DT";
const string SUBRACE_EFFECT_DURATION = "SUB_EFF_DF";
const string SUBRACE_EFFECT_APPLY_TIME = "SUB_EFF_APT";

const string SUBRACE_STAT_STR_MODIFIER = "STR_MOD";
const string SUBRACE_STAT_DEX_MODIFIER = "DEX_MOD";
const string SUBRACE_STAT_CON_MODIFIER = "CON_MOD";
const string SUBRACE_STAT_WIS_MODIFIER = "WIS_MOD";
const string SUBRACE_STAT_INT_MODIFIER = "INT_MOD";
const string SUBRACE_STAT_CHA_MODIFIER = "CHA_MOD";

const string SUBRACE_STAT_AB_MODIFIER = "AB_MOD";
const string SUBRACE_STAT_AC_MODIFIER = "AC_MOD";

const string SUBRACE_STAT_MODIFIERS = "STT_MDS";
const string SUBRACE_STAT_MODIFIER_TYPE = "STT_MD_TYPE";

const int SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE = FLAG1;
const int SUBRACE_STAT_MODIFIER_TYPE_POINTS = FLAG2;

const string SUBRACE_ITEM_RESTRICTION = "I_RES";

const string SUBRACE_SWITCH_NAME = "SUB_SWCT";
const string SUBRACE_SWITCH_LEVEL = "SUB_SWCT_L";
const string SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS = "SUB_SWCT_R";

const string SUBRACE_ATTACHMENT_FLAGS = "SUB_ATT_FS";
const string SUBRACE_ATTACHMENT_FLAGS2 = "SUB_AT2_FS";

const int SUBRACE_ATTACHMENT_FLAGS_WINGS_MALE = HUGEGROUP1;
const int SUBRACE_ATTACHMENT_FLAGS_WINGS_FEMALE = HUGEGROUP2;
const int SUBRACE_ATTACHMENT_FLAGS_TAIL_MALE = HUGEGROUP1;
const int SUBRACE_ATTACHMENT_FLAGS_TAIL_FEMALE = HUGEGROUP2;

const int SUBRACE_ATTACHMENT_FLAGS_WINGS = MEDIUMGROUP1;
const int SUBRACE_ATTACHMENT_FLAGS_TAIL = MEDIUMGROUP3;

const string SUBRACE_HAS_BASE_STAT_MODIFIERS = "H_BSTAT_M";
const string SUBRACE_BASE_STAT_MODIFIERS_REPLACE = "H_BSTAT_R";
const string SUBRACE_BASE_STAT_STR_MODIFIER = "BSTR_MOD";
const string SUBRACE_BASE_STAT_DEX_MODIFIER = "BDEX_MOD";
const string SUBRACE_BASE_STAT_CON_MODIFIER = "BCON_MOD";
const string SUBRACE_BASE_STAT_WIS_MODIFIER = "BWIS_MOD";
const string SUBRACE_BASE_STAT_INT_MODIFIER = "BINT_MOD";
const string SUBRACE_BASE_STAT_CHA_MODIFIER = "BCHA_MOD";
//const string SUBRACE_BASE_STAT_HP_MODIFIER = "BHP_MOD";

const string SUBRACE_BASE_STAT_SPD_MODIFIER = "BSPD_MOD";

const string SUBRACE_BONUS_FEAT_FLAGS = "BFEATS";
const string SUBRACE_BONUS_FEAT_COUNT= "BFEAT_C";

//3.0.6 - Leto Feat Error Fix by Shayan, from forum
//Removed
//const int SUBRACE_BONUS_FEAT_FLAG = LARGEGROUP1;
//const int SUBRACE_BONUS_FEAT_REMOVE_FLAG = LARGEGROUP2;
//Added
const int SUBRACE_BONUS_FEAT_FLAG = HUGEGROUP1;
const int SUBRACE_BONUS_FEAT_REMOVE_FLAG = HUGEGROUP2;

const string SUBRACE_BONUS_SKILL_FLAGS = "BSKILLS";
const string SUBRACE_BONUS_SKILL_COUNT= "BSKILLS_C";
const int SUBRACE_BONUS_SKILL_FLAG = LARGEGROUP1;
const int SUBRACE_BONUS_SKILL_MODIFIER_FLAG = LARGEGROUP2;
const int SUBRACE_BONUS_SKILL_REMOVE_FLAG = LARGEGROUP3;

const string SUBRACE_PORTRAIT_MALE = "SPORT_M";
const string SUBRACE_PORTRAIT_FEMALE = "SPORT_F";
const string SUBRACE_PORTRAIT= "SPORT_P";

const string SUBRACE_SOUNDSET_FLAGS = "SSOUNDS";
const int SUBRACE_SOUNDSET_MALE_FLAG = LARGEGROUP1;
const int SUBRACE_SOUNDSET_FEMALE_FLAG = LARGEGROUP2;

const int MOVEMENT_SPEED_PC = 0;
const int MOVEMENT_SPEED_IMMOBILE = 1;
const int MOVEMENT_SPEED_VERY_SLOW = 2;
const int MOVEMENT_SPEED_SLOW = 3;
const int MOVEMENT_SPEED_NORMAL = 4;
const int MOVEMENT_SPEED_FAST = 5;
const int MOVEMENT_SPEED_VERY_FAST = 6;
const int MOVEMENT_SPEED_DEFAULT = 7;
const int MOVEMENT_SPEED_DMSPEED = 8;
const int MOVEMENT_SPEED_CURRENT = 9;

const int SUBRACE_FACTION_REPUTATION_FRIENDLY = 0;
const int SUBRACE_FACTION_REPUTATION_NEUTRAL = -50;
const int SUBRACE_FACTION_REPUTATION_HOSTILE = -100;

const string SUBRACE_FACTION_CREATURE = "S_FACC";
const string SUBRACE_FACTION_REPUTATION = "S_FACR";
const string SUBRACE_FACTION_COUNT = "S_FACCOU";

const string SUBRACE_START_LOCATION  = "S_SLOC";

/// 3.0.6.4
const string SUBRACE_DEATH_LOCATION  = "S_DLOC";

const string SUBRACE_GENDER_RES = "GEN_RES";

// 3.0.6
const int IP_CONST_HORSE_MENU_SSE = 40;

const int BASE_ITEM_LANCE_SSE = 92;
const int BASE_ITEM_TRUMPET_SSE = 93;
const int BASE_ITEM_MOONONASTICK_SSE = 94;

//Error constants
const int SUBRACE_ERROR_ALIGNMENT = FLAG1;
const int SUBRACE_ERROR_RACE = FLAG2;
const int SUBRACE_ERROR_CLASS = FLAG3;
const int SUBRACE_ERROR_PRESTIGE_FAILURE = FLAG4;
const int SUBRACE_ERROR_PRESTIGE_NOT_MET = FLAG5;
const int SUBRACE_ERROR_UNRECOGNISED = FLAG6;
const int SUBRACE_ERROR_GENDER = FLAG7;
const int SUBRACE_ERROR_SPECIAL_RESTRICTION = FLAG8;

const int SSE_SUBRACE_LOADER_CONDITION_ALWAYS_LOAD=NOFLAGS;
const int SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_USING_LETO=FLAG1;
const int SSE_SUBRACE_LOADER_CONDITION_LOAD_IF_NOT_USING_LETO=FLAG2;
const string SSE_SUBRACE_LOADER_AMOUNT = "SSE_LOAD_AMOUNT";
const string SSE_SUBRACE_LOADER_AMOUNT_OF_DELAYS = "SSE_LOAD_DELAY";

//::------------------ Item sorting constants and ints -------------------------
//:: Written by: Moon

//Requirement based Flags
const int ITEM_TYPE_REQ_ALL               =  FLAG1; //All requirements must be fulfilled [Stored]
const int ITEM_TYPE_REQ_DO_NOT_ALLOW      =  FLAG2; //Reversed (You can use all BUT the restrictions set) [Not Stored]
const int ITEM_TYPE_REQ_ANY               =  NOFLAGS; //Just 1 requirement must be met [Not Stored]

//MELEE WEAPON
const int ITEM_TYPE_WEAPON_MELEE           = FLAG2; //NOTE: Gloves (Monk Melee Weapon) DOES Respond to this one (but Bracers do not)
//RANGED OR THROWING WEAPON
const int ITEM_TYPE_WEAPON_RANGED_THROW    = FLAG3;  //Throwing Weapons (Shurikens etc.)
const int ITEM_TYPE_WEAPON_RANGED_LAUNCHER = FLAG4;  //Launchers (Bows, Crossbows & slings) includes ammo!

//FLAG SIZE OF THE WEAPON (Note that only weapons have sizes)
const int ITEM_TYPE_WEAPON_SIZE_TINY       = FLAG5;
const int ITEM_TYPE_WEAPON_SIZE_SMALL      = FLAG6;
const int ITEM_TYPE_WEAPON_SIZE_MEDIUM     = FLAG7;
const int ITEM_TYPE_WEAPON_SIZE_LARGE      = FLAG8;


//FLAG AS NONE BIOWARE STANDARD ITEM
const int ITEM_TYPE_NONE_BIOWARE_ITEM      = FLAG9;

//FLAG WEAPON BY PROF. FEAT REQUIRED TO USE
const int ITEM_TYPE_WEAPON_PROF_SIMPLE     = FLAG10;
const int ITEM_TYPE_WEAPON_PROF_MARTIAL    = FLAG11;
const int ITEM_TYPE_WEAPON_PROF_EXOTIC     = FLAG12;

//FLAG AS HELMS
const int ITEM_TYPE_HELM                   = FLAG13; //Only Helms

//FLAGS TORSO ARMOR BY AC
const int ITEM_TYPE_ARMOR_AC_0             = FLAG14; //Same Value for ITEM_TYPE_ARMOR_AC_0 and ITEM_TYPE_ARMOR_CLOTH

const int ITEM_TYPE_ARMOR_AC_1             = FLAG15;
const int ITEM_TYPE_ARMOR_AC_2             = FLAG16;
const int ITEM_TYPE_ARMOR_AC_3             = FLAG17;
const int ITEM_TYPE_ARMOR_AC_4             = FLAG18;
const int ITEM_TYPE_ARMOR_AC_5             = FLAG19;
const int ITEM_TYPE_ARMOR_AC_6             = FLAG20;
const int ITEM_TYPE_ARMOR_AC_7             = FLAG21;
const int ITEM_TYPE_ARMOR_AC_8             = FLAG22;

//FLAGS SHIELDS BY TYPE
const int ITEM_TYPE_SHIELD_SMALL           = FLAG23; //Small Shields
const int ITEM_TYPE_SHIELD_LARGE           = FLAG24; //Large Shields
const int ITEM_TYPE_SHIELD_TOWER           = FLAG25; //Tower Shields


//FLAG MISC TYPES
const int ITEM_TYPE_JEWLERY                = FLAG26; //Rings and Amulets
const int ITEM_TYPE_MISC_CLOTHING          = FLAG27; //None Armors, none Jewlery equipment (Cloak, belt, etc.)

//SPECIAL FLAGS
const int ITEM_TYPE_ALL                    = ALLFLAGS; //All of the above (incl. the restrictions)
const int ITEM_TYPE_INVALID                = NOFLAGS;  //Invalid or Undefined Type (Also used as "None of the above")



//Group Flags.
//WEAPONS (Both MELEE and RANGED/THROWING respond to this)

int ITEM_TYPE_WEAPON_RANGED          = ITEM_TYPE_WEAPON_RANGED_THROW | ITEM_TYPE_WEAPON_RANGED_LAUNCHER;
int ITEM_TYPE_WEAPON                 = ITEM_TYPE_WEAPON_MELEE | ITEM_TYPE_WEAPON_RANGED;

//All Small and Tiny Weapons will respond to this.
int ITEM_TYPE_WEAPON_SIZE_SMALL_DOWN = ITEM_TYPE_WEAPON_SIZE_SMALL | ITEM_TYPE_WEAPON_SIZE_TINY;
//All Medium and Large Weapons will respond to this.
int ITEM_TYPE_WEAPON_SIZE_MEDIUM_UP  = ITEM_TYPE_WEAPON_SIZE_MEDIUM | ITEM_TYPE_WEAPON_SIZE_LARGE;
//Any Size Respond to this. (For Size Testing)
int ITEM_TYPE_WEAPON_SIZE_ANY        = ITEM_TYPE_WEAPON_SIZE_SMALL_DOWN | ITEM_TYPE_WEAPON_SIZE_MEDIUM_UP;

//Any Prof Respond to this. (For Prof Testing)
int ITEM_TYPE_WEAPON_PROF_ANY        = ITEM_TYPE_WEAPON_PROF_EXOTIC | ITEM_TYPE_WEAPON_PROF_SIMPLE | ITEM_TYPE_WEAPON_PROF_MARTIAL;

//All Shields
int ITEM_TYPE_SHIELD_ANY             = ITEM_TYPE_SHIELD_LARGE | ITEM_TYPE_SHIELD_TOWER | ITEM_TYPE_SHIELD_SMALL;


//ARMOR SORTED BY TYPE
int ITEM_TYPE_ARMOR_TYPE_CLOTH       = ITEM_TYPE_ARMOR_AC_0; // AC 0  (See ITEM_TYPE_ARMOR_AC_0)
int ITEM_TYPE_ARMOR_TYPE_LIGHT       = ITEM_TYPE_ARMOR_AC_1 | ITEM_TYPE_ARMOR_AC_2 | ITEM_TYPE_ARMOR_AC_3;// AC 1 - 3
int ITEM_TYPE_ARMOR_TYPE_MEDIUM      = ITEM_TYPE_ARMOR_AC_4 | ITEM_TYPE_ARMOR_AC_5 | ITEM_TYPE_ARMOR_AC_6;// AC 4 - 6
int ITEM_TYPE_ARMOR_TYPE_HEAVY       = ITEM_TYPE_ARMOR_AC_7 | ITEM_TYPE_ARMOR_AC_8;// AC 7 - 8

int ITEM_TYPE_ARMOR                   = ITEM_TYPE_ARMOR_TYPE_HEAVY | ITEM_TYPE_ARMOR_TYPE_MEDIUM | ITEM_TYPE_ARMOR_TYPE_LIGHT | ITEM_TYPE_ARMOR_AC_0; //Only (Torso) Armor (incls zero AC Clothing)

//All armors/helms and shields should respond to this
int ITEM_TYPE_FULL_ARMOR_SET         = ITEM_TYPE_SHIELD_ANY | ITEM_TYPE_ARMOR | ITEM_TYPE_HELM; //All Armors, Shields and Helmet

/*
    COLOURS for ColourString()
*/
const string COLOUR_RED = "þ  ";
const string COLOUR_GREEN = " þ ";
const string COLOUR_BLUE = "  þ";
const string COLOUR_YELLOW = "þþ ";
const string COLOUR_PURPLE = "þ þ";
const string COLOUR_TEAL = " þþ";
const string COLOUR_LRED = "þdd";
const string COLOUR_LGREEN = "dþd";
const string COLOUR_LBLUE = "ddþ";
const string COLOUR_LYELLOW = "þþd";
const string COLOUR_LPURPLE = "þdþ";
const string COLOUR_LTEAL = "dþþ";
const string COLOUR_WHITE = "þþþ";
const string COLOUR_DARK = "ddd";
const string COLOUR_BLACK = "   ";
const string COLOUR_GREEN_SSE = "Ü";

struct Subrace
{
    int BaseRace;
    string Name;
    string SkinResRef;
    string UniqueItemResRef;
    int IsLightSensitive;
    int DamageTakenWhileInLight;
    int IsUndergroundSensitive;
    int DamageTakenWhileInUnderground;
    int ECL;
    int IsUndead;
    int PrestigiousSubrace;
};

struct SubraceAlignmentRestriction
{
    string subrace;
    int CanBeAlignment_Good;
    int CanBeAlignment_Neutral1;
    int CanBeAlignment_Evil;
    int CanBeAlignment_Lawful;
    int CanBeAlignment_Neutral2;
    int CanBeAlignment_Chaotic;
};

struct SubraceClassRestriction
{
    string subrace;
    int CanBe_Barbarian;
    int CanBe_Bard;
    int CanBe_Cleric;
    int CanBe_Druid;
    int CanBe_Fighter;
    int CanBe_Monk;
    int CanBe_Paladin;
    int CanBe_Ranger;
    int CanBe_Rogue;
    int CanBe_Sorcerer;
    int CanBe_Wizard;
};

struct SubraceSpellResistance
{
    string subrace;
    int SpellResistanceBase;
    int SpellResistanceMax;
};

struct SubraceDifferentAppearance
{
    string subrace;
    int ChangeAppearanceTime;
    int MaleAppearance;
    int FemaleAppearance;
    int Level;
};

struct SubraceStats
{
   int ModType;
   float StrengthModifier;
   float DexterityModifier;
   float ConstitutionModifier;
   float IntelligenceModifier;
   float WisdomModifier;
   float CharismaModifier;
   float ACModifier;
   float ABModifier;

};

struct SubraceBaseStatsModifier
{
   int StrengthModifier;
   int DexterityModifier;
   int ConstitutionModifier;
   int IntelligenceModifier;
   int WisdomModifier;
   int CharismaModifier;
   int SpdModifier;
//   int HPModifier;
};

