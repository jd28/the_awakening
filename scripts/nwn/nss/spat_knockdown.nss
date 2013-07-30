#include "pc_funcs_inc"
#include "gsp_func_inc"

void main(){
    object oPC     = OBJECT_SELF;
    int nRoll      = GetSpecialAttackRoll();
    int nType      = GetSpecialAttackType();
    object oTarget = GetSpecialAttackTarget();
    int bImproved  = (nType == NWNX_SPECIAL_ATTACK_KNOCKDOWN_IMPROVED);
    int nEvent     = GetSpecialAttackEventType();


    if(nEvent != NWNX_SPECIAL_ATTACK_EVENT_RESOLVE)
        return; 

    if(GetLocalInt(oPC, "KnockdownDelay"))
        return;

    if(GetSkillCheckResult(SKILL_DISCIPLINE, oTarget, nRoll, TRUE, FALSE, oPC))
        return;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1));

    SetLocalInt(oPC, "KnockdownDelay", 1);
    DelayCommand(IntToFloat(6 + d6()), DeleteLocalInt(oPC, "KnockdownDelay"));

}

