#include "x2_inc_switches"


// -----------------------------------------------------------------------------
// CONSTANTS - Server Settings
// -----------------------------------------------------------------------------
const string SRV_SERVERVAULT = "/opt/nwn/servervault/";
const int SRV_RESET_LENGTH = 240; // 4 Hours.
const int SRV_RESET_DELAY = 30; // 30 Minutes.
const int MAX_FEAT_NUM = 2102;
const int MAX_SPELL_NUM = 1503;
const int MAX_VOICESET_NUM = 444;

const int TA_CURRENT_PC_VERSION = 1;
// -----------------------------------------------------------------------------
// CONSTANTS - Mod Settings
// -----------------------------------------------------------------------------
const string VAR_MOD_DEV = "mod_dev";

const int REST_USE_FADES = FALSE;
const string MOD_DB_PW = "pwdata";
const string MOD_DB_OBJECT = "pwobjdata";
const string MOD_DB_QUEST = "qsstatus";


// -----------------------------------------------------------------------------
// CONSTANTS - Guilds
// -----------------------------------------------------------------------------
const int GUILD_KNIGHTS_OF_THE_AWAKENING = 1;
const string GUILD_KNIGHTS_OF_THE_AWAKENING_NAME = "Knights of the Awakening";
const string GUILD_KNIGHTS_OF_THE_AWAKENING_ABBRV = "K¤TA";

const int GUILD_NEW_AWAKENING_GUARDIANS = 2;
const string GUILD_NEW_AWAKENING_GUARDIANS_NAME = "New Awakening Gaurdians";
const string GUILD_NEW_AWAKENING_GUARDIANS_ABBRV = "‡NAG§‡";

const int GUILD_THE_SACRED_RIDERS = 3;
const string GUILD_THE_SACRED_RIDERS_NAME = "The Sacred Riders";
const string GUILD_THE_SACRED_RIDERS_ABBRV = "†T§R†";

const int GUILD_THE_LEGION_OF_DEATH = 4;
const string GUILD_THE_LEGION_OF_DEATH_NAME = "The Legion of Death";
const string GUILD_THE_LEGION_OF_DEATH_ABBRV = "§L¤D§";

const int GUILD_THE_DIRTY_DOZEN = 5;
const string GUILD_THE_DIRTY_DOZEN_NAME = "The Dirty Dozen";
const string GUILD_THE_DIRTY_DOZEN_ABBRV = "{DD}";

const int    GUILD_AWAKENING_ADVENTURERS       = 6;
const string GUILD_AWAKENING_ADVENTURERS_NAME  = "Awakening Adventurers Guild";
const string GUILD_AWAKENING_ADVENTURERS_ABBRV = "(AAG)";

const int    GUILD_AWAKENING_ROLE_PLAYERS       = 7;
const string GUILD_AWAKENING_ROLE_PLAYERS_NAME  = "Awakening Role Players Guild";
const string GUILD_AWAKENING_ROLE_PLAYERS_ABBRV = "*ARPG*";

const int    GUILD_ROUGH_RIDERS       = 8;
const string GUILD_ROUGH_RIDERS_NAME  = "Rough Riders";
const string GUILD_ROUGH_RIDERS_ABBRV = "â€¡Â®Â®â€¡";

// -----------------------------------------------------------------------------
// CONSTANTS - Area Related
// -----------------------------------------------------------------------------
// Variable Names
//Reference
const string VAR_AREA_OCCUPIED = "area_occupied";

//General - Settings
const string VAR_AREA_CLEAN_DELAY = "area_clean_delay";
const string VAR_AREA_CR_ADJUST = "area_cr_adjust";
const string VAR_AREA_FALL = "area_fall";
const string VAR_AREA_FLY = "area_fly";
const string VAR_AREA_NO_CLEAN = "area_no_clean";
const string VAR_AREA_NO_LOC_SAVE = "area_no_loc_save";
const string VAR_AREA_LOC_SAVE = "area_loc_save";
const string VAR_AREA_NO_LOOT = "area_no_loot";
const string VAR_AREA_NO_MAGIC = "area_no_magic";
const string VAR_AREA_NO_TIMESTOP = "area_no_timestop";
const string VAR_AREA_REVEAL = "area_reveal";

//Area  - Damage Settings
const string VAR_AREA_DMG = "area_dmg";
const string VAR_AREA_DMG_DELAY = "area_dmg_delay";
const string VAR_AREA_DMG_DC = "area_dmg_dc";
const string VAR_AREA_DMG_DICE = "area_dmg_dice";
const string VAR_AREA_DMG_SIDES = "area_dmg_sides";
const string VAR_AREA_DMG_ITEM = "area_dmg_item";
const string VAR_AREA_DMG_LEVEL = "area_dmg_level"; //Wild Magic Spell Level
const string VAR_AREA_DMG_META = "area_dmg_meta";   //Wild Magic Metamagic


const int AREA_DAMAGE_DELAY = 1;        // << Default Enviroment Damage Delay
const int CLEAN_PLACABLE_INV = FALSE;   // << If true will clean the invenotry of placeables.
const int AREA_CLEAN_DELAY = 20;         // << Default Area Cleaner Delay

// -----------------------------------------------------------------------------
// CONSTANTS - Classes
// -----------------------------------------------------------------------------
const int CLASS_TYPE_BARD_GROUP = 1000;
const int CLASS_TYPE_DRUID_GROUP = 1001;
const int CLASS_TYPE_FIGHTER_GROUP = 1002;
const int CLASS_TYPE_MAGE_GROUP = 1003;
const int CLASS_TYPE_ROGUE_GROUP = 1004;

// -----------------------------------------------------------------------------
// Debuging
// -----------------------------------------------------------------------------
const string VAR_DEBUG_LOGS = "DebugLogs";
const string VAR_DEBUG_SPELLS = "DebugSpells";
const string VAR_DEBUG_AREAS = "DebugAreas";
const string VAR_DEBUG_XP = "DebugXP";
const string VAR_DEBUG_DEV = "DebugDev";

const int LOGLEVEL_NONE = 0;
const int LOGLEVEL_MINIMUM = 1;
const int LOGLEVEL_DEBUG = 2;
const int LOGLEVEL_INFO = 3;
const int LOGLEVEL_NOTICE = 4;
const int LOGLEVEL_ERROR = 5;

// -----------------------------------------------------------------------------
// Doors
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// CONSTANTS - Hashes
// -----------------------------------------------------------------------------
const string VAR_HASH_FEAT_NAME = "FeatNames";
const string VAR_HASH_SPELL_NAME = "SpellNames";
const string VAR_HASH_SPELL_INFO = "SpellInfo";


// -----------------------------------------------------------------------------
// CONSTANTS - Item Level Restrictions
// -----------------------------------------------------------------------------
const string VAR_ILR = "ilr";
const string VAR_ILR_ONLY_ONE = "ilr_only_one";
const string VAR_ILR_CLASS = "ilr_class";
const string VAR_ILR_SUBRACE = "ilr_subrace";
const string VAR_ILR_DEITY = "ilr_deity";
const string VAR_ILR_TAGGED = "ilr_tagged";


// -----------------------------------------------------------------------------
// CONSTANTS - Placeables
// -----------------------------------------------------------------------------
const string VAR_MON_FALL = "fall";

// -----------------------------------------------------------------------------
// CONSTANTS - Placeables
// -----------------------------------------------------------------------------
const string VAR_PLACE_HB_ALWAYS = "place_hb_always";

// -----------------------------------------------------------------------------
// CONSTANTS - Player Related
// -----------------------------------------------------------------------------
// Variable Names
const string VAR_PC_ACQUIRE_SAVE = "pc_acquire_save";
const string VAR_PC_BIC_FILE = "pc_bic_file";
const string VAR_PC_BIND_POINT = "pc_bind_point";
const string VAR_PC_CDKEY = "pc_cdkey";
const string VAR_PC_DELETED = "pc_deleted";
const string VAR_PC_ENTERED = "pc_entered";
const string VAR_PC_FLYING = "pc_flying";
const string VAR_PC_HP = "pc_hp";
const string VAR_PC_IP_ADDRESS = "pc_ip_address";
const string VAR_PC_IS_PC = "pc_is_pc";
const string VAR_PC_LAST_AREA = "pc_last_area";
const string VAR_PC_MSGFILTER = "pc_msgfilter";
const string VAR_PC_PLAYER_NAME = "pc_player_name";
const string VAR_PC_SAVED_LOCATION = "pc_loc"; // << Name of the DB variable
const string VAR_PC_UID = "pc_uid";
const string VAR_PC_XP_BANK = "pc_xp_bank";
const string VAR_PC_GUILD = "pc_guild";
const string VAR_PC_NO_RELEVEL = "pc_no_relevel";

// Settings
const int PC_UID_LENGTH = 8;

const float ONACQUIRE_SAVE_DELAY = 6.0;
const int PC_STRIP_ALL_ITEMS = TRUE; // << Strip all items in players inventory TRUE or FALSE?
const int PC_STRIP_ALL_GOLD = TRUE; // << Strip all gold from player TRUE or FALSE?
const int PC_STARTING_GOLD = 1000; // << Give new player starting gold? - 0 is off
// -- Spells
const int EPIC_DC_BONUS_PER_LEVEL = 3;  //ie. 3 = + 1 / 3 levels over level 20 (caster levels)

