//::///////////////////////////////////////////////
//:: Name: x2_onrest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
The generic wandering monster system
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June 9/03
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified Date: January 28th, 2008
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "pc_funcs_inc"
#include "vfx_inc"

void main()
{
    object oPC = GetLastPCRested();
    int nRestType = GetLastRestEventType();

    object oShade = GetLocalObject(oPC, "X0_L_MYSHADE");
    if(GetIsObjectValid(oShade)){
        AssignCommand(oShade, SetIsDestroyable(TRUE));
        ApplyVisualToObject(VFX_IMP_UNSUMMON, oShade);
        DestroyObject(oShade, 1.0);
    }

    SetLocalInt(oPC, "Rests", GetLocalInt(oPC, "Rests")+1);

    // -------------------------------------------------------------------------
    // Handle rest events
    // -------------------------------------------------------------------------
    switch (nRestType){
        case REST_EVENTTYPE_REST_STARTED:
        {
            if(REST_USE_FADES){
                //Dark the screen out on the PC..
                FadeToBlack(oPC, FADE_SPEED_FAST);
            }
        }
        break;

        case REST_EVENTTYPE_REST_FINISHED:
        {
            if(GetSubRace(oPC) == "Goblin" && GetAppearanceType(oPC) == 1142){
                int nGender = GetGender(oPC);
                SetCreatureAppearanceType(oPC, (nGender == GENDER_MALE) ? APPEARANCE_TYPE_GOBLIN_CHIEF_B : APPEARANCE_TYPE_GOBLIN_A);
            }

            // Reapply SuperNatural Effects, in case.
            ApplyFeatSuperNaturalEffects(oPC);

            // -----------------------------------------------------------------
            // Save PC and their location Location
            // -----------------------------------------------------------------
            if(GetIsPC(oPC) && !GetIsDM(oPC) && !GetIsDMPossessed(oPC)){
                SendPCMessage(oPC, C_GREEN+"Your character has been saved."+C_END);
                ExportSingleCharacter(oPC);
                SavePersistentLocation(oPC);
				ExecuteScript("ta_update_kills", oPC);
                SavePersistentState(oPC);
                SetMovementRate(oPC, MOVEMENT_RATE_PC);
            }
        }
        break;

        case REST_EVENTTYPE_REST_CANCELLED:
        {
            if(REST_USE_FADES){
                //remove the black out from thier screen..
                FadeFromBlack(oPC, FADE_SPEED_MEDIUM);
            }
        }
        break;
    } // switch (nRestType)
} // void main()
