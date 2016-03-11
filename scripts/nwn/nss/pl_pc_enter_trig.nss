#include "pc_funcs_inc"
#include "srv_funcs_inc"
#include "pc_validate_inc"
#include "mod_funcs_inc"
//#include "mod_const_inc"
#include "mod_const_inc"

void ModStartEnterConv(object oPC, string sConv);
void ModEnter(object oPC);


void main(){

    object oPC = GetEnteringObject();
    //if(!GetLocalInt(GetModule(), VAR_MOD_DEV))
    FadeToBlack(oPC, FADE_SPEED_FASTEST);

    DelayCommand(0.5, ModEnter(oPC));
}

void ModEnter(object oPC){
    string sMsg;

    if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;
    if(!GetIsPC(oPC)) return;

    SetLocalInt(oPC, VAR_PC_IS_PC, GetIsPC(oPC));

    if(GetLocalInt(GetModule(), VAR_MOD_DEV) > 1){
        //JumpSafeToWaypoint("wp_thehub_enter");
        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, JumpToObject(GetObjectByTag("wp_thehub_enter")));
        AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
        AssignCommand(oPC, SetCommandable(FALSE));
        FadeFromBlack(oPC);
        return;
    }

    if(VerifyPlayernameAgainstCDKey(oPC)){
        SetLocalInt(oPC, "InvalidCDKey", TRUE);
        SetLocalInt(oPC, "boot", TRUE);
    }

    // Character flagged as deleted.
    if(GetLocalInt(oPC, VAR_PC_DELETED)){
        SetLocalInt(oPC, "boot", TRUE);
    }
    if(!GetIsPCNameValid(oPC)){
        sMsg = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "Invalid Name: Login: %s, Name: %s, IP: %s, CDKey: %s",
                      GetPCPlayerName(oPC), GetName(oPC), GetPCIPAddress(oPC), GetPCPublicCDKey(oPC));
        SendMessageToAllDMs(sMsg);
        SetLocalInt(oPC, "InvalidName", TRUE);
        SetLocalInt(oPC, "boot", TRUE);
    }
    else if(!GetIsBicFileValid(oPC)){
        sMsg = Logger(oPC, VAR_DEBUG_LOGS, LOGLEVEL_NOTICE, "Dupe Name: Login: %s, Name: %s, IP: %s, CDKey: %s",
                      GetPCPlayerName(oPC), GetName(oPC), GetPCIPAddress(oPC), GetPCPublicCDKey(oPC));
        SendMessageToAllDMs(sMsg);

        SetLocalInt(oPC, "DupeName", TRUE);
        SetLocalInt(oPC, "boot", TRUE);
    }

    effect eNoMove = EffectCutsceneImmobilize();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoMove, oPC);

    DelayCommand(1.0, ModStartEnterConv(oPC, GetTag(OBJECT_SELF)));
}

void ModStartEnterConv(object oPC, string sConv){
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionStartConversation(oPC, sConv, TRUE, FALSE));
    AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(oPC, SetCommandable(FALSE));
}