// -----------------------------------------------------------------------------
// CONSTANTS - Object Identification System
// -----------------------------------------------------------------------------
const string VAR_OIDS_ID = "oids_id";

// -----------------------------------------------------------------------------
// CONSTANTS - Messages
// -----------------------------------------------------------------------------
// Location Save
const string MSG_LOCATION_SAVED = "Your location has been saved."; // << Player location message, if active
const string MSG_LOCATION_NOT_SAVED = "Your location cannot be saved in this area."; // << Player location message, if active
// Respawn/ Logged Dead
const string MSG_FORCED_RESPAWN = "Your character has been forced to respawn.";
const string MSG_LOGGED_DEAD = "";

////////////////////////////////////////////////////////////////////////////////
// CONSTANTS - XP System
////////////////////////////////////////////////////////////////////////////////
const string VAR_XP_BOSS_BONUS = "xp_boss_bonus";

const int XP_SYTEM_DEBUG = 0;
const int XP_MODIFIER = 10; // Default is 10.
const int REWARD_GP = TRUE;
const int REWARD_BOSS_XP_GP = TRUE;
const float GP_REWARD_MULTIPLIER = 2.0;
const float KILLER_XP_GP_BONUS = 0.0;
const float PARTY_XP_GP_BONUS = 0.1;
const float PARTY_DIST = 50.0; // Distance between each party member and the dead creature to be. Must be higher than 5.0!!
const int MAX_PARTY_GAP = 10;  // Party level gap for minimal XP
const float SUMMON_PENALTY = 0.2; // XP pentalty for each summon/familiar/henchman in the party within
const int PC_DIVIDE_XP = FALSE; // Do you want XP to be divided
const int MIN_XP = 5; // Minimum XP possible for all PC's Must be higher than 0!!

// PC Level Max XP consts.  Do NOT set any of these lower than the MIN_XP const above
const int
LEVEL_1_MAX_XP =  200, LEVEL_2_MAX_XP =  300,  LEVEL_3_MAX_XP = 300,
LEVEL_4_MAX_XP =  400, LEVEL_5_MAX_XP =  400,  LEVEL_6_MAX_XP = 400,
LEVEL_7_MAX_XP =  500, LEVEL_8_MAX_XP =  500,  LEVEL_9_MAX_XP = 500,
LEVEL_10_MAX_XP = 600, LEVEL_11_MAX_XP = 600, LEVEL_12_MAX_XP = 600,
LEVEL_13_MAX_XP = 600, LEVEL_14_MAX_XP = 600, LEVEL_15_MAX_XP = 600,
LEVEL_16_MAX_XP = 600, LEVEL_17_MAX_XP = 600, LEVEL_18_MAX_XP = 600,
LEVEL_19_MAX_XP = 600, LEVEL_20_MAX_XP = 600, LEVEL_21_MAX_XP = 600,
LEVEL_22_MAX_XP = 600, LEVEL_23_MAX_XP = 600, LEVEL_24_MAX_XP = 600,
LEVEL_25_MAX_XP = 600, LEVEL_26_MAX_XP = 600, LEVEL_27_MAX_XP = 600,
LEVEL_28_MAX_XP = 600, LEVEL_29_MAX_XP = 600, LEVEL_30_MAX_XP = 600,
LEVEL_31_MAX_XP = 600, LEVEL_33_MAX_XP = 600, LEVEL_32_MAX_XP = 600,
LEVEL_34_MAX_XP = 600, LEVEL_35_MAX_XP = 600, LEVEL_36_MAX_XP = 600,
LEVEL_37_MAX_XP = 600, LEVEL_38_MAX_XP = 600, LEVEL_39_MAX_XP = 600,
LEVEL_40_MAX_XP = 800, LEVEL_41_MAX_XP = 800, LEVEL_42_MAX_XP = 800,
LEVEL_43_MAX_XP = 800, LEVEL_44_MAX_XP = 800, LEVEL_45_MAX_XP = 800,
LEVEL_46_MAX_XP = 800, LEVEL_47_MAX_XP = 800, LEVEL_48_MAX_XP = 800,
LEVEL_49_MAX_XP = 800, LEVEL_50_MAX_XP = 800, LEVEL_51_MAX_XP = 800,
LEVEL_52_MAX_XP = 800, LEVEL_53_MAX_XP = 800, LEVEL_54_MAX_XP = 800,
LEVEL_55_MAX_XP = 800, LEVEL_56_MAX_XP = 800, LEVEL_57_MAX_XP = 800,
LEVEL_58_MAX_XP = 800, LEVEL_59_MAX_XP = 800, LEVEL_60_MAX_XP = 800;

// Experience Requirements for Legendary Levels
const int BASE_XP_LVL_40 = 780000;  //780000
const int XP_REQ_LVL41 = 1000000;   //1000000
const int XP_REQ_LVL42 = 1200000;   //1200000
const int XP_REQ_LVL43 = 1400000;   //1400000
const int XP_REQ_LVL44 = 1600000;   //1600000
const int XP_REQ_LVL45 = 1800000;   //1800000
const int XP_REQ_LVL46 = 2000000;   //2000000
const int XP_REQ_LVL47 = 2200000;   //2200000
const int XP_REQ_LVL48 = 2400000;   //2400000
const int XP_REQ_LVL49 = 2600000;   //2600000
const int XP_REQ_LVL50 = 2800000;   //2800000
const int XP_REQ_LVL51 = 3000000;   //3000000
const int XP_REQ_LVL52 = 3200000;   //3200000
const int XP_REQ_LVL53 = 3400000;   //3400000
const int XP_REQ_LVL54 = 3600000;   //3600000
const int XP_REQ_LVL55 = 3800000;   //3800000
const int XP_REQ_LVL56 = 4000000;   //4000000
const int XP_REQ_LVL57 = 4200000;   //4200000
const int XP_REQ_LVL58 = 4400000;  //4400000
const int XP_REQ_LVL59 = 4600000;  //4600000
const int XP_REQ_LVL60 = 4800000;  //4800000
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// CONSTANTS - Feats
///////////////////////////////////////////////////////////////////////////////
const int TA_FEAT_CIRCLE_KICK                                =   2001;
const int TA_FEAT_INTUITIVE_STRIKE                           =   2002;
const int TA_FEAT_EPIC_BLINDING_SPEED_2                      =   2003;
const int TA_FEAT_EPIC_BLINDING_SPEED_3                      =   2004;
// Legendary Specialization Feats
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_CLUB             =   2005;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_DAGGER           =   2006;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_DART             =   2007;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_HEAVYCROSSBOW    =   2008;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTCROSSBOW    =   2009;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTMACE        =   2010;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_MORNINGSTAR      =   2011;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_QUARTERSTAFF     =   2012;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTSPEAR       =   2013;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SICKLE           =   2014;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SLING            =   2015;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED          =   2016;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LONGBOW          =   2017;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTBOW         =   2018;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTSWORD       =   2019;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_RAPIER           =   2020;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SCIMITAR         =   2021;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LONGSWORD        =   2022;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATSWORD       =   2023;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_HANDAXE          =   2024;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_THROWINGAXE      =   2025;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_BATTLEAXE        =   2026;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATAXE         =   2027;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_HALBERD          =   2028;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTHAMMER      =   2029;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTFLAIL       =   2030;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_WARHAMMER        =   2031;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_HEAVYFLAIL       =   2032;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_KAMA             =   2033;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_KUKRI            =   2034;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHURIKEN         =   2035;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_SCYTHE           =   2036;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_KATANA           =   2037;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_BASTARDSWORD     =   2038;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_DIREMACE         =   2039;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_DOUBLEAXE        =   2040;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_TWOBLADEDSWORD   =   2041;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_CREATURE         =   2042;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_DWAXE            =   2043;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_TRIDENT          =   2044;
const int TA_FEAT_LEG_WEAPON_SPECIALIZATION_WHIP             =   2045;
const int TA_FEAT_LEGENDARY_CHARACTER                        =   2046;
// Greater Specialization Feats
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_CLUB             =    2048;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_DAGGER           =    2049;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_DART             =    2050;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_HEAVYCROSSBOW    =    2051;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTCROSSBOW    =    2052;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTMACE        =    2053;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_MORNINGSTAR      =    2054;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_QUARTERSTAFF     =    2055;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTSPEAR       =    2056;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SICKLE           =    2057;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SLING            =    2058;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED          =    2059;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LONGBOW          =    2060;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTBOW         =    2061;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTSWORD       =    2062;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_RAPIER           =    2063;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SCIMITAR         =    2064;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LONGSWORD        =    2065;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATSWORD       =    2066;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_HANDAXE          =    2067;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_THROWINGAXE      =    2068;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_BATTLEAXE        =    2069;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATAXE         =    2070;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_HALBERD          =    2071;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTHAMMER      =    2072;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTFLAIL       =    2073;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_WARHAMMER        =    2074;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_HEAVYFLAIL       =    2075;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_KAMA             =    2076;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_KUKRI            =    2077;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHURIKEN         =    2078;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_SCYTHE           =    2079;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_KATANA           =    2080;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_BASTARDSWORD     =    2081;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_DIREMACE         =    2082;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_DOUBLEAXE        =    2083;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_TWOBLADEDSWORD   =    2084;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_CREATURE         =    2085;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_DWAXE            =    2086;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_TRIDENT          =    2087;
const int TA_FEAT_SUP_WEAPON_SPECIALIZATION_WHIP             =    2088;

