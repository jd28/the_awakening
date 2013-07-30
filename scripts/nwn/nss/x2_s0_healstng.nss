//::///////////////////////////////////////////////
//:: Healing Sting
//:: X2_S0_HealStng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You inflict 1d6 +1 point per level damage to
    the living creature touched and gain an equal
    amount of hit points. You may not gain more
    hit points then your maximum with the Healing
    Sting.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 19, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, 19/10/2003
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 20);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;
    int nDamage = MetaPower(si, 6, nDamDice, 0, fb.dmg);

    //Declare effects
    effect eHeal = EffectHeal(nDamage / 2);
    effect eVs = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eLink = EffectLinkEffects(eVs,eHeal);

    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eLink2 = EffectLinkEffects(eVis, eDamage);

    if(GetObjectType(si.target) == OBJECT_TYPE_CREATURE){
        if(!GetIsReactionTypeFriendly(si.target)){
           //Signal spell cast at event
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
            //Spell resistance
            if(GetSpellResisted(si, si.target) ||
               GetSpellSaved(si, SAVING_THROW_FORT, si.target))
                return;

            //Apply effects to target and caster
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, si.target);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
        }
    }
}
