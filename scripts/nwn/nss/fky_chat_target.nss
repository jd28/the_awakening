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
#include "x2_inc_switches"
#include "fky_chat_inc"
void main() {
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE) { return; }

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	location lTarget = GetItemActivatedTargetLocation();
	string sCommand = GetLocalString(oPC, "FKY_CHAT_COMMAND");
	string sReturnType = GetStringLeft(sCommand, 1);
	sCommand = GetStringRight(sCommand, GetStringLength(sCommand) - 1);
	if (sReturnType == AREA_TARGET_OK)//command requires an object input, but allows area objects and will default to the area if no object selected
	{
		DeleteLocalString(oPC, "FKY_CHAT_COMMAND");
		if (GetIsObjectValid(oTarget))
		{
			SetLocalObject(oPC, "FKY_CHAT_TARGET", oTarget);
			AssignCommand(oPC, SpeakString(sCommand));
		}
		else
		{
			oTarget = GetArea(oPC);
			if (GetIsObjectValid(oTarget))
			{
				SetLocalObject(oPC, "FKY_CHAT_TARGET", oTarget);
				AssignCommand(oPC, SpeakString(sCommand));
			}
			else FloatingTextStringOnCreature(C_RED+TARGETER_ERROR+C_END, oPC, FALSE); //should never fire, debug
		}
	}
	else if (sReturnType == OBJECT_TARGET)//command requires an object input
	{
		DeleteLocalString(oPC, "FKY_CHAT_COMMAND");
		if (GetIsObjectValid(oTarget))
		{
			SetLocalObject(oPC, "FKY_CHAT_TARGET", oTarget);
			AssignCommand(oPC, SpeakString(sCommand));
		}
		else FloatingTextStringOnCreature(C_RED+TARGETER_ERROR2+C_END, oPC, FALSE);
	}
	else if (sReturnType == LOCATION_TARGET)//command requires a location input
	{
		if (GetIsObjectValid(GetAreaFromLocation(lTarget)))
		{
			SetLocalLocation(oPC, "FKY_CHAT_LOCATION", lTarget);
			DeleteLocalString(oPC, "FKY_CHAT_COMMAND");//here we only delete if they selected a valid location - otherwise propmpt for retry
			AssignCommand(oPC, SpeakString(sCommand));
		}
		else FloatingTextStringOnCreature(C_RED+TARGETER_ERROR3+C_END, oPC, FALSE);
	}
	else if (sReturnType == ITEM_TARGET)//command requires a location input
	{
		DeleteLocalString(oPC, "FKY_CHAT_COMMAND");
		if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
		{
			SetLocalObject(oPC, "FKY_CHAT_TARGET", oTarget);
			AssignCommand(oPC, SpeakString(sCommand));
		}
		else
		{
			FloatingTextStringOnCreature(C_RED+TARGETER_ERROR4+C_END, oPC, FALSE);
		}
	}
	else
	{
		string s = GetLocalString(oPC, "FKY_CHAT_COMMAND");
		DeleteLocalString(oPC, "FKY_CHAT_COMMAND");
		SetLocalObject(oPC, "FKY_CHAT_TARGET", oTarget);
		AssignCommand(oPC, SpeakString(s));
	}

}
