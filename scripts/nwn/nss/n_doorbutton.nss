//::///////////////////////////////////////////////
//:: OnUsed script for elevator button
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Signals the elevator.
*/
//:://////////////////////////////////////////////
//:: Created By: nereng
//:: Created On: 2004-11-11
//:://////////////////////////////////////////////
void main()
{
    ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
    ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

    //Signaling the elevator - if it is not already moving
    int nFloor = GetLocalInt(OBJECT_SELF, "FLOOR");
    object oControl = GetObjectByTag("CONTROL");
    if (GetLocalInt(oControl, "Moving") == 0)
        {
        SetLocalInt(oControl, "GoToFloor", nFloor);
        }

    //Starting the elevator's heartbeat
    SetLocalInt(oControl, "RunHB",1);
    ExecuteScript("n_hb_elevator", oControl);
}
