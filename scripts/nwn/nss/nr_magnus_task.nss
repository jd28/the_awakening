#include "nwnx_inc"

int StartingConditional(){
    object oPC = GetPCSpeaker();
    string sArea = GetTag(GetArea(oPC));
    object oStone = GetItemPossessedBy(oPC, "nr_task_stone");

    int nNode = GetCurrentAbsoluteNodeID();
    string sText = GetCurrentNodeText();

    //SendMessageToPC(oPC, "Node: " + IntToString(nNode) + " Text: " + sText);
    //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));

    switch(nNode){
        case 30: // Task 5
            if(GetLocalInt(oStone, "Task") == 99)
                return TRUE;
        break;
        case 26: // Task 5
            if(GetLocalInt(oStone, "Task") == 5)
                return TRUE;
        break;
        case 22: // Task 22
            if(GetLocalInt(oStone, "Task") == 4)
                return TRUE;
        break;
        case 18: // Task 22
            if(GetLocalInt(oStone, "Task") == 3)
                return TRUE;
        break;
        case 13: // Task 13
            if(GetLocalInt(oStone, "Task") == 2)
                return TRUE;
        break;
        case 10: // Task 10
            if(GetLocalInt(oStone, "Task") == 1)
                return TRUE;
        break;
        case 1: // Enter
            if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 25 ||
               GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 25)
                return TRUE;
        break;
    }

    return FALSE;
}