const int TA_FEAT_SHADOW_STRIKE                              =   2089;
const int TA_FEAT_PDK_PIOUS_DEMAND                           =   2090;
const int TA_FEAT_PDK_SACRED_RITE                            =   2091;
const int TA_FEAT_PDK_VALIANCE                               =   2092;
const int TA_FEAT_PDK_VENGEANCE                              =   2093;
const int TA_FEAT_PDK_VIRTUE                                 =   2094;
const int TA_FEAT_HARPER_LYCANBANE                           =   2095;
const int TA_FEAT_HARPER_MILILS_EAR                          =   2096;
const int TA_FEAT_HARPER_MIELIKKIS_TRUTH                     =   2097;

///////////////////////////////////////////////////////////////////////////////
// CONSTANTS - Spells
///////////////////////////////////////////////////////////////////////////////
const int DURATION_IN_ROUNDS = 0;
const int DURATION_IN_HOURS = 1;
const int DURATION_IN_TURNS = 2;

const int TARGET_TYPE_ALL       = 0;
const int TARGET_TYPE_SELECTIVE = 1;
const int TARGET_TYPE_STANDARD  = 2;
const int TARGET_TYPE_ALLIES    = 3;

const int SPELLS_HURT_CASTER = FALSE; // Set to false for no self-hurting.

// Custom Spells
const int TASPELL_BLINDING_SPEED_2          = 1501;
const int TASPELL_BLINDING_SPEED_3          = 1502;
const int TASPELL_SHADOW_STRIKE             = 1503;
const int TASPELL_PDK_PIOUS_DEMAND          = 1504;
const int TASPELL_PDK_SACRED_RITE           = 1505;
const int TASPELL_PDK_VALIANCE              = 1506;
const int TASPELL_PDK_VENGEANCE             = 1507;
const int TASPELL_PDK_VIRTUE                = 1508;
const int TASPELL_HARPER_LYCANBANE          = 1509;
const int TASPELL_HARPER_MILILS_EAR         = 1510;
const int TASPELL_HARPER_MIELIKKIS_TRUTH    = 1511;
const int TASPELL_DENEIRS_EYE               = 1512;
const int TASPELL_SD_DARKNESS               = 1513;
// Fake Spell IDs
const int TASPELL_ONHIT_FREEZE          = 10000;
const int TASPELL_PDK_PASSIVE_BONUS     = 10001;
const int TASPELL_WOODELF_CONCEAL       = 10002;
const int TASPELL_CIRCLE_KICK           = 10003;
const int TASPELL_LINUS_LOLLIPOP        = 10004;
const int TASPELL_STEALTH               = 10005;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// CONSTANTS - Text Coloring
///////////////////////////////////////////////////////////////////////////////
const string C_END = "</c>";
const string C_ORANGE    = "<cþh>"; // NWN Orange. Used in Log (Ex. "... killed Gobln")
const string C_GREEN_L   = "<c þ >"; // NWN Green. Used in tell channel
const string C_GREEN = "<c þ >"; //tells - acid
const string C_RED = "<cþ<<>";
const string C_RED2 = "<cþ>"; //fire damage
const string C_GRAY      = "<c°°°>"; // NWN Gray. Used in Log on players enter\leave
const string C_WHITE     = "<cððð>"; // NWN White. Used in Talk Channel
const string C_WHITE_T   = "<cþþþ>"; // True White
const string C_BLUE = "<c!}þ>";  //electrical damage
const string C_BLUE_L    = "<c™þþ>"; // NWN Light Blue. Used in player name
const string C_BLUE_N    = "<cf²þ>"; // NWN Normal Blue. Used in Conversations
const string C_BLUE_D    = "<cþ>"; // Dark Blue
const string C_PURPLE = "<cþ>"; //names
const string C_LT_PURPLE = "<cÍþ>";
const string C_LT_GREEN = "<c´þd>";
const string C_GOLD = "<cþïP>"; //shouts
const string C_YELLOW = "<cþþ>"; //send message to pc default (server messages)
const string C_LT_BLUE = "<cßþ>"; //dm channel
const string C_LT_BLUE2 = "<c›þþ>"; //cold damage
const string C_CRIMSON = "<c‘  >";
const string C_MAGENTA   = "<c? ?>"; // Magenta
const string C_VIOLET    = "<cþ>"; // NWN Violet. Used in Names in Chat Channel
const string C_VIOLET_L  = "<cÌwþ>"; // NWN Light Violet. Used in cast-action in Log (Ex. "casting unnkown spell")
const string C_VIOLET_SL = "<cÌ™Ì>"; // NWN SuperLight Violet. Used in Object Names, who does cast-action in Log
const string C_PLUM = "<cþww>";
const string C_TANGERINE = "<cÇZ >";
const string C_PEACH = "<cþÇ >";
const string C_AMBER = "<cœœ >";
const string C_LEMON = "<cþþw>";
const string C_EMERALD = "<c ~ >";
const string C_LIME = "<cwþw>";
const string C_MIDNIGHT = "<c  t>";
const string C_NAVY = "<c  ‘>";
const string C_AZURE = "<c~~þ>";
const string C_SKYBLUE = "<cÇÇþ>";
const string C_LAVENDER = "<cþ~þ>";
const string C_BLACK = "<c   >";
const string C_SLATE = "<c666>";
const string C_DK_GREY = "<cZZZ>";
const string C_GREY = "<c~~~>";
const string C_LT_GREY = "<c¯¯¯>";
const string C_TURQUOISE = "<c ¥¥>";
const string C_JADE = "<c tt>";
const string C_CYAN = "<c þþ>";
const string C_CERULEAN = "<cœþþ>";
const string C_AQUA = "<cZÇ¯>";
const string C_SILVER = "<c¿¯Ç>";
const string C_ROSE = "<cÎFF>";
const string C_PINK = "<cþV¿>";
const string C_WOOD = "<c‘Z(>";
const string C_BROWN = "<cÇ~6>";
const string C_TAN = "<cß‘F>";
const string C_FLESH = "<cû¥Z>";
const string C_IVORY = "<cþÎ¥>";
const string C_NONE = "";
const string sASCII = "                                            !!#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥§©©ª«¬­®¯°±²³´µ¶·¸¸º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïñòóôõö÷øùúûüýþþþ";
const string NEWLINE = "\n";

///////////////////////////////////////////////////////////////////////////////
// CONSTANTS - CEP Weapon Constants
///////////////////////////////////////////////////////////////////////////////
const int BASE_ITEM_SPEAR_SHORT             = 210;
const int BASE_ITEM_TRIDENT_ONE_HANDED      = 300;
const int BASE_ITEM_HEAVYPICK               = 301;
const int BASE_ITEM_LIGHTPICK               = 302;
const int BASE_ITEM_SAI                     = 303;
const int BASE_ITEM_NUNCHAKU                = 304;
const int BASE_ITEM_FALCHION                = 305;
const int BASE_ITEM_SAP                     = 308;
const int BASE_ITEM_ASSASSINDAGGER          = 309;
const int BASE_ITEM_KATAR                   = 310;
const int BASE_ITEM_LIGHTMACE_2             = 312;
const int BASE_ITEM_KUKRI_2                 = 313;
const int BASE_ITEM_FALCHION_2              = 316;
const int BASE_ITEM_HEAVYMACE               = 317;
const int BASE_ITEM_MAUL                    = 318;
const int BASE_ITEM_MERCLONGSWORD           = 319;
const int BASE_ITEM_MERCGREATSWORD          = 320;
const int BASE_ITEM_DOUBLESCIMITAR          = 321;
const int BASE_ITEM_GOAD                    = 322;
const int BASE_ITEM_WINDFIREWHEEL           = 323;
const int BASE_ITEM_MAUGDOUBLESWORD         = 324;
const int BASE_ITEM_LONGSWORD_2             = 330;

// -----------------------------------------------------------------------------
// CONSTANTS - Items
// -----------------------------------------------------------------------------
// Buffitis Rock
const string VAR_BUFF_ROCK_PLUS         = "buff_rock_plus";
const string VAR_BUFF_ROCK_NUM_SPELLS   = "buff_rock_num_spells";
const string VAR_BUFF_ROCK_META         = "buff_rock_meta";
const string VAR_BUFF_ROCK_SPELL        = "buff_rock_spell";
const int BUFF_ROCK_MAX_SPELLS          = 20;

// -----------------------------------------------------------------------------
// CONSTANTS - Items
// -----------------------------------------------------------------------------
const string RLGS_RANGE = "rlgs_range";
const string RLGS_GENERATE = "rlgs_generate";
const string RLGS_LOOT_PREFIX = "rlgs_loot_prefix";
const string RLGS_LOOT_POSTFIX = "rlgs_loot_postfix";
const string RLGS_SS = "rlgs_ss_";
const string RLGS_ITEM = "rlgs_item_";
const string RLGS_GOLD = "rlgs_gold";
const string RLGS_USE_PC = "rlgs_use_pc";
const string RLGS_PARTY_MOD = "rlgs_party_mod";

const string RLGS_CHEST_USED = "rlgs_chest_used";

const int RLGS_RANGE_NONE = 0; // 0-6
const int RLGS_RANGE_1    = 1; // 7-12
const int RLGS_RANGE_2    = 2; // 13-18
const int RLGS_RANGE_3    = 3; // 19-24
const int RLGS_RANGE_4    = 4; // 24-30
const int RLGS_RANGE_5    = 5; // 30-36

