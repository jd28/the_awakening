#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDelay, fRadius = RADIUS_SIZE_GARGANTUAN, fDist = 0.0,fDelay2, fTime;
    int nBaseDamage, nDamage, nDamage2, bStorm = FALSE, bImm = FALSE, bKnockdown = FALSE, bOneHit = FALSE;
    int nMask = OBJECT_TYPE_CREATURE;
    int nSave = 0, nSaveType = SAVING_THROW_TYPE_NONE;
    int nMissiles = si.clevel, nDamType = DAMAGE_TYPE_MAGICAL, nDamDice, nDamSides = 6, nDamBonus;
    effect eVis, eMissile, eDam;

    switch(si.id){
        case SPELL_ISAACS_LESSER_MISSILE_STORM:
            eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
            eMissile = EffectVisualEffect(VFX_IMP_MIRV);
            nDamDice = 1;
            if (si.clevel > 10) nMissiles = (10 + ((si.clevel - 10) / 5));
        break;
        case SPELL_ISAACS_GREATER_MISSILE_STORM:
            eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
            eMissile = EffectVisualEffect(VFX_IMP_MIRV);
            nDamDice = 2;
            if (si.clevel > 20) nMissiles = (20 + ((si.clevel - 20) / 4));
        break;
        case SPELL_FIREBRAND:
            nDamSides = 8;
            bOneHit = TRUE;
            eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
            eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
            nSave = SAVING_THROW_REFLEX;
            nDamType = DAMAGE_TYPE_FIRE;
            if (si.clevel > 30) nMissiles = 30;
            nDamDice = nMissiles;
        break;
        case SPELL_BALL_LIGHTNING:
            nDamSides = 8;
            bOneHit = TRUE;
            eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
            eMissile = EffectVisualEffect(503);
            nSave = SAVING_THROW_REFLEX;
            nDamType = DAMAGE_TYPE_ELECTRICAL;
            if (si.clevel > 30) nMissiles = 30;
            nDamDice = nMissiles;
        break;
    }

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);

    if (nSaveType == SAVING_THROW_TYPE_NONE) {
        switch (nDamType) {
            case DAMAGE_TYPE_ACID:       nSaveType = SAVING_THROW_TYPE_ACID;        break;
            case DAMAGE_TYPE_COLD:       nSaveType = SAVING_THROW_TYPE_COLD;        break;
            case DAMAGE_TYPE_ELECTRICAL: nSaveType = SAVING_THROW_TYPE_ELECTRICITY; break;
            case DAMAGE_TYPE_FIRE:       nSaveType = SAVING_THROW_TYPE_FIRE;        break;
            case DAMAGE_TYPE_SONIC:      nSaveType = SAVING_THROW_TYPE_SONIC;       break;
            case DAMAGE_TYPE_DIVINE:     nSaveType = SAVING_THROW_TYPE_DIVINE;      break;
            case DAMAGE_TYPE_MAGICAL:    nSaveType = SAVING_THROW_TYPE_SPELL;       break;
            case DAMAGE_TYPE_NEGATIVE:   nSaveType = SAVING_THROW_TYPE_NEGATIVE;    break;
            case DAMAGE_TYPE_POSITIVE:   nSaveType = SAVING_THROW_TYPE_POSITIVE;    break;
        }
    }

    if (GetLocalInt(si.caster, "DebugSpells")) {
        string sMessage = "Generic Missle Storm: Radius: " + FloatToString(fRadius, 1, 1) +
            ", Damage: " + IntToString(nDamDice) + "d" + IntToString(nDamSides) +
            "+" + IntToString(nDamBonus) + " " + GetDamageTypeName(nDamType);
        sMessage += ", Save: " + GetSaveName(nSave, TRUE) + "/" + GetSaveTypeName(nSaveType, TRUE);
        sMessage += ", Mask: " + IntToHexString(nMask);
        if (GetIsPC(si.caster))
            SendMessageToPC(si.caster, C_WHITE + sMessage + C_END);
        else
            WriteTimestampedLogEntry("SPELLDEBUG : " + sMessage);
    }


        /* New Algorithm
            1. Count # of targets
            2. Determine number of missiles
            3. First target gets a missile and all Excess missiles
            4. Rest of targets (max nMissiles) get one missile
       */
    int nCnt = 1;
    int nEnemies = 0;

    si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(si.target)){
        // * caster cannot be harmed by this spell
        if (GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE)){
            // GZ: You can only fire missiles on visible targets
            // If the firing object is a placeable (such as a projectile trap),
            // we skip the line of sight check as placeables can't "see" things.
            if (( GetObjectType(si.caster) == OBJECT_TYPE_PLACEABLE ) ||
                   GetObjectSeen(si.target, si.caster))
            {
                nEnemies++;
            }
        }
        si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
     }

     if (nEnemies == 0) return; // * Exit if no enemies to hit

     int nExtraMissiles = nMissiles / nEnemies;

     // April 2003
     // * if more enemies than missiles, need to make sure that at least
     // * one missile will hit each of the enemies
     if (nExtraMissiles <= 0) nExtraMissiles = 1;

     // by default the Remainder will be 0 (if more than enough enemies for all the missiles)
     int nRemainder = 0;

     if (nExtraMissiles > 0) nRemainder = nMissiles % nEnemies;

     if (nEnemies > nMissiles) nEnemies = nMissiles;

    si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(si.target) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE) &&
           (( GetObjectType(si.caster) == OBJECT_TYPE_PLACEABLE ) ||
            (GetObjectSeen(si.target, si.caster))))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

                // * recalculate appropriate distances
                fDist = GetDistanceBetween(si.caster, si.target);
                fDelay = fDist/(3.0 * log(fDist) + 2.0);

                // Firebrand.
                // It means that once the target has taken damage this round from the
                // spell it won't take subsequent damage
                if (bOneHit){
                    nExtraMissiles = 1;
                    nRemainder = 0;
                }

                int i = 0;
                //--------------------------------------------------------------
                // GZ: Moved SR check out of loop to have 1 check per target
                //     not one check per missile, which would rip spell mantels apart
                //--------------------------------------------------------------
                if (!GetSpellResisted(si, si.target, fDelay)){
                    for (i=1; i <= nExtraMissiles + nRemainder; i++){
                        nBaseDamage = MetaPower(si, nDamDice, nDamSides, nDamBonus, fb.dmg);
                        if (nSave == SAVING_THROW_REFLEX) {
                            nDamage = GetReflexAdjustedDamage(nBaseDamage, si.target, si.dc, nSaveType);
                        } else if (nSave > 0) {
                            if (GetSpellSaved(si, nSave, si.target, nSaveType, fDelay))
                                nDamage = nBaseDamage / 2;
                            else
                                nDamage = nBaseDamage;
                        } else
                            nDamage = nBaseDamage;

                        fTime = fDelay;
                        fDelay2 += 0.1;
                        fTime += fDelay2;

                        //Set damage effect
                        effect eDam = EffectDamage(nDamage, nDamType);
                        //Apply the MIRV and damage effect
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, si.target));
                        DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, si.target));
                        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
                    }
                } // for
                else{  // * apply a dummy visual effect
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, si.target);
                }
                nCnt++;// * increment count of missiles fired
                nRemainder = 0;
        }
        si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc, !bStorm, nMask);
    }

}
