//::///////////////////////////////////////////////
//:: Name n_hb_elevator
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     OnHeartbeat for the control panel
*/
//:://////////////////////////////////////////////
//:: Created By: nereng
//:: Created On: 13.11.04
//:://////////////////////////////////////////////
void main()
{
    //Script stop unless this int has been set
    if (GetLocalInt(OBJECT_SELF, "RunHB") == 0) return;

    int nCurrentFloor = GetLocalInt(OBJECT_SELF, "CurrentFloor");
    int nGoToFloor = GetLocalInt(OBJECT_SELF, "GoToFloor");
    int nMoving = GetLocalInt(OBJECT_SELF, "Moving");

    object oSound = GetNearestObjectByTag("elevator_sound");

    object oInsideDoor = GetNearestObjectByTag("n_Xit_elevator");

    //Finding the correct outside door to open
    string sNum = IntToString(nCurrentFloor);
    object oOutsideDoor = GetObjectByTag("DOOR_elevator_" + sNum);

    //*The elevator is at the right floor
    if (nCurrentFloor == nGoToFloor)
    {
        SetLocalInt(OBJECT_SELF, "Moving", 0);

        //For the transition-script on the inside door
        SetLocalString(oInsideDoor, "DEST", sNum);

        SoundObjectStop(oSound);

        //Opening the inside door - if it is closed
        if (GetLocalInt(oInsideDoor, "OpenedState") == 0)
            {
            SetLocked(oInsideDoor, FALSE);
            DelayCommand(1.0, AssignCommand(oInsideDoor, ActionOpenDoor(oInsideDoor)));
            SetLocalInt(oInsideDoor, "OpenedState", 1);
            }

        //Opening the outside door - if it is closed
        if (GetLocalInt(oOutsideDoor, "OpenedState") == 0)
            {
            SetLocked(oOutsideDoor, FALSE);
            AssignCommand(oOutsideDoor, PlaySound("gui_magbag_full"));
            DelayCommand(1.0, AssignCommand(oOutsideDoor, ActionOpenDoor(oOutsideDoor)));
            SetLocalInt(oOutsideDoor, "OpenedState", 1);
            }
    }
    //*The elevator needs to move
    else if (nCurrentFloor != nGoToFloor)
        {
        SetLocalInt(OBJECT_SELF, "Moving", 1);

        //Closing the doors
        if (GetLocalInt(oInsideDoor, "OpenedState") == 1)
            {
            AssignCommand(oInsideDoor, ActionCloseDoor(oInsideDoor));
            SetLocked(oInsideDoor, TRUE);
            SetLocalInt(oInsideDoor, "OpenedState", 0);
            }
        if (GetLocalInt(oOutsideDoor, "OpenedState") == 1)
            {
            AssignCommand(oOutsideDoor, ActionCloseDoor(oOutsideDoor));
            SetLocked(oOutsideDoor, TRUE);
            SetLocalInt(oOutsideDoor, "OpenedState", 0);
            }

        DelayCommand(1.0, SoundObjectPlay(oSound));

        //If the elevator is ascending
        if (nCurrentFloor < nGoToFloor)
            {
            int nNum = GetLocalInt(OBJECT_SELF, "CurrentFloor");
            nNum++;
            SetLocalInt(OBJECT_SELF, "CurrentFloor", nNum);
            if (GetLocalInt(OBJECT_SELF, "ScreenShake") != 0)
                {
                location lTarget = GetLocation(OBJECT_SELF);
                effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
                DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 3.0f));
                DelayCommand(3.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 3.0f));
                }
            if (nCurrentFloor != nGoToFloor)
                {
                DelayCommand(6.0, ExecuteScript("n_hb_elevator", OBJECT_SELF));
                }
            }
        //If the elevator is descending
        else if (nCurrentFloor > nGoToFloor)
            {
            int nNum = GetLocalInt(OBJECT_SELF, "CurrentFloor");
            nNum--;
            SetLocalInt(OBJECT_SELF, "CurrentFloor", nNum);
            if (GetLocalInt(OBJECT_SELF, "ScreenShake") != 0)
                {
                location lTarget = GetLocation(OBJECT_SELF);
                effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
                DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 3.0f));
                DelayCommand(3.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eShake, lTarget, 3.0f));
                }
            if (nCurrentFloor != nGoToFloor)
                {
                DelayCommand(6.0, ExecuteScript("n_hb_elevator", OBJECT_SELF));
                }
            }
        //Executing the script that shows the displayed number
        DelayCommand(3.5, ExecuteScript("n_display", OBJECT_SELF));
        }
}
