//::///////////////////////////////////////////////
//:: Banishment
//:: x0_s0_banishment.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
    + As well any Outsiders being must make a
    save and SR check or be banished (up to
    2 HD creatures / level can be banished)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    object oMaster;
    // * the pool is the number of hit dice of creatures that can be banished
    int nPool = 2* si.clevel;

    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, si.loc);

    //Get the first object in the are of effect
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
    while(GetIsObjectValid(oTarget)){
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        if (oMaster == OBJECT_INVALID) oMaster = si.caster;

        // * BK: Removed the master check, only applys to Dismissal not banishment
        //Is that master valid and is he an enemy
        // if(GetIsObjectValid(oMaster) && GetIsEnemy(oMaster))
        {
            // * Is the creature a summoned associate
            // * or is the creature an outsider
            // * and is there enough points in the pool
            if((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
                GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
                GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget) ||
               (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER &&
                nPool > 0))
            {
                // * March 2003. Added a check so that 'friendlies' will not be
                // * unsummoned.
                if (GetIsSpellTarget(si, si.target, TARGET_TYPE_STANDARD)){
                    SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id));
                    // * Must be enough points in the pool to destroy target
                    if (nPool >= GetHitDice(oTarget))
                    // * Make SR and will save checks
                    if (!GetSpellResisted(si, oTarget) &&
                        !GetSpellSaved(si, SAVING_THROW_WILL, oTarget))
                    {
                         //Apply the VFX and delay the destruction of the summoned monster so
                         //that the script and VFX can play.
                         nPool = nPool - GetHitDice(oTarget);
                         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                         if (CanCreatureBeDestroyed(oTarget) == TRUE){
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));

                            DestroyObject(oTarget, 0.3);
                         }
                    }
                } // rep check
            }
        }
        //Get next creature in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(si.caster));
    }
}