const int RLGS_DEFAULT_CHANCE = 15;
const int RLGS_DEFAULT_ATTEMPTS = 1;

struct rlgs_info{
    object oContainer, oHolder, oPC;
    int nRange, nQuality, nClass;
};

// -----------------------------------------------------------------------------
// CONSTANTS - Conversation Tokens
// -----------------------------------------------------------------------------


//4200-4213: HGLL Conversation
const int PVP_TOKEN_KILLS = 7001;
const int PVP_TOKEN_DEATHS = 7002;
const int PVP_TOKEN_CAPTURES = 7003;
const int PVP_TOKEN_RETURNS = 7004;
const int PVP_TOKEN_VICTORIES = 7005;
const int PVP_TOKEN_SIDE = 7007;
const int PVP_TOKEN_TEAM1_COUNT = 7011;
const int PVP_TOKEN_TEAM2_COUNT = 7012;
const int PVP_TOKEN_TEAM1_POINTS = 7013;
const int PVP_TOKEN_TEAM2_POINTS = 7014;
const int PVP_TOKEN_ACTIVE_AREA = 7020;

const int PL_VOICE_CHANGE_TOKEN = 9000;


// -----------------------------------------------------------------------------
// CONSTANTS - Damage
// -----------------------------------------------------------------------------

const int DAMAGE_TYPE_ELEMENTALS = 8192;
const int DAMAGE_TYPE_EXOTICS = 16384;
const int DAMAGE_TYPE_PHYSICALS = 32768;

