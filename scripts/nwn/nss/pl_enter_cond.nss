#include "nwnx_inc"
#include "mod_const_inc"


int StartingConditional(){
    int nNodeType = GetCurrentNodeType();
    int nNodeID = GetCurrentNodeID();
    int nAbsNodeID = GetCurrentAbsoluteNodeID();
    object oPC = GetPCSpeaker();
    string sMsg;

    SendMessageToPC(oPC, IntToString(nAbsNodeID));

    switch(nAbsNodeID){
        case 7: // Invalid Name
            if(GetLocalInt(oPC, "IllegalName") != 0){
                SendMessageToPC(oPC, IntToString(GetLocalInt(oPC, "IllegalName")));
                return TRUE;
            }
        break;
        case 6: // Invalid CDKey -- UNIMPLEMENTED
            return FALSE;
        break;
        case 5: // Duped name
            return GetLocalInt(oPC, "DupeName");
        break;
        case 4: // Deleted
            return GetLocalInt(oPC, VAR_PC_DELETED);
        break;
        case 1: // New player
            return GetLocalInt(oPC, "NewChar");
        break;
    }
    return TRUE;
}
