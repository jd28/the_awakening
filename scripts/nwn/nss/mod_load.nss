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
#include "mod_funcs_inc"

void InfoHashInit();
void InitWeaponFeats();
void InitializeWanderingSpirit();

void main(){
    // -------------------------------------------------------------------------
    // Execute default Bioware Script.
    // -------------------------------------------------------------------------
    ExecuteScript("x3_mod_def_load", OBJECT_SELF);
	SetColorTokens();
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
	SetHakHidden("wrm_mirkwood", 2);
	SetHakHidden("civ_ls_001", 2);

    // No Show
    SetHakHidden("ta_summon", 99);

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

    SQLExecDirect("SELECT UNIX_TIMESTAMP();");
    if (SQLFetch() == SQL_SUCCESS){
        nBootTime = StringToInt(SQLGetData(1));
        SetLocalInt(GetModule(), "BootTime", nBootTime);

        WriteTimestampedLogEntry("LOG : mod_load : Boot Time: " + IntToString(nBootTime));
    }
    else{
        WriteTimestampedLogEntry("ERROR : mod_load : Failed get boot time.");
    }

    ExecuteScript("ta_mod_load", OBJECT_SELF);

    // -------------------------------------------------------------------------
    // SIMTools -- Init placeholders for chat gateway
    // -------------------------------------------------------------------------
    InitSpeech();

    // Create Information Hashes
    DelayCommand(0.2, InfoHashInit());

    ExecuteScript("mod_init_sphash", OBJECT_SELF);

    WriteTimestampedLogEntry("Attempting to Load SSE");
    DelayCommand(1.0f, ExecuteScript("sha_on_modload", OBJECT_SELF));

    SetGlobalEventHandler(EVENT_TYPE_USE_FEAT, "pl_feat_event");

    object oArea = GetFirstArea();
    float fDelay = 0.0;
    while(GetIsObjectValid(oArea)){
        AssignCommand(GetModule(), DelayCommand(fDelay, ExecuteScript("mod_init_areas", oArea)));
        fDelay += 0.2;
        oArea = GetNextArea();
    }

    // -------------------------------------------------------------------------
    // Quests
    // -------------------------------------------------------------------------
    DelayCommand(2.0, SpawnDeltaKey());

	object way = GetObjectByTag("wp_sp_pos_1", d4() - 1);
	if (GetIsObjectValid(way)) {
		location loc = GetLocation(way);
		object wander = CreateObject(OBJECT_TYPE_CREATURE, "pl_wander_spirit", loc);
		if (GetIsObjectValid(wander)) {
			WriteTimestampedLogEntry("NOTICE : Wandering Spirit Spawned");
		}
		else {
			WriteTimestampedLogEntry("ERROR : Wandering Spirit Failed to spawn");
		}
	}
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
            if(sValue == "") nValue = -1;
            else nValue = StringToInt(sValue);

            SetHashString(OBJECT_SELF, VAR_HASH_FEAT_NAME, IntToString(i), GetStringByStrRef(nValue));
        }
        WriteTimestampedLogEntry("HASHSET: Creation of " + VAR_HASH_FEAT_NAME + " was successful!");
    }

}