// -----------------------------------------------------------------------------
// CONSTANTS - IP_CONST_FEAT_*
// -----------------------------------------------------------------------------
const int IP_CONST_FEAT_ARCANE_DEFENSE_ABJURATION = 101;
const int IP_CONST_FEAT_ARCANE_DEFENSE_CONJURATION = 102;
const int IP_CONST_FEAT_ARCANE_DEFENSE_DIVINATION = 103;
const int IP_CONST_FEAT_ARCANE_DEFENSE_ENCHATMENT = 104;
const int IP_CONST_FEAT_ARCANE_DEFENSE_EVOCATION = 105;
const int IP_CONST_FEAT_ARCANE_DEFENSE_ILLUSION = 106;
const int IP_CONST_FEAT_ARCANE_DEFENSE_NECROMANCY = 107;
const int IP_CONST_FEAT_ARCANE_DEFENSE_TRANSMUTATION = 108;
const int IP_CONST_FEAT_ARTIST = 109;
const int IP_CONST_FEAT_AURA_OF_COURAGE = 110;
const int IP_CONST_FEAT_BARBARIAN_ENDURANCE = 111;
const int IP_CONST_FEAT_BATTLE_TRAINING_VERSUS_GIANTS = 112;
const int IP_CONST_FEAT_BATTLE_TRAINING_VERSUS_GOBLINS = 113;
const int IP_CONST_FEAT_BATTLE_TRAINING_VERSUS_ORCS = 114;
const int IP_CONST_FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS = 115;
const int IP_CONST_FEAT_BLINDSIGHT_60_FEET = 116;
const int IP_CONST_FEAT_BLIND_FIGHT = 117;
const int IP_CONST_FEAT_BLOODED = 118;
const int IP_CONST_FEAT_BREW_POTION = 119;
const int IP_CONST_FEAT_BULLHEADED = 120;
const int IP_CONST_FEAT_CALLED_SHOT = 121;
const int IP_CONST_FEAT_CIRCLE_KICK = 122;
const int IP_CONST_FEAT_COURTEOUS_MAGOCRACY = 123;
const int IP_CONST_FEAT_CRAFT_WAND = 124;
const int IP_CONST_FEAT_CRIPPLING_STRIKE = 125;
const int IP_CONST_FEAT_DARKVISION = 126;
const int IP_CONST_FEAT_DEFENSIVE_ROLL = 127;
const int IP_CONST_FEAT_DEFLECT_ARROWS = 128;
const int IP_CONST_FEAT_DIRTY_FIGHTING = 129;
const int IP_CONST_FEAT_DIVINE_GRACE = 130;
const int IP_CONST_FEAT_DIVINE_HEALTH = 131;
const int IP_CONST_FEAT_DIVINE_MIGHT = 132;
const int IP_CONST_FEAT_DIVINE_SHIELD = 133;
const int IP_CONST_FEAT_EPIC_ARMOR_SKIN = 134;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_QUICKEN_1 = 135;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_QUICKEN_2 = 136;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_QUICKEN_3 = 137;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1 = 138;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2 = 139;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3 = 140;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_STILL_SPELL_1 = 141;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_STILL_SPELL_2 = 142;
const int IP_CONST_FEAT_EPIC_AUTOMATIC_STILL_SPELL_3 = 143;
const int IP_CONST_FEAT_EPIC_BANE_OF_ENEMIES = 144;
const int IP_CONST_FEAT_EPIC_BLINDING_SPEED = 145;
const int IP_CONST_FEAT_EPIC_DAMAGE_REDUCTION_3 = 146;
const int IP_CONST_FEAT_EPIC_DAMAGE_REDUCTION_6 = 147;
const int IP_CONST_FEAT_EPIC_DAMAGE_REDUCTION_9 = 148;
const int IP_CONST_FEAT_EPIC_DODGE = 149;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_1 = 150;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_2 = 151;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_3 = 152;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_4 = 153;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_5 = 154;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_6 = 155;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_7 = 156;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_8 = 157;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_9 = 158;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ACID_10 = 159;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_1 = 160;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_2 = 161;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_3 = 162;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_4 = 163;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_5 = 164;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_6 = 165;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_7 = 166;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_8 = 167;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_9 = 168;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_COLD_10 = 169;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_1 = 170;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_2 = 171;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_3 = 172;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_4 = 173;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_5 = 174;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_6 = 175;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_7 = 176;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_8 = 177;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_9 = 178;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_ELECTRICAL_10 = 179;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_1 = 180;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_2 = 181;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_3 = 182;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_4 = 183;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_5 = 184;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_6 = 185;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_7 = 186;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_8 = 187;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_9 = 188;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_FIRE_10 = 189;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_1 = 190;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_2 = 191;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_3 = 192;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_4 = 193;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_5 = 194;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_6 = 195;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_7 = 196;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_8 = 197;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_9 = 198;
const int IP_CONST_FEAT_EPIC_ENERGY_RESISTANCE_SONIC_10 = 199;
const int IP_CONST_FEAT_EPIC_EPIC_WARDING = 200;
const int IP_CONST_FEAT_EPIC_FORTITUDE = 201;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_1 = 202;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_2 = 203;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_3 = 204;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_4 = 205;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_5 = 206;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_6 = 207;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_7 = 208;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_8 = 209;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_9 = 210;
const int IP_CONST_FEAT_EPIC_GREAT_SMITING_10 = 211;
const int IP_CONST_FEAT_EPIC_IMPROVED_COMBAT_CASTING = 212;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1 = 213;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2 = 214;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3 = 215;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4 = 216;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5 = 217;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6 = 218;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7 = 219;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8 = 220;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9 = 221;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10 = 222;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_1 = 223;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_2 = 224;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_3 = 225;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_4 = 226;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_5 = 227;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_6 = 228;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_7 = 229;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_8 = 230;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_9 = 231;
const int IP_CONST_FEAT_EPIC_IMPROVED_SPELL_RESISTANCE_10 = 232;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_1 = 233;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_2 = 234;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_3 = 235;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_4 = 236;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_5 = 237;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_6 = 238;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_7 = 239;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_8 = 240;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_9 = 241;
const int IP_CONST_FEAT_EPIC_IMPROVED_STUNNING_FIST_10 = 242;
const int IP_CONST_FEAT_EPIC_LASTING_INSPIRATION = 243;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD = 244;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE = 245;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB = 246;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_CREATURE = 247;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER = 248;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DART = 249;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE = 250;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE = 251;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE = 252;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE = 253;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD = 254;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD = 255;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE = 256;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW = 257;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL = 258;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA = 259;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA = 260;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI = 261;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW = 262;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL = 263;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER = 264;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE = 265;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW = 266;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD = 267;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR = 268;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF = 269;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER = 270;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR = 271;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE = 272;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW = 273;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR = 274;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD = 275;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN = 276;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE = 277;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_SLING = 278;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE = 279;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD = 280;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED = 281;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER = 282;
const int IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP = 283;
const int IP_CONST_FEAT_EPIC_PERFECT_HEALTH = 284;
const int IP_CONST_FEAT_EPIC_PLANAR_TURNING = 285;
const int IP_CONST_FEAT_EPIC_PROWESS = 286;
const int IP_CONST_FEAT_EPIC_REFLEXES = 287;
const int IP_CONST_FEAT_EPIC_REPUTATION = 288;
const int IP_CONST_FEAT_EPIC_SELF_CONCEALMENT_10 = 289;
const int IP_CONST_FEAT_EPIC_SELF_CONCEALMENT_20 = 290;
const int IP_CONST_FEAT_EPIC_SELF_CONCEALMENT_30 = 291;
const int IP_CONST_FEAT_EPIC_SELF_CONCEALMENT_40 = 292;
const int IP_CONST_FEAT_EPIC_SELF_CONCEALMENT_50 = 293;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY = 294;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_APPRAISE = 295;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_BLUFF = 296;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_CONCENTRATION = 297;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR = 298;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP = 299;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON = 300;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_DISABLETRAP = 301;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_DISCIPLINE = 302;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_HEAL = 303;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_HIDE = 304;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_INTIMIDATE = 305;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_LISTEN = 306;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_LORE = 307;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY = 308;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_OPENLOCK = 309;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_PARRY = 310;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_PERFORM = 311;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_PERSUADE = 312;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_PICKPOCKET = 313;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_SEARCH = 314;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_SETTRAP = 315;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT = 316;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_SPOT = 317;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_TAUNT = 318;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_TUMBLE = 319;
const int IP_CONST_FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE = 320;
const int IP_CONST_FEAT_EPIC_SPELL_DRAGON_KNIGHT = 321;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_ABJURATION = 322;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_CONJURATION = 323;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_DIVINATION = 324;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT = 325;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_EVOCATION = 326;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_ILLUSION = 327;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_NECROMANCY = 328;
const int IP_CONST_FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION = 329;
const int IP_CONST_FEAT_EPIC_SPELL_HELLBALL = 330;
const int IP_CONST_FEAT_EPIC_SPELL_MAGE_ARMOUR = 331;
const int IP_CONST_FEAT_EPIC_SPELL_MUMMY_DUST = 332;
const int IP_CONST_FEAT_EPIC_SPELL_PENETRATION = 333;
const int IP_CONST_FEAT_EPIC_SPELL_RUIN = 334;
const int IP_CONST_FEAT_EPIC_SUPERIOR_INITIATIVE = 335;
const int IP_CONST_FEAT_EPIC_SUPERIOR_WEAPON_FOCUS = 336;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_1 = 337;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_2 = 338;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_3 = 339;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_4 = 340;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_5 = 341;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_6 = 342;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_7 = 343;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_8 = 344;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_9 = 345;
const int IP_CONST_FEAT_EPIC_TOUGHNESS_10 = 346;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD = 347;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE = 348;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_CLUB = 349;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_CREATURE = 350;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DAGGER = 351;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DART = 352;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DIREMACE = 353;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE = 354;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_DWAXE = 355;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREATAXE = 356;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_GREATSWORD = 357;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HALBERD = 358;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HANDAXE = 359;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW = 360;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL = 361;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KAMA = 362;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KATANA = 363;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_KUKRI = 364;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW = 365;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL = 366;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER = 367;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE = 368;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONGBOW = 369;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_LONGSWORD = 370;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR = 371;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF = 372;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_RAPIER = 373;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCIMITAR = 374;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SCYTHE = 375;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORTBOW = 376;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR = 377;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD = 378;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SHURIKEN = 379;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SICKLE = 380;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_SLING = 381;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE = 382;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD = 383;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_UNARMED = 384;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WARHAMMER = 385;
const int IP_CONST_FEAT_EPIC_WEAPON_FOCUS_WHIP = 386;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD = 387;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE = 388;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB = 389;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE = 390;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER = 391;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DART = 392;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE = 393;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE = 394;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE = 395;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE = 396;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD = 397;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD = 398;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE = 399;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW = 400;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL = 401;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA = 402;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA = 403;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI = 404;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW = 405;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL = 406;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER = 407;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE = 408;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW = 409;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD = 410;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR = 411;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF = 412;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER = 413;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR = 414;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE = 415;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW = 416;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR = 417;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD = 418;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN = 419;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE = 420;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_SLING = 421;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE = 422;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD = 423;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED = 424;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER = 425;
const int IP_CONST_FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP = 426;
const int IP_CONST_FEAT_EPIC_WILL = 427;
const int IP_CONST_FEAT_EVASION = 428;
const int IP_CONST_FEAT_EXPERTISE = 429;
const int IP_CONST_FEAT_EXTRA_MUSIC = 430;
const int IP_CONST_FEAT_EXTRA_SMITING = 431;
const int IP_CONST_FEAT_EXTRA_STUNNING_ATTACK = 432;
const int IP_CONST_FEAT_FAVORED_ENEMY_ABERRATION = 433;
const int IP_CONST_FEAT_FAVORED_ENEMY_ANIMAL = 434;
const int IP_CONST_FEAT_FAVORED_ENEMY_BEAST = 435;
const int IP_CONST_FEAT_FAVORED_ENEMY_CONSTRUCT = 436;
const int IP_CONST_FEAT_FAVORED_ENEMY_DRAGON = 437;
const int IP_CONST_FEAT_FAVORED_ENEMY_DWARF = 438;
const int IP_CONST_FEAT_FAVORED_ENEMY_ELEMENTAL = 439;
const int IP_CONST_FEAT_FAVORED_ENEMY_ELF = 440;
const int IP_CONST_FEAT_FAVORED_ENEMY_FEY = 441;
const int IP_CONST_FEAT_FAVORED_ENEMY_GIANT = 442;
const int IP_CONST_FEAT_FAVORED_ENEMY_GNOME = 443;
const int IP_CONST_FEAT_FAVORED_ENEMY_GOBLINOID = 444;
const int IP_CONST_FEAT_FAVORED_ENEMY_HALFELF = 445;
const int IP_CONST_FEAT_FAVORED_ENEMY_HALFLING = 446;
const int IP_CONST_FEAT_FAVORED_ENEMY_HALFORC = 447;
const int IP_CONST_FEAT_FAVORED_ENEMY_HUMAN = 448;
const int IP_CONST_FEAT_FAVORED_ENEMY_MAGICAL_BEAST = 449;
const int IP_CONST_FEAT_FAVORED_ENEMY_MONSTROUS = 450;
const int IP_CONST_FEAT_FAVORED_ENEMY_ORC = 451;
const int IP_CONST_FEAT_FAVORED_ENEMY_OUTSIDER = 452;
const int IP_CONST_FEAT_FAVORED_ENEMY_REPTILIAN = 453;
const int IP_CONST_FEAT_FAVORED_ENEMY_SHAPECHANGER = 454;
const int IP_CONST_FEAT_FAVORED_ENEMY_UNDEAD = 455;
const int IP_CONST_FEAT_FAVORED_ENEMY_VERMIN = 456;
const int IP_CONST_FEAT_FEARLESS = 457;
const int IP_CONST_FEAT_FLURRY_OF_BLOWS = 458;
const int IP_CONST_FEAT_GOOD_AIM = 459;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_ABJURATION = 460;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_CONJURATION = 461;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_DIVINATION = 462;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT = 463;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_EVOCATION = 464;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_ILLUSION = 465;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_NECROMANCY = 466;
const int IP_CONST_FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION = 467;
const int IP_CONST_FEAT_GREATER_SPELL_PENETRATION = 468;
const int IP_CONST_FEAT_GREAT_CLEAVE = 469;
const int IP_CONST_FEAT_GREAT_FORTITUDE = 470;
const int IP_CONST_FEAT_HARDINESS_VERSUS_ENCHANTMENTS = 471;
const int IP_CONST_FEAT_HARDINESS_VERSUS_ILLUSIONS = 472;
const int IP_CONST_FEAT_HARDINESS_VERSUS_POISONS = 473;
const int IP_CONST_FEAT_HARDINESS_VERSUS_SPELLS = 474;
const int IP_CONST_FEAT_IMMUNITY_TO_SLEEP = 475;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD = 476;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE = 477;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB = 478;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_CREATURE = 479;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER = 480;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_DART = 481;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE = 482;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE = 483;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE = 484;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE = 485;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD = 486;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD = 487;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE = 488;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW = 489;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL = 490;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA = 491;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA = 492;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI = 493;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW = 494;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL = 495;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER = 496;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE = 497;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW = 498;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD = 499;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR = 500;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER = 501;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR = 502;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE = 503;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW = 504;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD = 505;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN = 506;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE = 507;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SLING = 508;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR = 509;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF = 510;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE = 511;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD = 512;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER = 513;
const int IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP = 514;
const int IP_CONST_FEAT_IMPROVED_DISARM = 515;
const int IP_CONST_FEAT_IMPROVED_EVASION = 516;
const int IP_CONST_FEAT_IMPROVED_EXPERTISE = 517;
const int IP_CONST_FEAT_IMPROVED_INITIATIVE = 518;
const int IP_CONST_FEAT_IMPROVED_KNOCKDOWN = 519;
const int IP_CONST_FEAT_IMPROVED_PARRY = 520;
const int IP_CONST_FEAT_IMPROVED_POWER_ATTACK = 521;
const int IP_CONST_FEAT_IMPROVED_TWO_WEAPON_FIGHTING = 522;
const int IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE = 523;
const int IP_CONST_FEAT_IMPROVED_WHIRLWIND = 524;
const int IP_CONST_FEAT_INCREASE_MULTIPLIER = 525;
const int IP_CONST_FEAT_IRON_WILL = 526;
const int IP_CONST_FEAT_KEEN_SENSE = 527;
const int IP_CONST_FEAT_KI_CRITICAL = 528;
const int IP_CONST_FEAT_LIGHTNING_REFLEXES = 529;
const int IP_CONST_FEAT_LINGERING_SONG = 530;
const int IP_CONST_FEAT_LOWLIGHTVISION = 531;
const int IP_CONST_FEAT_LUCKY = 532;
const int IP_CONST_FEAT_LUCK_OF_HEROES = 533;
const int IP_CONST_FEAT_NATURE_SENSE = 534;
const int IP_CONST_FEAT_OPPORTUNIST = 535;
const int IP_CONST_FEAT_PARTIAL_SKILL_AFFINITY_LISTEN = 536;
const int IP_CONST_FEAT_PARTIAL_SKILL_AFFINITY_SEARCH = 537;
const int IP_CONST_FEAT_PARTIAL_SKILL_AFFINITY_SPOT = 538;
const int IP_CONST_FEAT_PRESTIGE_DARK_BLESSING = 539;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_1 = 540;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_2 = 541;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_3 = 542;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_4 = 543;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_5 = 544;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_6 = 545;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_7 = 546;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_8 = 547;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_9 = 548;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_10 = 549;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_11 = 550;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_12 = 551;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_13 = 552;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_14 = 553;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_15 = 554;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_16 = 555;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_17 = 556;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_18 = 557;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_19 = 558;
const int IP_CONST_FEAT_PRESTIGE_DEATH_ATTACK_20 = 559;
const int IP_CONST_FEAT_PRESTIGE_DEFENSIVE_AWARENESS_1 = 560;
const int IP_CONST_FEAT_PRESTIGE_DEFENSIVE_AWARENESS_2 = 561;
const int IP_CONST_FEAT_PRESTIGE_DEFENSIVE_AWARENESS_3 = 562;
const int IP_CONST_FEAT_RAPID_RELOAD = 563;
const int IP_CONST_FEAT_RESIST_DISEASE = 564;
const int IP_CONST_FEAT_RESIST_ENERGY_ACID = 565;
const int IP_CONST_FEAT_RESIST_ENERGY_COLD = 566;
const int IP_CONST_FEAT_RESIST_ENERGY_ELECTRICAL = 567;
const int IP_CONST_FEAT_RESIST_ENERGY_FIRE = 568;
const int IP_CONST_FEAT_RESIST_ENERGY_SONIC = 569;
const int IP_CONST_FEAT_RESIST_NATURES_LURE = 570;
const int IP_CONST_FEAT_RESIST_POISON = 571;
const int IP_CONST_FEAT_SAP = 572;
const int IP_CONST_FEAT_SILVER_PALM = 573;
const int IP_CONST_FEAT_SKILL_AFFINITY_CONCENTRATION = 574;
const int IP_CONST_FEAT_SKILL_AFFINITY_LISTEN = 575;
const int IP_CONST_FEAT_SKILL_AFFINITY_LORE = 576;
const int IP_CONST_FEAT_SKILL_AFFINITY_MOVE_SILENTLY = 577;
const int IP_CONST_FEAT_SKILL_AFFINITY_SEARCH = 578;
const int IP_CONST_FEAT_SKILL_AFFINITY_SPOT = 579;
const int IP_CONST_FEAT_SKILL_FOCUS_ANIMAL_EMPATHY = 580;
const int IP_CONST_FEAT_SKILL_FOCUS_APPRAISE = 581;
const int IP_CONST_FEAT_SKILL_FOCUS_BLUFF = 582;
const int IP_CONST_FEAT_SKILL_FOCUS_CONCENTRATION = 583;
const int IP_CONST_FEAT_SKILL_FOCUS_CRAFT_ARMOR = 584;
const int IP_CONST_FEAT_SKILL_FOCUS_CRAFT_TRAP = 585;
const int IP_CONST_FEAT_SKILL_FOCUS_CRAFT_WEAPON = 586;
const int IP_CONST_FEAT_SKILL_FOCUS_DISABLE_TRAP = 587;
const int IP_CONST_FEAT_SKILL_FOCUS_DISCIPLINE = 588;
const int IP_CONST_FEAT_SKILL_FOCUS_HEAL = 589;
const int IP_CONST_FEAT_SKILL_FOCUS_HIDE = 590;
const int IP_CONST_FEAT_SKILL_FOCUS_INTIMIDATE = 591;
const int IP_CONST_FEAT_SKILL_FOCUS_LISTEN = 592;
const int IP_CONST_FEAT_SKILL_FOCUS_LORE = 593;
const int IP_CONST_FEAT_SKILL_FOCUS_MOVE_SILENTLY = 594;
const int IP_CONST_FEAT_SKILL_FOCUS_OPEN_LOCK = 595;
const int IP_CONST_FEAT_SKILL_FOCUS_PARRY = 596;
const int IP_CONST_FEAT_SKILL_FOCUS_PERFORM = 597;
const int IP_CONST_FEAT_SKILL_FOCUS_PERSUADE = 598;
const int IP_CONST_FEAT_SKILL_FOCUS_PICK_POCKET = 599;
const int IP_CONST_FEAT_SKILL_FOCUS_SEARCH = 600;
const int IP_CONST_FEAT_SKILL_FOCUS_SET_TRAP = 601;
const int IP_CONST_FEAT_SKILL_FOCUS_SPELLCRAFT = 602;
const int IP_CONST_FEAT_SKILL_FOCUS_SPOT = 603;
const int IP_CONST_FEAT_SKILL_FOCUS_TAUNT = 604;
const int IP_CONST_FEAT_SKILL_FOCUS_TUMBLE = 605;
const int IP_CONST_FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE = 606;
const int IP_CONST_FEAT_SKILL_MASTERY = 607;
const int IP_CONST_FEAT_SLIPPERY_MIND = 608;
const int IP_CONST_FEAT_SNAKE_BLOOD = 609;
const int IP_CONST_FEAT_SNEAK_ATTACK_6 = 610;
const int IP_CONST_FEAT_SNEAK_ATTACK_7 = 611;
const int IP_CONST_FEAT_SNEAK_ATTACK_8 = 612;
const int IP_CONST_FEAT_SNEAK_ATTACK_9 = 613;
const int IP_CONST_FEAT_SNEAK_ATTACK_10 = 614;
const int IP_CONST_FEAT_SNEAK_ATTACK_11 = 615;
const int IP_CONST_FEAT_SNEAK_ATTACK_12 = 616;
const int IP_CONST_FEAT_SNEAK_ATTACK_13 = 617;
const int IP_CONST_FEAT_SNEAK_ATTACK_14 = 618;
const int IP_CONST_FEAT_SNEAK_ATTACK_15 = 619;
const int IP_CONST_FEAT_SNEAK_ATTACK_16 = 620;
const int IP_CONST_FEAT_SNEAK_ATTACK_17 = 621;
const int IP_CONST_FEAT_SNEAK_ATTACK_18 = 622;
const int IP_CONST_FEAT_SNEAK_ATTACK_19 = 623;
const int IP_CONST_FEAT_SNEAK_ATTACK_20 = 624;
const int IP_CONST_FEAT_SPELL_FOCUS_TRANSMUTATION = 625;
const int IP_CONST_FEAT_SPRING_ATTACK = 626;
const int IP_CONST_FEAT_STEALTHY = 627;
const int IP_CONST_FEAT_STILL_MIND = 628;
const int IP_CONST_FEAT_STONECUNNING = 629;
const int IP_CONST_FEAT_STRONG_SOUL = 630;
const int IP_CONST_FEAT_STUNNING_FIST = 631;
const int IP_CONST_FEAT_SUPERIOR_WEAPON_FOCUS = 632;
const int IP_CONST_FEAT_THUG = 633;
const int IP_CONST_FEAT_TOUGHNESS = 634;
const int IP_CONST_FEAT_TRACKLESS_STEP = 635;
const int IP_CONST_FEAT_UNCANNY_DODGE_1 = 636;
const int IP_CONST_FEAT_UNCANNY_DODGE_2 = 637;
const int IP_CONST_FEAT_UNCANNY_DODGE_3 = 638;
const int IP_CONST_FEAT_UNCANNY_DODGE_4 = 639;
const int IP_CONST_FEAT_UNCANNY_DODGE_5 = 640;
const int IP_CONST_FEAT_UNCANNY_DODGE_6 = 641;
const int IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD = 642;
const int IP_CONST_FEAT_WEAPON_FOCUS_BATTLE_AXE = 643;
const int IP_CONST_FEAT_WEAPON_FOCUS_CLUB = 644;
const int IP_CONST_FEAT_WEAPON_FOCUS_CREATURE = 645;
const int IP_CONST_FEAT_WEAPON_FOCUS_DAGGER = 646;
const int IP_CONST_FEAT_WEAPON_FOCUS_DART = 647;
const int IP_CONST_FEAT_WEAPON_FOCUS_DIRE_MACE = 648;
const int IP_CONST_FEAT_WEAPON_FOCUS_DOUBLE_AXE = 649;
const int IP_CONST_FEAT_WEAPON_FOCUS_DWAXE = 650;
const int IP_CONST_FEAT_WEAPON_FOCUS_GREAT_AXE = 651;
const int IP_CONST_FEAT_WEAPON_FOCUS_GREAT_SWORD = 652;
const int IP_CONST_FEAT_WEAPON_FOCUS_HALBERD = 653;
const int IP_CONST_FEAT_WEAPON_FOCUS_HAND_AXE = 654;
const int IP_CONST_FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW = 655;
const int IP_CONST_FEAT_WEAPON_FOCUS_HEAVY_FLAIL = 656;
const int IP_CONST_FEAT_WEAPON_FOCUS_KAMA = 657;
const int IP_CONST_FEAT_WEAPON_FOCUS_KATANA = 658;
const int IP_CONST_FEAT_WEAPON_FOCUS_KUKRI = 659;
const int IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW = 660;
const int IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_FLAIL = 661;
const int IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_HAMMER = 662;
const int IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_MACE = 663;
const int IP_CONST_FEAT_WEAPON_FOCUS_LONGBOW = 664;
const int IP_CONST_FEAT_WEAPON_FOCUS_LONG_SWORD = 665;
const int IP_CONST_FEAT_WEAPON_FOCUS_MORNING_STAR = 666;
const int IP_CONST_FEAT_WEAPON_FOCUS_RAPIER = 667;
const int IP_CONST_FEAT_WEAPON_FOCUS_SCIMITAR = 668;
const int IP_CONST_FEAT_WEAPON_FOCUS_SCYTHE = 669;
const int IP_CONST_FEAT_WEAPON_FOCUS_SHORTBOW = 670;
const int IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD = 671;
const int IP_CONST_FEAT_WEAPON_FOCUS_SHURIKEN = 672;
const int IP_CONST_FEAT_WEAPON_FOCUS_SICKLE = 673;
const int IP_CONST_FEAT_WEAPON_FOCUS_SLING = 674;
const int IP_CONST_FEAT_WEAPON_FOCUS_SPEAR = 675;
const int IP_CONST_FEAT_WEAPON_FOCUS_STAFF = 676;
const int IP_CONST_FEAT_WEAPON_FOCUS_THROWING_AXE = 677;
const int IP_CONST_FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD = 678;
const int IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE = 679;
const int IP_CONST_FEAT_WEAPON_FOCUS_WAR_HAMMER = 680;
const int IP_CONST_FEAT_WEAPON_FOCUS_WHIP = 681;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_BASTARDSWORD = 682;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_BATTLEAXE = 683;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_CLUB = 684;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_DAGGER = 685;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_DIREMACE = 686;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_DOUBLEAXE = 687;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_DWAXE = 688;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATAXE = 689;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_GREATSWORD = 690;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_HALBERD = 691;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_HANDAXE = 692;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL = 693;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_KAMA = 694;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_KATANA = 695;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_KUKRI = 696;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL = 697;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER = 698;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_LIGHTMACE = 699;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_LONGSWORD = 700;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_MORNINGSTAR = 701;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF = 702;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_RAPIER = 703;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_SCIMITAR = 704;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_SCYTHE = 705;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSPEAR = 706;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_SHORTSWORD = 707;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_SICKLE = 708;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD = 709;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_WARHAMMER = 710;
const int IP_CONST_FEAT_WEAPON_OF_CHOICE_WHIP = 711;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD = 712;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE = 713;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB = 714;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_CREATURE = 715;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER = 716;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_DART = 717;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE = 718;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE = 719;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE = 720;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE = 721;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD = 722;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD = 723;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE = 724;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW = 725;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL = 726;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA = 727;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA = 728;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI = 729;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW = 730;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL = 731;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER = 732;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE = 733;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONGBOW = 734;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD = 735;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR = 736;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER = 737;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR = 738;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE = 739;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORTBOW = 740;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD = 741;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHURIKEN = 742;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE = 743;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SLING = 744;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR = 745;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF = 746;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE = 747;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD = 748;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER = 749;
const int IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP = 750;
const int IP_CONST_FEAT_WOODLAND_STRIDE = 751;
const int IP_CONST_FEAT_ZEN_ARCHERY = 752;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD = 753;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE = 754;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_CLUB = 755;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_CREATURE = 756;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER = 757;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DART = 758;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE = 759;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE = 760;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE = 761;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE = 762;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD = 763;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD = 764;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE = 765;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW = 766;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL = 767;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KAMA = 768;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KATANA = 769;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI = 770;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW = 771;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL = 772;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER = 773;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE = 774;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW = 775;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD = 776;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR = 777;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF = 778;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER = 779;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR = 780;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE = 781;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW = 782;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR = 783;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD = 784;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN = 785;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE = 786;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_SLING = 787;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE = 788;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD = 789;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED = 790;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER = 791;
const int IP_CONST_FEAT_EPIC_DEVASTATING_CRITICAL_WHIP = 792;
const int IP_CONST_FEAT_AIR_DOMAIN_POWER = 793;
const int IP_CONST_FEAT_ANIMAL_DOMAIN_POWER = 794;
const int IP_CONST_FEAT_DEATH_DOMAIN_POWER = 795;
const int IP_CONST_FEAT_DESTRUCTION_DOMAIN_POWER = 796;
const int IP_CONST_FEAT_EARTH_DOMAIN_POWER = 797;
const int IP_CONST_FEAT_EVIL_DOMAIN_POWER = 798;
const int IP_CONST_FEAT_FIRE_DOMAIN_POWER = 799;
const int IP_CONST_FEAT_GOOD_DOMAIN_POWER = 800;
const int IP_CONST_FEAT_HEALING_DOMAIN_POWER = 801;
const int IP_CONST_FEAT_KNOWLEDGE_DOMAIN_POWER = 802;
const int IP_CONST_FEAT_MAGIC_DOMAIN_POWER = 803;
const int IP_CONST_FEAT_PLANT_DOMAIN_POWER = 804;
const int IP_CONST_FEAT_PROTECTION_DOMAIN_POWER = 805;
const int IP_CONST_FEAT_STRENGTH_DOMAIN_POWER = 806;
const int IP_CONST_FEAT_SUN_DOMAIN_POWER = 807;
const int IP_CONST_FEAT_TRAVEL_DOMAIN_POWER = 808;
const int IP_CONST_FEAT_TRICKERY_DOMAIN_POWER = 809;
const int IP_CONST_FEAT_WAR_DOMAIN_POWER = 810;
const int IP_CONST_FEAT_WATER_DOMAIN_POWER = 811;


