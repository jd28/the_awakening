//::////////////////////////////////////////////////////////////////////////:://
//:: SIMTools V3.0 Speech Integration & Management Tools Version 3.0        :://
//:: Created By: FunkySwerve                                                :://
//:: Created On: April 4 2006                                               :://
//:: Last Updated: March 27 2007                                            :://
//:: With Thanks To:                                                        :://
//:: Dumbo - for his amazing plugin                                         :://
//:: Virusman - for Linux versions, and for the reset plugin, and for       :://
//::    his excellent events plugin, without which this update would not    :://
//::    be possible                                                         :://
//:: Dazzle - for his script samples                                        :://
//:: Butch - for the emote wand scripts                                     :://
//:: The DMFI project - for the languages conversions and many of the emotes:://
//:: Lanessar and the players of the Myth Drannor PW - for the new languages:://
//:: The players and DMs of Higher Ground for their input and playtesting   :://
//::////////////////////////////////////////////////////////////////////////:://
#include "fky_chat_inc"

void main()
{
//////////////////////////////////Declarations//////////////////////////////////
    object oPC = OBJECT_SELF, oTarget;// Speaker = oPC
    string sText, sLogMessage, sLogMessageTarget, sType, sSort;
    int nChannel, nTarget, bAlias;
/////////////////////////Gather Message and Target Data/////////////////////////
    SetLocalString(oPC, "NWNX!CHAT!TEXT", Speech_GetSpacer()); // Query for chattext
    sText = GetLocalString(oPC, "NWNX!CHAT!TEXT"); // Get chattext
    nChannel = StringToInt(GetStringLeft(sText, 2)); // Get channel
    nTarget = StringToInt(GetSubString(sText, 2, 10)); // Target ID - Return value of -1 is no target. IE, not a tell/privatemessage
    sText = GetStringRight(sText, GetStringLength(sText) - 12);// Remove Target & Channel Info
    if( nTarget != -1 )// Acquire possible target
    {
        oTarget = Speech_GetPlayer(nTarget);
        sLogMessageTarget = "->" + GetName(oTarget) + "(" + GetPCPlayerName(oTarget) + ")";
///////////////////////////////////DM Stealth///////////////////////////////////
        if (GetLocalInt(oTarget, "FKY_CHAT_DMSTEALTH") && (oTarget != oPC)) {DoStealth(oPC, oTarget, sText, nChannel, sLogMessageTarget); return;}
    }

///////////////////////////////Command Completion///////////////////////////////

    sType = GetSubString(sText, 0, 1);//this is the primary sorting string, the leftmost letter of the text

     if (sType == EMOTE_SYMBOL){
        SetLocalString(oPC, "FKY_CHAT_PCSHUNT_TEXT", sText);
        SetLocalInt(oPC, "FKY_CHAT_PCSHUNT_CHANNEL", nChannel);
        //HandleEmotes(oPC, sText, nChannel);//emotes - taken from Emote-Wand V1000 UpDate Scripted By: Butch (with edits)
        ExecuteScript("fky_chat_emote", oPC);
    }
    else if (sType == COMMAND_SYMBOL){
        SetLocalObject(oPC, "FKY_CHAT_PCSHUNT_TARGET", oTarget);//these locals pass the needed values to the new script
        SetLocalString(oPC, "FKY_CHAT_PCSHUNT_TEXT", sText);
        SetLocalInt(oPC, "FKY_CHAT_PCSHUNT_CHANNEL", nChannel);
        //HandleCommands(oPC, oTarget, sText, nChannel);//commands
        ExecuteScript("fky_chat_pc_comm", oPC);
    }
    else if (sType == "/")// metachannels and languages
    {
        SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");
        sText = GetStringRight(sText, GetStringLength(sText) - 1);
        sSort = GetStringLeft(sText, 2);

        if ((VerifyDMKey(oPC) || VerifyAdminKey(oPC)) && sSort == "v ") HandleVentrilo(sText, oPC);//must be a space after the /v
        else FloatingTextStringOnCreature(C_RED+BADCHANNEL+C_END, oPC, FALSE);
    }
    else if ((GetStringLowerCase(GetStringLeft(sText, 3)) == "dm_") && (VerifyAdminKey(oPC) || VerifyDMKey(oPC)))
    {
        //HandleDMTraffic(oPC, oTarget, sText);//this has been moved to a new script to allow compiler to digest it
        SetLocalObject(oPC, "FKY_CHAT_DMSHUNT_TARGET", oTarget);//these locals pass the needed values to the new script
        SetLocalString(oPC, "FKY_CHAT_DMSHUNT_TEXT", sText);
        ExecuteScript("fky_chat_dm_comm", oPC);
    }
    else if (bAlias){
    //Aliased but no command...
        SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1"); //mute em
        if (GetLocalInt(oTarget, "FKY_CHT_IGNORE" + GetPCPlayerName(oPC))){
        //If ignored...don't sent the tell..
            SendMessageToPC(oPC, C_RED + GetName(oTarget)+ISIGNORED+C_END);//tell em
        }
        else{
            HandleAFK(oPC, oTarget);
            SendChatLogMessage(oTarget, sText, oPC);
        }
    }
    else HandleOtherSpeech(oPC, oTarget, sText, nChannel, sLogMessageTarget);




////////////////////////////////////Logging/////////////////////////////////////
    if (TEXT_LOGGING_ENABLED) DoLogging(oPC, sLogMessageTarget, nChannel, sText);
////////////////////////////////////Cleanup/////////////////////////////////////
    DoCleanup(oPC);
}
