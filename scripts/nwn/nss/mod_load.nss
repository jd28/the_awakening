//::///////////////////////////////////////////////
//:: Example XP2 OnLoad Script
//:: x2_mod_def_load
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "fky_chat_inc"
#include "nwnx_inc"
#include "area_inc"
#include "quest_func_inc"

void InfoHashInit();
void InitWeaponFeats();
void InitializeWanderingSpirit();

void main(){
    NWNXSolstice_LoadConstants();
    // -------------------------------------------------------------------------
    // Execute default Bioware Script.
    // -------------------------------------------------------------------------
    ExecuteScript("x3_mod_def_load", OBJECT_SELF);

    SetMaxLevelLimit(60);
    SetEnhanceScript("pl_load_enhance");

    SetFallBackTLK("cep23_v1");
    // Basic
    SetHakHidden("ta_top_v01");

    // Full
    SetHakHidden("az2-noleaves", 2);
    SetHakHidden("az2", 2);
    SetHakHidden("ctp_common", 2);
    SetHakHidden("ctp_loadscreens", 2);
    SetHakHidden("ctp_blk_desert", 2);
    SetHakHidden("ctp_brick_int", 2);
    SetHakHidden("ctp_cave_ruins", 2);
    SetHakHidden("ctp_dungeon_lok", 2);
    SetHakHidden("ctp_elf_interior", 2);
    SetHakHidden("ctp_exp_elf_city", 2);
    SetHakHidden("ctp_goth_estate", 2);
    SetHakHidden("ctp_goth_int", 2);
    SetHakHidden("~catacomb", 2);
    SetHakHidden("~dchasm", 2);
    SetHakHidden("~wildwoods", 2);
    SetHakHidden("~sewer", 2);
    SetHakHidden("ta_tile_maxam", 2);
    SetHakHidden("pk_top_v2.2", 2);
    SetHakHidden("pk_rocky_v11.5", 2);
    SetHakHidden("pk_swamps_v3.0", 2);
    SetHakHidden("pk_elven_v2.1", 2);
    SetHakHidden("pk_textures_v2.0", 2);

    // No Show
    SetHakHidden("ta_summon", 99);

    int version = GetLocalInt(GetModule(), "VERSION");

    if ( version <= 1 ) {
        // -------------------------------------------------------------------------
        // Set nwnx_weapons options - Dev crit no longer kills, but gives +1 to
        //   crit multiplier, overwhelming crit gives +1 to crit range
        // -------------------------------------------------------------------------
        SetWeaponOption(NWNX_WEAPONS_OPT_DEVCRIT_DISABLE_ALL,      TRUE);
        SetWeaponOption(NWNX_WEAPONS_OPT_DEVCRIT_MULT_BONUS,       1);
        SetWeaponOption(NWNX_WEAPONS_OPT_DEVCRIT_MULT_STACK,       TRUE);
        SetWeaponOption(NWNX_WEAPONS_OPT_OVERCRIT_RANGE_BONUS,     1);
        SetWeaponOption(NWNX_WEAPONS_OPT_LEGSPEC_DAM_BONUS,        1);

        SetWeaponFinesseSize(BASE_ITEM_KATANA, CREATURE_SIZE_MEDIUM);

        InitWeaponFeats();

        SetCustomEffectHandler (TA_EFFECT_ONHAND_ATTACKS, "eff_atton");
        SetCustomEffectHandler (TA_EFFECT_OFFHAND_ATTACKS, "eff_attoff");
        SetCustomEffectHandler (TA_EFFECT_DC_INCREASE, "eff_dc_inc");
        SetCustomEffectHandler (TA_EFFECT_DC_DECREASE, "eff_dc_dec");
        SetCustomEffectHandler (TA_EFFECT_OATH_OF_WRATH, "eff_oathwrath");
        SetCustomEffectHandler (TA_EFFECT_MOVEMENT_RATE, "eff_moverate");

        SetSpecialAttackHandler(NWNX_SPECIAL_ATTACK_KNOCKDOWN, "spat_knockdown");
        SetSpecialAttackHandler(NWNX_SPECIAL_ATTACK_KNOCKDOWN_IMPROVED, "spat_knockdown");
        SetSpecialAttackHandler(NWNX_SPECIAL_ATTACK_SMITE_GOOD, "spat_smitegood");
        SetSpecialAttackHandler(NWNX_SPECIAL_ATTACK_SMITE_EVIL, "spat_smiteevil");
    }
    else if ( version >= 2 ) {
         NWNXCombat_InitTables();
    }

    // -------------------------------------------------------------------------
    // Set Spellhook
    // -------------------------------------------------------------------------
    SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "mod_spellhook");

    // -------------------------------------------------------------------------
    // If we are deving on a windows machine, quit nothing else will work.
    // -------------------------------------------------------------------------
    if(GetLocalInt(GetModule(), VAR_MOD_DEV) > 1)
        return;

    // -------------------------------------------------------------------------
    // Set Too Many Instruction Limit
    // -------------------------------------------------------------------------
    SetTMILimit(262143); // Double normal limit

    // -------------------------------------------------------------------------
    // Database -- Init placeholders for ODBC gateway
    // -------------------------------------------------------------------------
    SQLInit();

    // Set Boot time
    int nBootTime;

    SQLExecDirect("SELECT UNIX_TIMESTAMP()");
    if (SQLFetch() == SQL_SUCCESS){
        nBootTime = StringToInt(SQLGetData(1));
        SetLocalInt(GetModule(), "BootTime", nBootTime);

        WriteTimestampedLogEntry("LOG : mod_load : Boot Time: " + IntToString(nBootTime));
    }
    else{
        WriteTimestampedLogEntry("ERROR : mod_load : Failed get boot time.");
    }

    SQLExecDirect("SELECT cdkey, status FROM admin_dm");
    while (SQLFetch() == SQL_SUCCESS){
       string key = SQLGetData(1);
       string val = SQLGetData(2);
       WriteTimestampedLogEntry("LOG : mod_load : Adding key: " + key + " : " + val);
       SetLocalInt(GetModule(), key, StringToInt(val));
    }

    // -------------------------------------------------------------------------
    // SIMTools -- Init placeholders for chat gateway
    // -------------------------------------------------------------------------
    InitSpeech();

    // Create Information Hashes
    DelayCommand(0.2, InfoHashInit());

    ExecuteScript("mod_init_sphash", OBJECT_SELF);

    WriteTimestampedLogEntry("Attempting to Load SSE");
    DelayCommand(1.0f, ExecuteScript("sha_on_modload", OBJECT_SELF));

    if ( version != 2 ) {
        // -------------------------------------------------------------------------
        // Set nwnx_defenses - Seperate crit immunity and sneak/death attack immunity
        // -------------------------------------------------------------------------
        SetDefenseOption (NWNX_DEFENSES_OPT_DEATHATT_IGNORE_CRIT_IMM, TRUE);
        SetDefenseOption (NWNX_DEFENSES_OPT_SNEAKATT_IGNORE_CRIT_IMM, TRUE);
    }

    SetGlobalEventHandler(EVENT_TYPE_USE_FEAT, "pl_feat_event");

    object oArea = GetFirstArea();
    float fDelay = 0.0;
    while(GetIsObjectValid(oArea)){
        AssignCommand(GetModule(), DelayCommand(fDelay, ExecuteScript("mod_init_areas", oArea)));
        fDelay += 0.2;
        oArea = GetNextArea();
    }

    DelayCommand(1.5, InitializeWanderingSpirit());
    // -------------------------------------------------------------------------
    // Quests
    // -------------------------------------------------------------------------
    DelayCommand(2.0, SpawnDeltaKey());
}

