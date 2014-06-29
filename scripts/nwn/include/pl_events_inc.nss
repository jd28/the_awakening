#include "pc_funcs_inc"
#include "vfx_inc"
#include "gsp_func_inc"


void DoTaunt(object oPC, object oTarget);
void ShowFaireLeaderboard(object oPC, object oTarget);

void EventDoStealth(object oPC) {

    int bHasHIPS    = GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC);
    int nSkill      = SKILL_HIDE;
    int bNormal     = TRUE;
    effect eVis     = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSanc, eLink;



    if(GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 35){
        nSkill = SKILL_MOVE_SILENTLY;
        bNormal = FALSE;
    }
    else if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 35
            || GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 45
            || GetLevelByClass(CLASS_TYPE_ROGUE, oPC) >= 45)
        bNormal = FALSE;

    if(bNormal)
        return;

    if(!bHasHIPS && GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oPC, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY) != OBJECT_INVALID){
        return;
    }

    BypassEvent();

    if (GetLocalInt(OBJECT_SELF, "SPELL_DELAY_" + IntToString(TASPELL_STEALTH)) == 1){
        ErrorMessage(oPC, "Stealth is not available yet.");
        return;
    }
    
    SetLocalInt(GetArea(oPC), "PL_LAST_STEALTH", GetLocalInt(GetModule(), "uptime"));


    int nRank = GetSkillRank(nSkill, oPC);
    int nDuration = nRank / 3;
    int nDC = 10 + (nRank / 2);
    if (nDC > 70) nDC = 70;

    Logger(oPC, "DebugEvents", LOGLEVEL_DEBUG, "%s Sanctuary / Stealh, DC: %s, Duration: %s, HiPS: %s",
        GetName(oPC), IntToString(nDC), IntToString(nDuration), IntToString(bHasHIPS));

    eSanc = EffectSanctuary(nDC);
    eLink = EffectLinkEffects(eVis, eDur);
    eLink = EffectLinkEffects(eLink, eSanc);

    SetEffectSpellId (eLink, TASPELL_STEALTH);

    ErrorMessage(oPC, "Stealth Usable In "+IntToString(nDuration+12)+" Seconds.");
    DelayCommand(0.6, SpellDelay(oPC, "Stealth", TASPELL_STEALTH, IntToFloat(nDuration + 12)));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, IntToFloat(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementRate(MOVEMENT_RATE_SLOW),
                        oPC, IntToFloat(nDuration));
}



void DoTaunt(object oPC, object oTarget){
    if(!GetIsEnemy(oTarget, oPC)) return;

}

void ShowFaireLeaderboard(object oPC, object oTarget){
    // All time
    string sMsg = "All Time:\n";
    sMsg += "Total Damge: " + GetDbString(oTarget, "PLC_INTERACT_TOTAL") + "\n";;
    sMsg += "Most Hits: " + GetDbString(oTarget, "PLC_INTERACT_HITCOUNT") + "\n";;
    sMsg += "Highest Avg. Damage: " + GetDbString(oTarget, "PLC_INTERACT_AVERAGE") + "\n";;
    sMsg += "Hardest Hit: " + GetDbString(oTarget, "PLC_INTERACT_HIGHEST") + "\n";;
    sMsg += "\n";
    // Today
    sMsg += "Today:\n";
    sMsg += "Total Damge: " + IntToString(GetLocalInt(oTarget, "PLC_INTERACT_TOTAL"));
    sMsg += " by " + GetLocalString(oTarget, "PLC_INTERACT_TOTAL") + "\n";
    sMsg += "Most Hits: " + IntToString(GetLocalInt(oTarget, "PLC_INTERACT_HITCOUNT"));
    sMsg += " by " + GetLocalString(oTarget, "PLC_INTERACT_HITCOUNT") + "\n";
    sMsg += "Highest Avg. Damage: " + IntToString(GetLocalInt(oTarget, "PLC_INTERACT_AVERAGE"));
    sMsg += " by " + GetLocalString(oTarget, "PLC_INTERACT_AVERAGE") + "\n";
    sMsg += "Hardest Hit: " + IntToString(GetLocalInt(oTarget, "PLC_INTERACT_HIGHEST"));
    sMsg += " by " + GetLocalString(oTarget, "PLC_INTERACT_HIGHEST");

    SendPCMessage(oPC, C_WHITE+sMsg+C_END);
}


