//::///////////////////////////////////////////////
//:: Gate
//:: NW_S0_Gate.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Summons a Balor to fight for the caster.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if(si.id < 0) return;
    float fDuration = MetaDuration(si, 24, DURATION_IN_HOURS), fDelay;
    effect eSummon;
    int nEffect;
    string sSummon;

    if(GetIsObjectValid(si.item) && GetTag(si.item) == "pl_drow_bind_rob"){
        if(!GetHasSpell(SPELL_GATE, si.caster)){
            ErrorMessage(si.caster, "You must have a Gate spell memorized to use this item!");
            return;
        }

        DecrementRemainingSpellUses(si.caster, SPELL_GATE);
        sSummon = "pl_drow_demon2";
        nEffect = VFX_FNF_SUMMON_GATE;
        fDuration = MetaDuration(si, si.clevel);
        fDelay = 3.0;
    }
    else if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) ||
            GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) ||
            GetHasSpellEffect(SPELL_HOLY_AURA))
    {
        nEffect = VFX_FNF_SUMMON_GATE;
        sSummon = "NW_S_BALOR";
        fDuration = MetaDuration(si, si.clevel);
        fDelay = 3.0;
    }
    else{ // Not protected, create evil balor.
        ApplyVisualAtLocation(VFX_FNF_SUMMON_GATE, si.loc);
        DelayCommand(fDelay, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "NW_S_BALOR_EVIL", si.loc)));
        return;
    }

    eSummon = EffectSummonCreature(sSummon, nEffect, fDelay);
    //Apply the VFX impact and summon effect
    DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, si.loc, fDuration));

    /*
        //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    //Make metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Summon the Balor and apply the VFX impact
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    location lSpellTargetLOC = GetSpellTargetLocation();

    if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) ||
       GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) ||
       GetHasSpellEffect(SPELL_HOLY_AURA))
    {
        eSummon = EffectSummonCreature("NW_S_BALOR",VFX_FNF_SUMMON_GATE,3.0);
        float fSeconds = RoundsToSeconds(nDuration);
        DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lSpellTargetLOC, fSeconds));

    }
    else
    {

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLOC);
        DelayCommand(3.0, CreateBalor());
    }
    */
}
