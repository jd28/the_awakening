//Script Name: everpclevelup
//////////////////////////////////////////
//Created By: Genisys (Guile)
//Created On:   5/20/08 (Updated 8/10/08)
/////////////////////////////////////////
/*
This OnPlayerLevelUp Module Event script
must be in your Module Event, it does
quite a few things when the PC levels
up, and there are optional settings
below, so please read this fully!
*/
////////////////////////////////////////
//Some of the functions below are other
//scripters work & bioware functions
///////////////////////////////////////

#include "fky_chat_inc"
#include "pc_funcs_inc"
#include "sha_subr_methds"
#include "quest_func_inc"
#include "pl_artifact_inc"
#include "pl_sub_inc"

//////////////////////////////////////////////////
int HandleParagon2(object oPC){
    //Get class names
    int iClassOne = GetClassByPosition(1, oPC);
    int iClassTwo = GetClassByPosition(2, oPC);
    int iClassThree = GetClassByPosition(3, oPC);

    //Get class levels
    int iClassOneLevel = GetLevelByPosition(1, oPC);
    int iClassTwoLevel = GetLevelByPosition(2, oPC);
    int iClassThreeLevel = GetLevelByPosition(3, oPC);

    //Get total character class level
    int iClassTotalLevel = (iClassOneLevel + iClassTwoLevel + iClassThreeLevel);

    //Controls
    int iLevelControlOne = 0, iLevelControlTwo = 0;

    //If not multi-classed pc is valid.
    if (iClassTwo == CLASS_TYPE_INVALID){
        SendMessageToPC(oPC, "Good: Non-multiclassed.");
        return TRUE;
    }

    //Check if their second class is a prestige class.
    if ((iClassTwo > 10))
    {
        //If it is a prestige class run the LevelControl check...
        SendMessageToPC(oPC, "Second class is prestige.");
        iLevelControlOne = 40 - iClassTotalLevel + iClassTwoLevel;
    }
    else{
        //otherwise set the LevelControl to 0.
        SendMessageToPC(oPC, "Second class is not a prestige class.");
        iLevelControlOne = 0;
    }

    //If they have 2 classes...
    if (iClassThree == CLASS_TYPE_INVALID)
    {
        SendMessageToPC(oPC, "You have 2 classes total.");
        //and their secondary class is non-prestige class...
        if (iLevelControlOne == 0)
        {
            //their non-prestige class levels must total 10 or less...
            if (iClassTotalLevel <= 10)
            {
                SendMessageToPC(oPC, "Multi-Classed: Total non-prestige is 10 or less.");
                SendMessageToPC(oPC, "*PASS*");
                return TRUE;
            }
            //otherwise they cannot reach 30 prestige level requirement for multi-classing.
            else
            {
                SendMessageToPC(oPC, "Non-prestige total is greater than 10");
                SendMessageToPC(oPC, "Multi-Classed: You must be able to reach 30 levels in a Prestige class.");
                SendMessageToPC(oPC, "*FAIL*");
                return FALSE;
            }
        }
        //Their secondary class is a prestige class...
        else
        {
            //so their non-prestige total levels must be 10 or less...
            if (iClassOneLevel < 11)
            {
                SendMessageToPC(oPC, "Multi-Classes: Non-prestige level total is 10 or less.");
                SendMessageToPC(oPC, "*PASS*");
                return TRUE;
            }
            //otherwise they cannot reach the 30 prestige levels requirement for multi-classing.
            else
            {
                SendMessageToPC(oPC, "Non-prestige level total is greater than 10.");
                SendMessageToPC(oPC, "Multi-Classed: You must be able to reach 30 levels in a Prestige class.");
                SendMessageToPC(oPC, "*FAIL*");
                return FALSE;
            }
        }
    }
    else
    {
        SendMessageToPC(oPC, "You have three classes.");
    }

    //They have 3 classes so we check if their Tertiary class is a prestige class.
    if ((iClassThree > 10))
    {
        //If it is run the LevelControl formula.
        SendMessageToPC(oPC, "Tertiary class is a prestige class.");
        iLevelControlTwo = 40 - iClassTotalLevel + iClassThreeLevel;
    }

    //If they took 3 non-prestige classes...
    if ((iLevelControlOne == 0) && (iLevelControlTwo == 0))
    {
        //they cannot meet the multi-class requirement of reaching 30 levels in a prestige class.
        SendMessageToPC(oPC, "You have three non-prestige classes.");
        SendMessageToPC(oPC, "Multi-Classed: You must be able to reach 30 levels in a Prestige class.");
        SendMessageToPC(oPC, "*FAIL*");
        return FALSE;
    }
    //They didn't take three non-prestige levels so we check that at least one of their multi-class levels
    //pass the LevelControl check.
    if ((iLevelControlOne >= 30) || (iLevelControlTwo >= 30))
    {
        //If at least one of the LevelControl checks passes then they are ok..
        SendMessageToPC(oPC, "Multi-Classed: 3 classes and at least one prestige class can reach 30.");
        SendMessageToPC(oPC, "*PASS*");
        return TRUE;
    }
    else
    {
        //otherwise they cannot reach the required 30 levels in a prestige class.
        SendMessageToPC(oPC, "Multi-classed: You must be able to reach at least 30 levels in a prestige class.");
        SendMessageToPC(oPC, "*FAIL*");
        return FALSE;
    }

    SendMessageToPC(oPC, "WARNING: No LevelUp conditionals met. Please notify a DM with your current class and level info.");
    SendMessageToAllDMs("LEVELUP WARNING: " + GetName(oPC) + "(" + GetPCPlayerName(oPC) + "): " + IntToString(iClassOne) + "(" + IntToString(iClassOneLevel) + "), " + IntToString(iClassTwo) + "(" + IntToString(iClassTwoLevel) + "), " + IntToString(iClassThree) + "(" + IntToString(iClassThreeLevel) + ")");
}

void main(){
    //Declare Major Variables
    object oPC = GetPCLevellingUp();
    int nHD = GetHitDice(oPC);

    //If it's not a PC stop the script
    if (!GetIsPC(oPC)) return;

    // -------------------------------------------------------------------------
    // Validate that level up was legal.
    // -------------------------------------------------------------------------

    if(GetSubRace(oPC) == "Paragon" && !HandleParagon2(oPC)){
        // Failure.
        Delevel(oPC, 1);
        ErrorMessage(oPC, "You cannot have that level combination as a Paragon.");
        return;
    }
    //SSE
    else if(!GetIsPCShifted(oPC) && !GetIsNormalRace(oPC)){
        SubraceOnPlayerLevelUp();
    }

    //Artifacts
    DelayCommand(2.0, ArtifactLevelUp(oPC));

    //Quests
    DelayCommand(2.0, QuestLevelUp(oPC));

    ExecuteScript("pl_levelup", oPC);

    // Reapply SuperNatural Effects, in case.
    ApplyFeatSuperNaturalEffects(oPC);

    if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0)
        LoadFavoredEnemies(oPC);

} // void main()
