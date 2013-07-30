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

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC, oItem, oTarget;
    int nResult = X2_EXECUTE_SCRIPT_END;
    switch (nEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            oPC   = GetItemActivator();
            oItem = GetItemActivated();
            oTarget = GetItemActivatedTarget();
            if (VerifyDMKey(oPC) || VerifyAdminKey(oPC))
            {
                if (GetIsObjectValid(oTarget))
                {
                    if (!VerifyDMKey(oTarget) && !VerifyAdminKey(oTarget))
                    {
                        SetLocalObject(oPC, "FKY_CHT_VENTRILO", oTarget);
                        FloatingTextStringOnCreature(C_GREEN+VENTRILO+C_END, oPC, FALSE);
                    }
                    else FloatingTextStringOnCreature(C_RED+NO_DM_TARGET+C_END, oPC, FALSE);
                }
                else FloatingTextStringOnCreature(C_RED+TARGET_OBJECT+C_END, oPC, FALSE);
            }
            else FloatingTextStringOnCreature(C_RED+DM_ONLY+C_END, oPC, FALSE);
            break;
    }
    SetExecutedScriptReturnValue(nResult);
}
