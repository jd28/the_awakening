//:://////////////////////////////////////////////////
//:: X0_CH_HEN_HEART
/*

  OnHeartbeat event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////
#include "X0_INC_HENAI"



void main()
{    // SpawnScriptDebugger();


    //Added for shadow dancers
    object oShade = OBJECT_SELF;
    object oMaster = GetLocalObject(oShade, "X0_L_MYMASTER");
    int nShadeTime = GetLocalInt(oShade, "X0_L_MYTIMERTOEXPLODE");
    if( nShadeTime <= 0 || !GetIsObjectValid(oMaster) )
    {
        ClearAllActions();
//        PlayVoiceChat(VOICE_CHAT_GOODBYE);
        SetIsDestroyable(TRUE);
        DestroyObject(OBJECT_SELF, 0.5);
        SetCommandable(FALSE);
        return;
    }
    nShadeTime--;
    SetLocalInt(oShade, "X0_L_MYTIMERTOEXPLODE", nShadeTime);

    // If the henchman is in dying mode, make sure
    // they are non commandable. Sometimes they seem to
    // 'slip' out of this mode
    int bDying = GetIsHenchmanDying();

    if (bDying == TRUE)
    {
        int bCommandable = GetCommandable();
        if (bCommandable == TRUE)
        {
            // lie down again
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
                                          1.0, 65.0);
           SetCommandable(FALSE);
        }
    }

    // If we're dying or busy, we return
    // (without sending the user-defined event)
    if(GetAssociateState(NW_ASC_IS_BUSY) ||
       bDying)
        return;

    // * checks to see if a ranged weapon was being used
    // * if so, it equips it back
    if (GetIsInCombat() == FALSE)
    {        //   SpawnScriptDebugger();
        object oRight = GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND");
        if (GetIsObjectValid(oRight) == TRUE)
        {    // * you always want to blank this value, if it not invalid
            SetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND", OBJECT_INVALID);
            if (GetWeaponRanged(oRight) == TRUE)
            {
                ClearAllActions();
                bkEquipRanged(OBJECT_INVALID, TRUE, TRUE);
                //ActionEquipItem(
                return;

            }
        }
    }



    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
}
