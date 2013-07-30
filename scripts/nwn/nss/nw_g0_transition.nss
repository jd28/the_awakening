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

#include "pc_funcs_inc"
#include "area_inc"

void main() {
    object oTarget  = GetTransitionTarget(OBJECT_SELF);
    object oClicker = GetClickingObject();

    if(!GetIsPC(oClicker) && GetPlotFlag(oClicker))
        return;

    if(!CheckTransition(OBJECT_SELF, oClicker))
        return;

    SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);
    JumpSafeToObject(oTarget, oClicker);
}

