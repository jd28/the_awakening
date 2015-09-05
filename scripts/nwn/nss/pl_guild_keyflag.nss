#include "pl_pcguild_inc"
#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();

    int nGuild = GetLocalInt(oPC, VAR_PC_GUILD);
    if(nGuild <= 0){
        ErrorMessage(oPC, "You have no guild affiliation set!  Pleast contact a DM, if there has been a mistake");
        return;
    }

    CreateItemOnObject("pl_guildflag_"+IntToString(nGuild), oPC);
    object oKey = CreateItemOnObject("pl_guild_key", oPC);
    SetName(oKey, GetGuildAbbreviation(nGuild) + " Guild Hall Key");
}
