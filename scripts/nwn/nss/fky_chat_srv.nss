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

//This script is included for the sake of completeness. It fires whenever a server channel message is sent.
void main(){

    object oSender = OBJECT_SELF, oRecipient = GetFirstPC();// Speaker = oPC
    string sText, sLogMessage, sLogMessageTarget, sType, sSort;
    int nChannel, nTarget;
/////////////////////////Gather Message and Target Data/////////////////////////
    SetLocalString(oSender, "NWNX!CHAT!TEXT", Speech_GetSpacer()); // Query for chattext
    sText = GetLocalString(oSender, "NWNX!CHAT!TEXT"); // Get chattext

//    Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_NONE, sText);

    nChannel = StringToInt(GetStringLeft(sText, 2)); // Get channel
    nTarget = StringToInt(GetSubString(sText, 2, 10)); // Target ID - Return value of -1 is no target. IE, not a tell/privatemessage
    sText = GetStringRight(sText, GetStringLength(sText) - 12);// Remove Target & Channel Info

    if(GetStringLeft(sText, 3) == "You"){
        SetLocalString(oSender, "NWNX!CHAT!SUPRESS", "1");
//        Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_NONE, "Server Message Supressed: %s", sText);
    }

    DoCleanup(oSender);
}