void InfoHashInit(){
    int i, nValue;
    string sValue, sSchool, sSpellLevel, sHostile;

    // Feat Names
    if(!CreateHash(GetModule(), VAR_HASH_FEAT_NAME, MAX_FEAT_NUM)){
        WriteTimestampedLogEntry("ERROR : HASHSET : Creation of " + VAR_HASH_FEAT_NAME + " has failed!");
    }
    else{
        for(i = 0; i < MAX_FEAT_NUM; i++){
            sValue = Get2DAString("featnames", "FEAT", i);
            if(sValue == "****") nValue = -1;
            else nValue = StringToInt(sValue);

            SetHashString(OBJECT_SELF, VAR_HASH_FEAT_NAME, IntToString(i), GetStringByStrRef(nValue));
        }
        WriteTimestampedLogEntry("HASHSET: Creation of " + VAR_HASH_FEAT_NAME + " was successful!");
    }

}

void InitWeaponFeats(){
    int nBaseItem;

    // Superior Epic Specializations for Normal Base Items.
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_CLUB, TA_FEAT_SUP_WEAPON_SPECIALIZATION_CLUB);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_DAGGER, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DAGGER);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_DART, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DART);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_HEAVYCROSSBOW, TA_FEAT_SUP_WEAPON_SPECIALIZATION_HEAVYCROSSBOW);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LIGHTCROSSBOW, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTCROSSBOW);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LIGHTMACE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTMACE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_MORNINGSTAR, TA_FEAT_SUP_WEAPON_SPECIALIZATION_MORNINGSTAR);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_QUARTERSTAFF, TA_FEAT_SUP_WEAPON_SPECIALIZATION_QUARTERSTAFF);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SHORTSPEAR, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTSPEAR);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SICKLE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SLING, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SLING);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_GLOVES, TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LONGBOW, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LONGBOW);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SHORTBOW, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTBOW);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SHORTSWORD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTSWORD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_RAPIER, TA_FEAT_SUP_WEAPON_SPECIALIZATION_RAPIER);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SCIMITAR, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SCIMITAR);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LONGSWORD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LONGSWORD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_GREATSWORD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_HANDAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_HANDAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_THROWINGAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_THROWINGAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_BATTLEAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_BATTLEAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_GREATAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_HALBERD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_HALBERD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LIGHTHAMMER, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTHAMMER);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_LIGHTFLAIL, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTFLAIL);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_WARHAMMER, TA_FEAT_SUP_WEAPON_SPECIALIZATION_WARHAMMER);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_HEAVYFLAIL, TA_FEAT_SUP_WEAPON_SPECIALIZATION_HEAVYFLAIL);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_KAMA, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_KUKRI, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KUKRI);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SHURIKEN, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHURIKEN);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_SCYTHE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SCYTHE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_KATANA, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KATANA);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_BASTARDSWORD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_BASTARDSWORD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_DIREMACE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DIREMACE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_DOUBLEAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DOUBLEAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_TWOBLADEDSWORD, TA_FEAT_SUP_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_DWARVENWARAXE, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DWAXE);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_TRIDENT, TA_FEAT_SUP_WEAPON_SPECIALIZATION_TRIDENT);
    SetWeaponGreaterSpecializationFeat(BASE_ITEM_WHIP, TA_FEAT_SUP_WEAPON_SPECIALIZATION_WHIP);

    // Legendary Specializations for Normal Base Items.
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_CLUB, TA_FEAT_LEG_WEAPON_SPECIALIZATION_CLUB);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_DAGGER, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DAGGER);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_DART, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DART);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_HEAVYCROSSBOW, TA_FEAT_LEG_WEAPON_SPECIALIZATION_HEAVYCROSSBOW);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LIGHTCROSSBOW, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTCROSSBOW);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LIGHTMACE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTMACE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_MORNINGSTAR, TA_FEAT_LEG_WEAPON_SPECIALIZATION_MORNINGSTAR);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_QUARTERSTAFF, TA_FEAT_LEG_WEAPON_SPECIALIZATION_QUARTERSTAFF);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SHORTSPEAR, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTSPEAR);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SICKLE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SLING, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SLING);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_GLOVES, TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LONGBOW, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LONGBOW);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SHORTBOW, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTBOW);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SHORTSWORD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTSWORD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_RAPIER, TA_FEAT_LEG_WEAPON_SPECIALIZATION_RAPIER);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SCIMITAR, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SCIMITAR);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LONGSWORD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LONGSWORD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_GREATSWORD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_HANDAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_HANDAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_THROWINGAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_THROWINGAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_BATTLEAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_BATTLEAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_GREATAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_HALBERD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_HALBERD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LIGHTHAMMER, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTHAMMER);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_LIGHTFLAIL, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTFLAIL);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_WARHAMMER, TA_FEAT_LEG_WEAPON_SPECIALIZATION_WARHAMMER);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_HEAVYFLAIL, TA_FEAT_LEG_WEAPON_SPECIALIZATION_HEAVYFLAIL);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_KAMA, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_KUKRI, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KUKRI);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SHURIKEN, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHURIKEN);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_SCYTHE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SCYTHE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_KATANA, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KATANA);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_BASTARDSWORD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_BASTARDSWORD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_DIREMACE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DIREMACE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_DOUBLEAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DOUBLEAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_TWOBLADEDSWORD, TA_FEAT_LEG_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_DWARVENWARAXE, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DWAXE);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_TRIDENT, TA_FEAT_LEG_WEAPON_SPECIALIZATION_TRIDENT);
    SetWeaponLegendarySpecializationFeat(BASE_ITEM_WHIP, TA_FEAT_LEG_WEAPON_SPECIALIZATION_WHIP);


    // monk weapons.
    SetWeaponIsMonkWeapon(BASE_ITEM_QUARTERSTAFF, 1);
    SetWeaponIsMonkWeapon(BASE_ITEM_WINDFIREWHEEL, 1);
    SetWeaponIsMonkWeapon(BASE_ITEM_NUNCHAKU, 1);
    SetWeaponIsMonkWeapon(BASE_ITEM_SAI, 1);

    // Unarmed
    SetWeaponOfChoiceFeat(BASE_ITEM_GLOVES, 2047);

    // Creature Weapons -> Unarmed Attack
    nBaseItem = BASE_ITEM_CBLUDGWEAPON;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_UNARMED);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
    //SetWeaponOfChoiceFeat(nBaseItem, );
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED);

    nBaseItem = BASE_ITEM_CPIERCWEAPON;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_UNARMED);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
    //SetWeaponOfChoiceFeat(nBaseItem, );
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED);

    nBaseItem = BASE_ITEM_CSLASHWEAPON;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_UNARMED);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
    //SetWeaponOfChoiceFeat(nBaseItem, );
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED);

    nBaseItem = BASE_ITEM_CSLSHPRCWEAP;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_UNARMED);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_UNARMED);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE);
    //SetWeaponOfChoiceFeat(nBaseItem, );
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_UNARMED);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_UNARMED);

    // Assassin Dagger -> Dagger
    nBaseItem = BASE_ITEM_ASSASSINDAGGER;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_DAGGER);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_DAGGER);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_DAGGER);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_DAGGER);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_DAGGER);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_DAGGER);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_DAGGER);

    //Double Scimitar -> Two-bladed Sword
    nBaseItem = BASE_ITEM_DOUBLESCIMITAR;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_TWOBLADEDSWORD);

    //Falchion -> Great Sword
    nBaseItem = BASE_ITEM_FALCHION;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_GREATSWORD);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponFocusFeat(nBaseItem,FEAT_WEAPON_FOCUS_GREAT_SWORD);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_GREATSWORD);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATSWORD);

    //Falchion 2 -> Great Sword
    nBaseItem = BASE_ITEM_FALCHION_2;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_GREATSWORD);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponFocusFeat(nBaseItem,FEAT_WEAPON_FOCUS_GREAT_SWORD);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_GREATSWORD);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_GREATSWORD);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_GREATSWORD);

    // Heavy Mace -> Mace
    nBaseItem = BASE_ITEM_HEAVYMACE;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_LIGHT_MACE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_LIGHT_MACE);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_LIGHTMACE);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_LIGHTMACE);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_LIGHTMACE);

    // Maul -> Warhammer
    nBaseItem = BASE_ITEM_MAUL;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_WARHAMMER);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_WAR_HAMMER);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_WAR_HAMMER);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_WARHAMMER);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_WARHAMMER);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_WARHAMMER);

    // Light Pick -> Sickle
    nBaseItem = BASE_ITEM_LIGHTPICK;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_SICKLE);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_SICKLE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_SICKLE);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_SICKLE);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SICKLE);

    // Heavy Pick -> Sickle
    nBaseItem = BASE_ITEM_HEAVYPICK;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_SICKLE);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_SICKLE);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_SICKLE);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_SICKLE);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SICKLE);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SICKLE);

    // Katar -> Kukri
    nBaseItem = BASE_ITEM_KATAR;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_KUKRI);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_KUKRI);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_KUKRI);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_KUKRI);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_KUKRI);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KUKRI);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KUKRI);

    // Trident, 1-Handed -> Trident
    nBaseItem = BASE_ITEM_TRIDENT_ONE_HANDED;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_TRIDENT);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_TRIDENT);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_TRIDENT);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_TRIDENT);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_TRIDENT);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_TRIDENT);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_TRIDENT);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_TRIDENT);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_TRIDENT);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_TRIDENT);

    // Short Spear -> Spear
    nBaseItem = BASE_ITEM_SPEAR_SHORT;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_SPEAR);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_SPEAR);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_SHORTSPEAR);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_SPEAR);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_SHORTSPEAR);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_SHORTSPEAR);

    // Sai -> Kama
    nBaseItem = BASE_ITEM_SAI;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_KAMA);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_KAMA);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_KAMA);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_KAMA);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_KAMA);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KAMA);

    // Nunchuku -> Kama
    nBaseItem = BASE_ITEM_NUNCHAKU;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_KAMA);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_KAMA);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_KAMA);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_KAMA);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_KAMA);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KAMA);

    // Wind Fire Wheel -> Kama
    nBaseItem = BASE_ITEM_WINDFIREWHEEL;
    SetWeaponDevastatingCriticalFeat(nBaseItem, FEAT_EPIC_DEVASTATING_CRITICAL_KAMA);
    SetWeaponEpicFocusFeat(nBaseItem, FEAT_EPIC_WEAPON_FOCUS_KAMA);
    SetWeaponEpicSpecializationFeat(nBaseItem, FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponFocusFeat(nBaseItem, FEAT_WEAPON_FOCUS_KAMA);
    SetWeaponImprovedCriticalFeat(nBaseItem, FEAT_IMPROVED_CRITICAL_KAMA);
    SetWeaponOfChoiceFeat(nBaseItem, FEAT_WEAPON_OF_CHOICE_KAMA);
    SetWeaponOverwhelmingCriticalFeat(nBaseItem, FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA);
    SetWeaponSpecializationFeat(nBaseItem, FEAT_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponLegendarySpecializationFeat(nBaseItem, TA_FEAT_LEG_WEAPON_SPECIALIZATION_KAMA);
    SetWeaponGreaterSpecializationFeat(nBaseItem, TA_FEAT_SUP_WEAPON_SPECIALIZATION_KAMA);

}

void InitializeWanderingSpirit() {
    string way = "wp_pl_spirit_spawn_" + IntToString(1);
    object oWay = GetWaypointByTag(way);
    location loc = GetLocation(oWay);
    object area = GetArea(oWay);

    // let's go no further right now.
    if(TRUE || oWay == OBJECT_INVALID)
        return;

    SetLocalInt(area, "area_spawn", 1);

    CreateObject(OBJECT_TYPE_WAYPOINT, "wp_pl_spirit", loc);
}
