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

//This script exists only to make the spoken string trigger the chat script for
//command completion. The chat script will not fire again while it is already running,
//as a security procaution, so to force a PC to fire the script again from it we
//must have them DelayCommand(ExecuteScript()) this script.
void main()
{
    object oPC = OBJECT_SELF;
    string sCommand = GetLocalString(oPC, "FKY_CHAT_COMMAND_EXE");
    DeleteLocalString(oPC, "FKY_CHAT_COMMAND_EXE");
    SpeakString(sCommand);
}
