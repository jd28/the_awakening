//::///////////////////////////////////////////////
//:: Drown
//:: [X0_S0_Drown.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    if the creature fails a FORT throw.
    Does not work against Undead, Constructs, or Elementals.

January 2003:
 - Changed to instant kill the target.
May 2003:
 - Changed damage to 90% of current HP, instead of instant kill.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 26 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    int nDam = FloatToInt(GetCurrentHitPoints(si.target) * 0.5);
    //Set visual effect
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Check faction of target
    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make SR Check
        if(!GetSpellResisted(si, si.target)){
            // * certain racial types are immune
            if ((GetRacialType(si.target) != RACIAL_TYPE_CONSTRUCT) &&
                (GetRacialType(si.target) != RACIAL_TYPE_UNDEAD)    &&
                (GetRacialType(si.target) != RACIAL_TYPE_ELEMENTAL))
            {
                //Make a fortitude save
                if(GetSpellSaved(si, SAVING_THROW_FORT, si.target)){
                    nDam /= 2;
                }

                if(nDam > 0){
                    //Apply the VFX impact and damage effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
                    eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target);
                }
            }
        }
    }
}





