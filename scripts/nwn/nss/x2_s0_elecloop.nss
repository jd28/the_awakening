//::///////////////////////////////////////////////
//:: Gedlee's Electric Loop
//:: X2_S0_ElecLoop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create a small stroke of lightning that
    cycles through all creatures in the area of effect.
    The spell deals 1d6 points of damage per 2 caster
    levels (maximum 5d6). Those who fail their Reflex
    saves must succeed at a Will save or be stunned
    for 1 round.

    Spell is standard hostile, so if you use it
    in hardcore mode, it will zap yourself!

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 19 2003
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main() {
    struct SpellInfo si = GetSpellInfo(OBJECT_SELF);

    float    fDelay;
    effect   eBeam;
    int      nDamage;
    int      nPotential;
    effect   eDam;
    object   last;
    effect   eStrike = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect   eStun   = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN), EffectStunned());
    int      dice    = si.clevel / 2;
    object   target;
    for ( target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, si.loc, TRUE, OBJECT_TYPE_CREATURE);
          GetIsObjectValid(target);
          target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, si.loc, TRUE, OBJECT_TYPE_CREATURE) ) {

        if ( !GetIsSpellTarget(si, target) ) { continue; }
        
        SignalEvent(target, EventSpellCastAt(si.caster, si.id));

        //------------------------------------------------------------------
        // Calculate delay until spell hits current target. If we are the
        // first target, the delay is the time until the spell hits us
        //------------------------------------------------------------------
        if ( GetIsObjectValid(last) ) {
            fDelay += 0.2f;
            fDelay += GetDistanceBetweenLocations(GetLocation(last), GetLocation(target)) / 20;
            eBeam = EffectBeam(VFX_BEAM_LIGHTNING, last, BODY_NODE_CHEST);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, target, 1.5f));
        }
        else {
            fDelay = GetDistanceBetweenLocations(si.loc, GetLocation(target)) / 20;
        }

        if ( GetSpellResisted(si, target, fDelay) ) { continue; }

        nPotential = MetaPower(si, dice, 6, 0, 0);
        nDamage    = GetReflexAdjustedDamage(nPotential, target, si.dc, SAVING_THROW_TYPE_ELECTRICITY);

        //--------------------------------------------------------------
        // If we failed the reflex save, we save vs will or are stunned
        // for one round
        //--------------------------------------------------------------
        if ( nPotential == nDamage || ( GetHasFeat(FEAT_IMPROVED_EVASION, target) &&  nDamage == (nPotential / 2)) ) {
            if( GetSpellSaved(si, SAVING_THROW_WILL, target, SAVING_THROW_TYPE_MIND_SPELLS, fDelay) ) { 
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, target, RoundsToSeconds(1)));
            }
        }

        if ( nDamage > 0 ) {
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, target));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, target));
        }

        last = target;
    }
}


