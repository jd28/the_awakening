#include "mod_const_inc"
#include "pc_funcs_inc"
#include "sha_subr_methds"

void main(){

    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, VAR_PC_ENTERED, TRUE);

    //SSE
    SubraceOnClientEnter(oPC);

    //ApplyFeatSuperNaturalEffects
    DelayCommand(3.0f, ApplyFeatSuperNaturalEffects(oPC));

    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect)){
        if(GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENEIMMOBILIZE){
            RemoveEffect(oPC, eEffect);
            break;
        }
        eEffect = GetNextEffect(oPC);
    }

    FadeFromBlack(oPC, FADE_SPEED_FAST);

    // TODO - Ensure loaded from DB.
    int nGuild = GetLocalInt(oPC, VAR_PC_GUILD);
    string sWay;
    if(nGuild > 0){
        sWay = "wp_guildenter_"+IntToString(nGuild);
        if(!GetIsLocationValid(GetLocation(GetWaypointByTag(sWay) ) )){
            ErrorMessage(oPC, "Guild Hall location invalid, please inform a DM.");
            sWay = "wp_prov_spawn";
        }
    }
    else{
        ErrorMessage(oPC, "You have no guild affiliation set!  Pleast contact a DM, if there has been a mistake");
        sWay = "wp_prov_spawn";
    }



    JumpSafeToWaypoint(sWay, oPC);
}
