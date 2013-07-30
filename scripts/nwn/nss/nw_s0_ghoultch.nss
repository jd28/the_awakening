//::///////////////////////////////////////////////
//:: Ghoul Touch
//:: NW_S0_GhoulTch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts a touch attack on a target
    creature.  If successful creature must save
    or be paralyzed. Target exudes a stench that
    causes all enemies to save or be stricken with
    -2 Attack, Damage, Saves and Skill Checks for
    1d6+2 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////

/*  Georg 2003-09-11
    - Put in melee touch attack check, as the fixed attack bonus is now calculated correctly
 */

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL);
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);

    float fDuration = MetaDuration(si, d6() + 2);

    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

        //Make a touch attack to afflict target
        // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        if (TouchAttackMelee(si.target, si.item == OBJECT_INVALID) > 0){
            //SR and Saves
            if(!GetSpellResisted(si, si.target) && !GetSpellSaved(si, SAVING_THROW_FORT, si.target, SAVING_THROW_TYPE_NEGATIVE)){
                //Create an instance of the AOE Object using the Apply Effect function
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(si.target), fDuration);
            }
        }
    }
}

