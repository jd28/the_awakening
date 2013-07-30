//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// Place the following variable on an area to disable timestop in that area.
// NAME : TIMESTOP_DISABLED  TYPE : Int  VALUE : 1

// If set to zero, the duration will default to 1 + 1d4 rounds. Otherwise, the
// duration will be the number of seconds the variable is changed to.
const int TIME_STOP_OVERRIDE_DURATION = 6


 ;
// ex. const int TIME_STOP_OVERRIDE_DURATION = 9; Timestop lasts 9 seconds.

// Number of seconds before Timestop can be recast after being cast. Countdown
//messages are sent based on this time. Set to 0.0 if you dont want there to
//be any cooldown
const float TIME_STOP_COOLDOWN_TIME = 60.0;

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eParalyze = EffectCutsceneParalyze();
    int nDuration = 1 + d4(1);
    float fDuration;

    if (GetLocalInt(OBJECT_SELF, "SPELL_DELAY_" + IntToString(si.id)) == 1){
        SendMessageToPC(si.caster, C_RED + "Timestop is not castable yet." + C_END);
        return;
    }

    if (TIME_STOP_COOLDOWN_TIME != 0.0){
        string sMessage = IntToString(FloatToInt(TIME_STOP_COOLDOWN_TIME));
        ErrorMessage(si.caster, "Time Stop Recastable In " + sMessage + " seconds.");
        DelayCommand(0.6, SpellDelay(si.caster, "Time Stop", si.id, TIME_STOP_COOLDOWN_TIME));
    }

    if (TIME_STOP_OVERRIDE_DURATION != 0)
        fDuration = IntToFloat(TIME_STOP_OVERRIDE_DURATION);
    else
        fDuration = RoundsToSeconds(nDuration);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, si.loc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, si.loc);
    while (GetIsObjectValid(oTarget))    {
        if(GetHasFeat(FEAT_LLIIRAS_HEART, oTarget)){
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, si.loc);
            continue;
        }
        if ((GetIsPC(oTarget) || GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) &&
            !GetIsDM(oTarget))
        {
            if (oTarget != si.caster && si.caster != GetMaster(oTarget)){
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
                AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, fDuration));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, si.loc);
    }
}


