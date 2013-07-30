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
//This script is only used by Linux users, to tell what conversation node was selected in the popup menus.
//The other events shown will work with the Linux version but are commented out

#include "fky_chat_instant"
#include "nwnx_inc"

void main(){

    int nEventType = GetEventType();
    //WriteTimestampedLogEntry("NWNX Event fired: "+IntToString(nEventType)+", '"+GetName(OBJECT_SELF)+"'");
    object oPC, oTarget, oItem;
    switch(nEventType){
        case EVENT_TYPE_PICKPOCKET:
            oPC = OBJECT_SELF;
            oTarget = GetEventTarget();
            WriteTimestampedLogEntry(GetName(oPC)+" tried to steal from "+GetName(oTarget));
        break;
        case EVENT_TYPE_USE_ITEM:
            oPC = OBJECT_SELF;
            oTarget = GetEventTarget();
            oItem = GetEventItem();
            //WriteTimestampedLogEntry(GetName(oPC)+" used item '"+GetName(oItem)+"' on "+GetName(oTarget));
            AssignCommand(GetFirstPC(), SpeakString("Target: "+ GetName(oTarget) + "; Item: " +GetName(oItem)));
            /*if(d2()==1)
            {
                SetLocalString(OBJECT_SELF, "NWNX!EVENTS!BYPASS", "1");
                WriteTimestampedLogEntry("The action was cancelled");
            }*/
            //if (GetLocalInt(oItem, "FKY_CHAT_INSTANT"))
            //{
                //SetLocalString(OBJECT_SELF, "NWNX!EVENTS!BYPASS", "1");
                //AssignCommand(oPC, DoInstantUse(oPC, oTarget, oItem));
            //}
        break;
    }
}
