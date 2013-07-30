////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick
// NW_G0_Transition.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
// Created By: Sydney Tang
// Created On: 2001-10-26
// Description: This is the default script that is called
//              if no OnClick script is specified for an
//              Area Transition Trigger or
//              if no OnAreaTransitionClick script is
//              specified for a Door that has a LinkedTo
//              Destination Type other than None.
////////////////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Apr 12th, 2008
//:: Added Support for Keeping mounts out of no mount areas
//::////////////////////////////////////////////////////////


//#include "x3_inc_horse"
#include "x0_inc_henai"
#include "area_inc"

void main()
{
    object oClicker = GetClickingObject();
    object oTarget = GetTransitionTarget(OBJECT_SELF);
    int nN=1;
    object oOb;
    object oAreaHere = GetArea(oClicker);
    object oAreaTarget = GetArea(oTarget);
    int bDelayedJump=FALSE;
    int bJump = CheckTransition(OBJECT_SELF, oClicker);

    if(!GetIsPC(oClicker))
        return;

    //Forgotten Forest - pl_frgforest
    string sTrigTag = GetTag(OBJECT_SELF);
    if(GetStringLeft(GetTag(oAreaHere), 10) == "pl_forgfor" &&
       GetStringRight(GetTag(oAreaHere), 3) != "beg"){
        int nAreaNumber = StringToInt(GetStringRight(GetTag(oAreaHere), 1));
        //SendMessageToPC(oClicker, "Area Number: " + IntToString(nAreaNumber));
        if(nAreaNumber != 9 && !(nAreaNumber == 8 && sTrigTag == "pl_frgforest_right") ){ // The last area handles itself
            string sWaypoint = "wp_frgforest_00";
            if(sTrigTag == "pl_frgforest_right")
                nAreaNumber++;
            else{
                //First 2 maps randomly goes between each other
                if(nAreaNumber == 1) nAreaNumber++;
                else if (nAreaNumber == 2) nAreaNumber--;

                nAreaNumber = Random(nAreaNumber-1) + 1;
            }

            sWaypoint += IntToString(nAreaNumber) +"_"+ IntToString(d8());
            //SendMessageToPC(oClicker, sWaypoint);
            oTarget = GetWaypointByTag(sWaypoint);
        }
    }

    if(!bJump)
        return;

    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
    JumpSafeToLocation(GetLocation(oTarget), oClicker);
}
