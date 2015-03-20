#include "fky_chat_inc"
//#include "leto_inc"
#include "sha_subr_methds"
#include "pl_pvp_inc"
#include "nwnx_solstice"

void main(){
    object oPC          = GetExitingObject();
    object oMod         = GetModule();
    string sPlayerName  = GetLocalString(oPC, VAR_PC_PLAYER_NAME);
    string sName        = GetName(oPC);
    string sIP          = GetLocalString(oPC, VAR_PC_IP_ADDRESS);
    string sCDKey       = GetLocalString(oPC, VAR_PC_CDKEY);
    string sUID         = GetTag(oPC);
    string sLog;

    //SSE
    SubraceOnClientLeave();

    object oShade = GetLocalObject(oPC, "X0_L_MYSHADE");
    if(GetIsObjectValid(oShade)){
        AssignCommand(oShade, SetIsDestroyable(TRUE));
        DestroyObject(oShade);
    }

    if(GetLocalInt(GetModule(), "PVP_ACTIVE"))
        PVPModLeave(oPC);

    // -------------------------------------------------------------------------
    // Write log entry for players leaving
    // -------------------------------------------------------------------------
    sLog = "CLIENT LEAVE : ";
    sLog += "Player: " + sPlayerName;
    sLog += " / ";
    sLog += "Name: " + sName;
    sLog += " / ";
    sLog += "CDKey: " + sCDKey;
    sLog += " / ";
    sLog += "IP: " + sIP;

    //Write a log entry of the info
    WriteTimestampedLogEntry("LOG : " + sLog);
    SendMessageToAllDMs(sLog);

    if(sUID == "") return;



    // No windows on the rest.
    if(GetLocalInt(oMod, VAR_MOD_DEV) > 1) return;


	if(GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)) {
		int nHP = (GetIsDead(oPC) ? -1 : ModifyCurrentHitPoints(oPC, 0));
		if (nHP <= 0){ nHP = -1; }
		SetDbInt(oPC, VAR_PC_HP, nHP, 7);

		int nBanked = GetLocalInt(oPC, VAR_PC_XP_BANK);
		SetDbInt(oPC, VAR_PC_XP_BANK, nBanked, 0, TRUE);
		Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_DEBUG,
			   "Attempting to set  XP Bank to %sXP in %s's bank.",
			   IntToString(nBanked), GetPCPlayerName(oPC));

		ExecuteScript("ta_update_kills", oPC);

		if(GetLocalInt(GetArea(oPC), "area_dmg") == 13)
			SetLocalInt(oMod, "WATER_LOG_" + sUID, TRUE);
	}

    // -------------------------------------------------------------------------
    // SIMTools Stuff
    // -------------------------------------------------------------------------
    Speech_OnClientExit(oPC);

	ExecuteScript("pl_clear_effs", oPC);
	NWNXSolstice_RemoveFromObjectCache(oPC);
}
