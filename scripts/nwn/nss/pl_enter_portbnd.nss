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
    string sWay;
    if(GetIsTestCharacter(oPC)){
        sWay = "wp_test_spawn";
    }
    else{
        sWay = "wp_prov_spawn";
    }

    JumpSafeToWaypoint(sWay, oPC);
}
