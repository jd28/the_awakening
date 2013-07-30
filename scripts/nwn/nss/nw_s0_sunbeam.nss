//::///////////////////////////////////////////////
//:: Sunbeam
//:: s_Sunbeam.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures in the beam are struck blind and suffer 4d6 points of damage. (A successful
//:: Reflex save negates the blindness and reduces the damage by half.) Creatures to whom sunlight
//:: is harmful or unnatural suffer double damage.
//::
//:: Undead creatures caught within the ray are dealt 1d6 points of damage per caster level
//:: (maximum 20d6), or half damage if a Reflex save is successful. In addition, the ray results in
//:: the total destruction of undead creatures specifically affected by sunlight if they fail their saves.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Feb 22, 2001
//:://////////////////////////////////////////////
//:: Last Modified By: Keith Soleski, On: March 21, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "gsp_func_inc"

// TODO : REDO

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
    effect eDam;
    effect eBlind = EffectBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eBlind, eDur);

    int nDamDice, nDamage, nMax;
    float fDelay;
    int nBlindLength = 3;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 40);
    nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, si.loc);

    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
    while(GetIsObjectValid(oTarget))
    {
        // Make a faction check
        if (GetIsSpellTarget(si, oTarget, TARGET_TYPE_SELECTIVE)){
            fDelay = GetRandomDelay(1.0, 2.0);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));
            //Make an SR check
            if (!GetSpellResisted(si, oTarget, 1.0)){
                //Check if the target is an undead
                if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ||
                    GetLevelByClass(CLASS_TYPE_PALE_MASTER, oTarget) > 0){
                    //Roll damage and save
                    nDamage = MetaPower(si, nDamDice, 6, 0, fb.dmg);
                }
                else{
                    nDamage = MetaPower(si, nDamDice / 2, 6, 0, fb.dmg);
                }

                //Check that a reflex save was made.
                if(!GetSpellSaved(si, SAVING_THROW_REFLEX, oTarget, SAVING_THROW_TYPE_DIVINE, 1.0))
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindLength)));
                else //
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_DIVINE);

                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                if(nDamage > 0){
                    //Apply the damage effect and VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, si.loc);
    }
}
