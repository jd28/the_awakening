#include "pl_pvp_inc"

void main(){
    object oPC = GetLastUsedBy();
    object oGong = OBJECT_SELF;
    object oArea = GetArea(oPC);
    object   tPC, tObj, oObj, oChest;

    int      iWin         = FALSE;
    string   sGongTag     = GetTag(OBJECT_SELF);
    int      iGameStarted = GetLocalInt(oArea, "GAME_START");
    int      iPoints, i;


    //SpeakString("pvp_signal_ready");

    //Game hasn't been started so gongs act as signals to start.
    if(!GetLocalInt(oArea, "GAME_START"))
    {
        //SpeakString("game has not been started");

        if(GetTag(oGong) == sBlueGoal
            && PVPGetIsOnTeam(oPC, PVP_TEAM_1)
            && !GetLocalInt(oArea, "GAME_START_team1"))
        {
            SetLocalInt(oArea, "GAME_START_team1", TRUE);
            PVPAnnounce("Blue team has signaled that it is ready!", oPC);
        }
        else if(GetTag(oGong) == sRedGoal
                && PVPGetIsOnTeam(oPC, PVP_TEAM_2)
                && !GetLocalInt(oArea, "GAME_START_team2"))
        {
            SetLocalInt(oArea, "GAME_START_team2", TRUE);
            PVPAnnounce("Red team has signaled that it is ready!", oPC);
        }
        if(GetLocalInt(oArea, "GAME_START_team1")
           && GetLocalInt(oArea, "GAME_START_team2"))
        {
            SetLocalInt(oArea, "GAME_START", TRUE);
            SetLocalInt(oArea, "team2_POINTS",  0);
            SetLocalInt(oArea, "team1_POINTS", 0);

            // PLACE FLAGS IN THEIR CONTAINERS
            PVPReturnFlag2(sBlueChest, sBlueFlag);
            PVPReturnFlag2(sRedChest, sRedFlag);

            //Announce it.
            PVPAnnounce("Let the GAME begin!  The first team to steal their opponents flag 3 times wins!", oPC);
        }
        return;
    }

    //SpeakString("game has been started");
    //SpeakString(GetTag(oGong));

    // A game is in progress.
    //CHECK FOR red WINNER
    if (GetResRef(oGong) == sRedGoal)
    {
        //SpeakString("red gong");

        // CHECK IF THE PLAYER ACTUALLY HAS THE ENEMY'S FLAG
        if (GetItemPossessedBy(oPC, sBlueFlag) == OBJECT_INVALID)
        {
            FloatingTextStringOnCreature("You do not have the Enemy's Flag.", oPC, FALSE);
            return;
        }

        // CHECK IF THE team2 TEAM'S FLAG IS STILL IN THEIR CHEST
        oChest = GetNearestObjectByTag(sRedChest, oPC);
        if (GetItemPossessedBy(oChest, sRedFlag) == OBJECT_INVALID)
        {
            FloatingTextStringOnCreature("Your team's flag MUST be in your team's chest in order to turn in the Enemy's Flag.", oPC, TRUE);
            return;
        }

        // TAKE FLAG - SCORE A POINT
        tObj = GetItemPossessedBy(oPC, sBlueFlag);
        if (GetIsObjectValid(tObj))
        {
            // DESTROY THE CARRIED FLAG
            SetPlotFlag(tObj, FALSE);
            DestroyObject(tObj);
            // INCREASE THE SCORING TEAM'S POINTS
            iPoints = GetLocalInt(oArea, "team2_POINTS") + 1;
            SetLocalInt(oArea, "team2_POINTS", iPoints);
            // ANNOUNCE FLAG CAPTURE
            if (iPoints >= 3)
            {
               PVPAnnounce("The Red Team Wins, "+IntToString(iPoints)+" to "+IntToString(i)+".", oPC);
               SetLocalInt(oArea, "GAME_START",      FALSE);
               SetLocalInt(oArea, "GAME_START_team2",  FALSE);
               SetLocalInt(oArea, "GAME_START_team1", FALSE);
               iWin = TRUE;
            }
            else
            {
                PVPAnnounce(GetName(oPC)+" scores a point for the Red Team. The score is now Red: "
                            +IntToString(iPoints) + "  Blue: " + IntToString(GetLocalInt(oArea, "team1_POINTS")), oPC);
                DelayCommand(1.0, PVPAnnounce("Both Flags have been returned to their Chests.", oPC));
            }

            // RETURN THE FLAG TO THE ENEMY'S CHEST
            PVPReturnFlag2(sBlueChest, sBlueFlag);
        }
    }

    //CHECK FOR team1 WINNER
    if (GetResRef(oGong) == sBlueGoal)
    {
        // CHECK IF THE team2 TEAM'S FLAG IS STILL IN THEIR CHEST
        oChest = GetNearestObjectByTag(sBlueChest, oPC);
        if (GetItemPossessedBy(oChest, sBlueFlag) == OBJECT_INVALID)
        {
            FloatingTextStringOnCreature("Your team's flag MUST be in your team's chest in order to turn in the Enemy's Flag.", oPC, TRUE);
            return;
        }

        // TAKE FLAG - SCORE A POINT
        tObj = GetItemPossessedBy(oPC, sRedFlag);
        // CHECK IF THE PLAYER ACTUALLY HAS THE ENEMY'S FLAG
        if (tObj == OBJECT_INVALID)
        {
            FloatingTextStringOnCreature("You do not have the Enemy's Flag.", oPC, FALSE);
            return;
        }
        else
        {
            //SpeakString("blue point score");

            // DESTROY THE CARRIED FLAG
            SetPlotFlag(tObj, FALSE);
            DestroyObject(tObj);

            // INCREASE THE SCORING TEAM'S POINTS
            iPoints = IncrementLocalInt(oArea, "team1_POINTS");

            // ANNOUNCE FLAG CAPTURE
            if (iPoints >= 3)
            {
                i = GetLocalInt(oArea, "team2_POINTS");
                PVPAnnounce("The Blue Team Wins, "+IntToString(iPoints)+" to "+IntToString(i)+".", oPC);
                SetLocalInt(oArea, "GAME_START",      FALSE);
                SetLocalInt(oArea, "GAME_START_team2",  FALSE);
                SetLocalInt(oArea, "GAME_START_team1", FALSE);
                iWin = TRUE;
            }
            else
            {
                PVPAnnounce(GetName(oPC)+" scores a point for the Blue Team. The score is now Blue: "+IntToString(iPoints)
                    +"  Red: "+IntToString(GetLocalInt(oArea, "team2_POINTS")), oPC);
                SendMessageToPC(oPC, "2");
                DelayCommand(1.0, PVPAnnounce("Both flags have been returned to their Chests.", oPC));
            }

          // INCREMENT CAPTURE VARIABLE AND REWARD THE PC
          //i = GetDBint("PC_Stats", oPC, "CAPTURES", "CAPTURES");
          //i++;
          //SetDBint("PC_Stats", oPC, "CAPTURES", i, "CAPTURES");


            // RETURN THE FLAG TO THE ENEMY'S CHEST
            PVPReturnFlag2(sRedChest, sRedFlag);
        }
    }
    // ONE TEAM WON, SEND THEM ALL HOME
    if (iWin == TRUE)
    {
        // RESET THE GAME VARIABLES
        SetLocalInt(oArea, "GAME_START",      FALSE);
        SetLocalInt(oArea, "GAME_START_team2",  FALSE);
        SetLocalInt(oArea, "GAME_START_team1", FALSE);
        SetLocalInt(oArea, "team2_POINTS",  0);
        SetLocalInt(oArea, "team1_POINTS", 0);
        ClearChest(GetObjectByTag(sBlueChest));
        ClearChest(GetObjectByTag(sRedChest));

        tObj = GetFirstFactionMember(oPC, TRUE);
        while(GetIsObjectValid(tObj))
        {
            if (GetTag(GetArea(tObj)) == GetTag(GetArea(oPC)))
            {
                SendMessageToPC(tObj, "Your team is victorious!");
    //        i = GetDBint("PC_Stats", tObj, "VICTORIES", "VICTORIES");
    //        i++;
    //        SetDBint("PC_Stats", tObj, "VICTORIES", i, "VICTORIES");
            }
            tObj = GetNextFactionMember(oPC, TRUE);
        }

        //Transport Everyone Out
        string sArea = GetTag(oArea);
        tObj = GetFirstPC();
        while (tObj != OBJECT_INVALID)
        {
            if (GetTag(GetArea(tObj)) == sArea && !GetIsDM(tObj))
            {
                //If Player is Dead, Ressurrect
                if (GetIsDead(tObj))
                    Raise(tObj);

                //Destroy Flags
                if ((oObj = GetItemPossessedBy(tObj, sRedFlag)) != OBJECT_INVALID)
                {
                    SetPlotFlag(oObj, FALSE);
                    DestroyObject(oObj);
                }
                if ((oObj = GetItemPossessedBy(tObj, sRedFlag)) != OBJECT_INVALID)
                {
                    SetPlotFlag(oObj, FALSE);
                    DestroyObject(oObj);
                }

                //Teleport
                if (PVPGetIsOnTeam(oPC, PVP_TEAM_1))
                    JumpSafeToWaypoint("wp_home_team1");
                else
                    JumpSafeToWaypoint("wp_home_team2");
            }
            tObj = GetNextPC();
        }

        // SELECT A NEW PLAYING AREA
        /*
        tObj = OBJECT_INVALID;
        while (tObj == OBJECT_INVALID) {
          SetLocalInt(GetModule(), "PVP_ACTIVE_AREA", Random(GetLocalInt(GetModule(), "PVP_TOTAL_AREA"))+1);
          tObj = GetObjectByTag("pvp_area_"+IntToString(GetLocalInt(GetModule(), "PVP_ACTIVE_AREA")));
        }
        oAnnounce = GetObjectByTag("WP_ANNOUNCE_" + IntToString(GetLocalInt(GetModule(), "PVP_ACTIVE_AREA")));
        AssignCommand(oAnnounce, ActionSpeakString("The next Battle will be waged in " + GetName(GetArea(oAnnounce)) + ".", TALKVOLUME_SHOUT));
        */
    }
}
