//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +12 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003

#include "gsp_func_inc"

void RunHandImpact(struct SpellInfo si){
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(si.id, si.target, si.caster))
        return;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);
    int nCasterModifiers = GetCasterAbilityModifier(si.caster) + GetCasterLevel(si.caster);
    int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
    int nTargetRoll = GetAC(si.target);

    if (nCasterRoll >= nTargetRoll){

       int nDam  = MetaPower(si, 8, si.clevel/4, 10, fb.dmg);

       effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
       effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);

       if (!GetSpellSaved(si, SAVING_THROW_FORT, si.target)){
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), si.target, 6.0f);
       }

      DelayCommand(6.0f,RunHandImpact(si));
   }
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(si.id, si.target) ||  GetHasSpellEffect(463,si.target)){
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    float fDuration = MetaDuration(si, si.clevel);

    if(!GetIsReactionTypeFriendly(si.target)){
        SignalEvent(si.target, EventSpellCastAt(OBJECT_SELF, si.id, TRUE));
        if(GetSpellResisted(si, si.target) == 0){
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, si.target, fDuration);

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // GetSpellSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(si.target,"XP2_L_SPELL_SAVE_DC_" + IntToString (si.id), si.dc);
            RunHandImpact(si);
        }
    }
}