////////////////////////////////////////////////////////////////////////////////
// CEP DAMAGE BONUS CONSTANTS
////////////////////////////////////////////////////////////////////////////////
const int CEP_IP_CONST_DAMAGEBONUS_3d4 = 31;
const int CEP_IP_CONST_DAMAGEBONUS_4d4 = 32;
const int CEP_IP_CONST_DAMAGEBONUS_5d4 = 33;
const int CEP_IP_CONST_DAMAGEBONUS_6d4 = 34;
const int CEP_IP_CONST_DAMAGEBONUS_7d4 = 35;
const int CEP_IP_CONST_DAMAGEBONUS_8d4 = 36;
const int CEP_IP_CONST_DAMAGEBONUS_9d4 = 37;
const int CEP_IP_CONST_DAMAGEBONUS_10d4 = 38;
const int CEP_IP_CONST_DAMAGEBONUS_3d6 = 39;
const int CEP_IP_CONST_DAMAGEBONUS_4d6 = 40;
const int CEP_IP_CONST_DAMAGEBONUS_5d6 = 41;
const int CEP_IP_CONST_DAMAGEBONUS_6d6 = 42;
const int CEP_IP_CONST_DAMAGEBONUS_7d6 = 43;
const int CEP_IP_CONST_DAMAGEBONUS_8d6 = 44;
const int CEP_IP_CONST_DAMAGEBONUS_9d6 = 45;
const int CEP_IP_CONST_DAMAGEBONUS_10d6 = 46;
const int CEP_IP_CONST_DAMAGEBONUS_11d6 = 47;
const int CEP_IP_CONST_DAMAGEBONUS_12d6 = 48;
const int CEP_IP_CONST_DAMAGEBONUS_13d6 = 49;
const int CEP_IP_CONST_DAMAGEBONUS_14d6 = 50;
const int CEP_IP_CONST_DAMAGEBONUS_15d6 = 51;
const int CEP_IP_CONST_DAMAGEBONUS_3d8 = 52;
const int CEP_IP_CONST_DAMAGEBONUS_4d8 = 53;
const int CEP_IP_CONST_DAMAGEBONUS_5d8 = 54;
const int CEP_IP_CONST_DAMAGEBONUS_6d8 = 55;
const int CEP_IP_CONST_DAMAGEBONUS_7d8 = 56;
const int CEP_IP_CONST_DAMAGEBONUS_8d8 = 57;
const int CEP_IP_CONST_DAMAGEBONUS_9d8 = 58;
const int CEP_IP_CONST_DAMAGEBONUS_10d8 = 59;
const int CEP_IP_CONST_DAMAGEBONUS_11d8 = 60;
const int CEP_IP_CONST_DAMAGEBONUS_12d8 = 61;
const int CEP_IP_CONST_DAMAGEBONUS_13d8 = 62;
const int CEP_IP_CONST_DAMAGEBONUS_14d8 = 63;
const int CEP_IP_CONST_DAMAGEBONUS_15d8 = 64;
const int CEP_IP_CONST_DAMAGEBONUS_3d10 = 65;
const int CEP_IP_CONST_DAMAGEBONUS_4d10 = 66;
const int CEP_IP_CONST_DAMAGEBONUS_5d10 = 67;
const int CEP_IP_CONST_DAMAGEBONUS_6d10 = 68;
const int CEP_IP_CONST_DAMAGEBONUS_7d10 = 69;
const int CEP_IP_CONST_DAMAGEBONUS_8d10 = 70;
const int CEP_IP_CONST_DAMAGEBONUS_9d10 = 71;
const int CEP_IP_CONST_DAMAGEBONUS_10d10 = 72;
const int CEP_IP_CONST_DAMAGEBONUS_11d10 = 73;
const int CEP_IP_CONST_DAMAGEBONUS_12d10 = 74;
const int CEP_IP_CONST_DAMAGEBONUS_13d10 = 75;
const int CEP_IP_CONST_DAMAGEBONUS_14d10 = 76;
const int CEP_IP_CONST_DAMAGEBONUS_15d10 = 77;
const int CEP_IP_CONST_DAMAGEBONUS_3d12 = 78;
const int CEP_IP_CONST_DAMAGEBONUS_4d12 = 79;
const int CEP_IP_CONST_DAMAGEBONUS_5d12 = 80;
const int CEP_IP_CONST_DAMAGEBONUS_6d12 = 81;
const int CEP_IP_CONST_DAMAGEBONUS_7d12 = 82;
const int CEP_IP_CONST_DAMAGEBONUS_8d12 = 83;
const int CEP_IP_CONST_DAMAGEBONUS_9d12 = 84;
const int CEP_IP_CONST_DAMAGEBONUS_10d12 = 85;
const int CEP_IP_CONST_DAMAGEBONUS_3d20 = 86;
const int CEP_IP_CONST_DAMAGEBONUS_4d20 = 87;
const int CEP_IP_CONST_DAMAGEBONUS_5d20 = 88;
const int CEP_IP_CONST_DAMAGEBONUS_6d20 = 89;
const int CEP_IP_CONST_DAMAGEBONUS_7d20 = 90;
const int CEP_IP_CONST_DAMAGEBONUS_8d20 = 91;
const int CEP_IP_CONST_DAMAGEBONUS_9d20 = 92;
const int CEP_IP_CONST_DAMAGEBONUS_10d20 = 93;
const int CEP_IP_CONST_DAMAGEBONUS_11d20 = 94;
const int CEP_IP_CONST_DAMAGEBONUS_12d20 = 95;
const int CEP_IP_CONST_DAMAGEBONUS_13d20 = 96;
const int CEP_IP_CONST_DAMAGEBONUS_14d20 = 97;
const int CEP_IP_CONST_DAMAGEBONUS_15d20 = 98;
const int CEP_IP_CONST_DAMAGEBONUS_16d20 = 99;
const int CEP_IP_CONST_DAMAGEBONUS_17d20 = 100;
const int CEP_IP_CONST_DAMAGEBONUS_18d20 = 101;
const int CEP_IP_CONST_DAMAGEBONUS_19d20 = 102;
const int CEP_IP_CONST_DAMAGEBONUS_20d20 = 103;
const int CEP_IP_CONST_DAMAGEBONUS_21d20 = 104;
const int CEP_IP_CONST_DAMAGEBONUS_22d20 = 105;
const int CEP_IP_CONST_DAMAGEBONUS_23d20 = 106;
const int CEP_IP_CONST_DAMAGEBONUS_24d20 = 107;
const int CEP_IP_CONST_DAMAGEBONUS_25d20 = 108;
const int CEP_IP_CONST_DAMAGEBONUS_26d20 = 109;
const int CEP_IP_CONST_DAMAGEBONUS_27d20 = 110;
const int CEP_IP_CONST_DAMAGEBONUS_28d20 = 111;
const int CEP_IP_CONST_DAMAGEBONUS_29d20 = 112;
const int CEP_IP_CONST_DAMAGEBONUS_30d20 = 113;
const int CEP_IP_CONST_DAMAGEBONUS_31d20 = 114;
const int CEP_IP_CONST_DAMAGEBONUS_32d20 = 115;
const int CEP_IP_CONST_DAMAGEBONUS_33d20 = 116;
const int CEP_IP_CONST_DAMAGEBONUS_34d20 = 117;
const int CEP_IP_CONST_DAMAGEBONUS_35d20 = 118;
const int CEP_IP_CONST_DAMAGEBONUS_36d20 = 119;
const int CEP_IP_CONST_DAMAGEBONUS_37d20 = 120;
const int CEP_IP_CONST_DAMAGEBONUS_38d20 = 121;
const int CEP_IP_CONST_DAMAGEBONUS_39d20 = 122;
const int CEP_IP_CONST_DAMAGEBONUS_40d20 = 123;
const int CEP_IP_CONST_DAMAGEBONUS_11d12 = 124;
const int CEP_IP_CONST_DAMAGEBONUS_12d12 = 125;
const int CEP_IP_CONST_DAMAGEBONUS_13d12 = 126;
const int CEP_IP_CONST_DAMAGEBONUS_14d12 = 127;
const int CEP_IP_CONST_DAMAGEBONUS_15d12 = 128;
const int CEP_IP_CONST_DAMAGEBONUS_16d12 = 129;
const int CEP_IP_CONST_DAMAGEBONUS_17d12 = 130;
const int CEP_IP_CONST_DAMAGEBONUS_18d12 = 131;
const int CEP_IP_CONST_DAMAGEBONUS_19d12 = 132;
const int CEP_IP_CONST_DAMAGEBONUS_20d12 = 133;
const int CEP_IP_CONST_DAMAGEBONUS_11d4 = 134;
const int CEP_IP_CONST_DAMAGEBONUS_12d4 = 135;
const int CEP_IP_CONST_DAMAGEBONUS_13d4 = 136;
const int CEP_IP_CONST_DAMAGEBONUS_14d4 = 137;
const int CEP_IP_CONST_DAMAGEBONUS_15d4 = 138;
const int CEP_IP_CONST_DAMAGEBONUS_16d4 = 139;
const int CEP_IP_CONST_DAMAGEBONUS_17d4 = 140;
const int CEP_IP_CONST_DAMAGEBONUS_18d4 = 141;
const int CEP_IP_CONST_DAMAGEBONUS_19d4 = 142;
const int CEP_IP_CONST_DAMAGEBONUS_20d4 = 143;
const int CEP_IP_CONST_DAMAGEBONUS_16d6 = 144;
const int CEP_IP_CONST_DAMAGEBONUS_17d6 = 145;
const int CEP_IP_CONST_DAMAGEBONUS_18d6 = 146;
const int CEP_IP_CONST_DAMAGEBONUS_19d6 = 147;
const int CEP_IP_CONST_DAMAGEBONUS_20d6 = 148;
const int CEP_IP_CONST_DAMAGEBONUS_16d8 = 149;
const int CEP_IP_CONST_DAMAGEBONUS_17d8 = 150;
const int CEP_IP_CONST_DAMAGEBONUS_18d8 = 151;
const int CEP_IP_CONST_DAMAGEBONUS_19d8 = 152;
const int CEP_IP_CONST_DAMAGEBONUS_20d8 = 153;
const int CEP_IP_CONST_DAMAGEBONUS_16d10 = 154;
const int CEP_IP_CONST_DAMAGEBONUS_17d10 = 155;
const int CEP_IP_CONST_DAMAGEBONUS_18d10 = 156;
const int CEP_IP_CONST_DAMAGEBONUS_19d10 = 157;
const int CEP_IP_CONST_DAMAGEBONUS_20d10 = 158;


