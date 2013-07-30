#include "x2_inc_switches"
#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nGuild = GetPlayerInt(oPC, VAR_PC_GUILD, TRUE);
    if(nGuild <= 0){
        ErrorMessage(oPC, "You have no guild affiliation set!  Pleast contact a DM, if there has been a mistake");
        return;
    }
    string sWay = "wp_guildenter_"+IntToString(nGuild);

    JumpSafeToWaypoint(sWay, oPC);
}

