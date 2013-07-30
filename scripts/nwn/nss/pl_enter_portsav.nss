#include "mod_funcs_inc"
#include "pc_funcs_inc"
#include "sha_subr_methds"

void main(){

    object oPC = GetPCSpeaker();
    location lWaypoint = GetDbLocation(oPC, VAR_PC_SAVED_LOCATION);

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

    if(!GetIsLocationValid(lWaypoint)){
        SendChatLogMessage(oPC, C_RED+"Your saved location is invalid!"+C_END + "\n", oPC, 5);
        object oTarget = GetWaypointByTag("wp_prov_spawn");
        lWaypoint = GetLocation(oTarget);
    }

    JumpSafeToLocation(lWaypoint, oPC);
}