const int TA_SPECIAL_ATTACK_AOO                = 65002;
const int TA_SPECIAL_ATTACK_CALLED_SHOT_ARM    = 65001;
const int TA_SPECIAL_ATTACK_CALLED_SHOT_LEG    = 65000;
const int TA_SPECIAL_ATTACK_CLEAVE             = 6;
const int TA_SPECIAL_ATTACK_CLEAVE_GREAT       = 391;
const int TA_SPECIAL_ATTACK_DISARM             = 9;
const int TA_SPECIAL_ATTACK_DISARM_IMPROVED    = 16;
const int TA_SPECIAL_ATTACK_KI_DAMAGE          = 882;
const int TA_SPECIAL_ATTACK_KNOCKDOWN          = 23;
const int TA_SPECIAL_ATTACK_KNOCKDOWN_IMPROVED = 17;
const int TA_SPECIAL_ATTACK_QUIVERING_PALM     = 296;
const int TA_SPECIAL_ATTACK_SAP                = 31;
const int TA_SPECIAL_ATTACK_SMITE_EVIL         = 301;
const int TA_SPECIAL_ATTACK_SMITE_GOOD         = 472;
const int TA_SPECIAL_ATTACK_STUNNING_FIST      = 39;


const int STYLE_INVALID               = 0;
const int STYLE_FIGHTER_FENCER        = 1;
const int STYLE_FIGHTER_KENSEI        = 2;
const int STYLE_FIGHTER_SPARTAN       = 3;
const int STYLE_FIGHTER_WARLORD       = 4;
const int STYLE_MONK_BEAR_CLAW        = 5;
const int STYLE_MONK_DRAGON_PALM      = 6;
const int STYLE_MONK_SUN_FIST         = 7;
const int STYLE_MONK_TIGER_FANG       = 8;
const int STYLE_ASSASSIN_NINJA        = 9;

const int STYLE_DRAGON_RED            = 0;
const int STYLE_DRAGON_BLUE           = 1;
const int STYLE_DRAGON_BRASS          = 2;
const int STYLE_DRAGON_GOLD           = 3;
const int STYLE_DRAGON_GREEN          = 4;

const int PHENOTYPE_KENSEI            = 15;
const int PHENOTYPE_NINJA             = 16;
const int PHENOTYPE_WARLORD           = 17;
const int PHENOTYPE_FENCER            = 18;
const int PHENOTYPE_ARCANE            = 19;
const int PHENOTYPE_DEMON_BLADE       = 20;
const int PHENOTYPE_SPARTAN           = 21;
const int PHENOTYPE_TIGER_FANG        = 30;
const int PHENOTYPE_SUN_FIST          = 31;
const int PHENOTYPE_DRAGON_PALM       = 32;
const int PHENOTYPE_BEAR_CLAW         = 33;
