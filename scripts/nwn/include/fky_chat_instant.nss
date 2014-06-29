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

//This is the equivalent of a tag-based script for items tagged with the FKY_CHAT_INSTANT
//variable. Simply add an if statement for the tag of the item you have tagged.
void DoInstantUse(object oIUPC, object oIUTarget, object oIUItem);

void DoInstantUse(object oIUPC, object oIUTarget, object oIUItem)
{
    string sTag = GetTag(oIUItem);
    if (sTag == "fky_chat_ventril")
    {
        if (VerifyDMKey(oIUPC) || VerifyAdminKey(oIUPC))
        {
            if (GetIsObjectValid(oIUTarget))
            {
                if (!VerifyDMKey(oIUTarget) && !VerifyAdminKey(oIUTarget))
                {
                    SetLocalObject(oIUPC, "FKY_CHT_VENTRILO", oIUTarget);
                    FloatingTextStringOnCreature(C_GREEN+VENTRILO+C_END, oIUPC, FALSE);
                }
                else FloatingTextStringOnCreature(C_RED+NO_DM_TARGET+C_END, oIUPC, FALSE);
            }
            else FloatingTextStringOnCreature(C_RED+TARGET_OBJECT+C_END, oIUPC, FALSE);
        }
        else FloatingTextStringOnCreature(C_RED+DM_ONLY+C_END, oIUPC, FALSE);
    }
    else if (sTag == "fky_chat_target")
    {

    }
}
