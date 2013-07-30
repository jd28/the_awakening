//::///////////////////////////////////////////////
//:: Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 2d6 fire per round
    Duration: 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, 2003-Oct-19
//::            - VFX update
//::            - Spell no longer stacks with itself
//::            - Spell can now be dispelled
//::            - Spell is now much less cpu expensive


#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nDamType = DAMAGE_TYPE_FIRE, nDamDice = 2, nDamSides = 6;
    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(si.id, si.target) ||
        GetHasSpellEffect(SPELL_COMBUST, si.target))
    {
        FloatingTextStrRefOnCreature(100775, si.caster, FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    float fDuration = MetaDuration(si, si.clevel);

    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay      = EffectBeam(444,si.caster,BODY_NODE_CHEST);
    effect eDur      = EffectVisualEffect(498);


    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

    float fDelay = GetDistanceBetween(si.target, si.caster) / 13;

    if(!GetSpellResisted(si, si.target)){
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, si.target, 3.0f);

        //----------------------------------------------------------------------
        // Apply the VFX that is used to track the spells duration
        //----------------------------------------------------------------------
        DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur, si.target, fDuration));

    }
    else{
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, si.target, 2.0f);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,si.target));
    }

}
