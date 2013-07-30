#include "mod_const_inc"
#include "pc_funcs_inc"
#include "sha_subr_methds"

void main(){

    string sWaypoint;
    object oPC = GetPCSpeaker();
    location lLoc = GetLocation(GetWaypointByTag("wp_ta_start"));

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
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionJumpToLocation(lLoc));
}
