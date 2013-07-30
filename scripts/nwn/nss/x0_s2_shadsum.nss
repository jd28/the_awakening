//::///////////////////////////////////////////////
//:: Summon Shadow
//:: X0_S2_ShadSum.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    PRESTIGE CLASS VERSION
    Spell powerful ally from the shadow plane to
    battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"
#include "pc_funcs_inc"

void main()
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetLevelByClass(27);
    int nDuration = nCasterLevel;
    effect eSummon;
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    //Set the summoned undead to the appropriate template based on the caster level
    if (nCasterLevel <= 5)
    {
        eSummon = EffectSummonCreature("X1_S_SHADOW",VFX_FNF_SUMMON_UNDEAD);
    }
    else if (nCasterLevel <= 8)
    {
        eSummon = EffectSummonCreature("X1_S_SHFIEND",VFX_FNF_SUMMON_UNDEAD);
    }
    else if (nCasterLevel <=10)
    {
        eSummon = EffectSummonCreature("X1_S_SHADLORD",VFX_FNF_SUMMON_UNDEAD);
    }
    else{
        if (GetHasFeat(1002,OBJECT_SELF)){
            if(nCasterLevel >= 40 && oTarget != OBJECT_INVALID && GetIsPC(oTarget) && !GetIsDM(oTarget) && !GetIsDMPossessed(oTarget) && oTarget != oPC
                    && CreateShadow(oTarget, nCasterLevel + 10, GetName(oPC) + "'s Shadow of " + GetName(oTarget)))
                return;

            if(CreateShadow(oPC, nCasterLevel + 10, "Shadow of " + GetName(oPC)))
                return; // Shadow created.
        }
        eSummon = EffectSummonCreature("X1_S_SHADLORD",VFX_FNF_SUMMON_UNDEAD);
    }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));
}
