//::///////////////////////////////////////////////
//:: Player Tool 1 Instant Feat
//:: x3_pl_tool01
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a blank feat script for use with the
    10 Player instant feats provided in NWN v1.69.

    Look up feats.2da, spells.2da and iprp_feats.2da

*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

#include "pc_funcs_inc"
#include "mod_funcs_inc"
#include "fky_chat_inc"

void main(){
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
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
