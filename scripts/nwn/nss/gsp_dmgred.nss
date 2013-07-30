////////////////////////////////////////////////////////////////////////////////
// gsp_dmgred
//
// Spells: Stoneskin, Greater Stoneskin, Premonition, Epic Warding.
//
// TODO: Get the damage power calculated right.
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"



void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nShape = SHAPE_SPHERE;
    int nDamRed, nDamRedPower, nDamRedLimit;
    int bEtraordinary = FALSE, bSupernatural = FALSE, bSingleTarget = TRUE, bDebug = FALSE;
    float fRadius = RADIUS_SIZE_COLOSSAL, fDelay;
    float fDuration = MetaDuration(si, si.clevel, DURATION_IN_HOURS);
    effect eImpact, eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eLink;

    int nVis;

    switch(si.id){
        // Spells
        case SPELL_GREATER_STONESKIN:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN));
            eImpact = EffectVisualEffect(VFX_IMP_POLYMORPH);

            nDamRedLimit = (si.clevel > 15) ? 150 : si.clevel * 15;
            nDamRed = 20;
            nDamRedPower;

            if(si.clevel <= 20)
                nDamRedPower = 5;
            else if(si.clevel <= 30)
                nDamRedPower = 6;
            else {
                nDamRedPower = 6 + ((si.clevel - 30) / 6); // +11 at 60
                nDamRed += ((si.clevel - 30) / 6);
            }

            nDamRedPower = GetDamagePower(nDamRedPower);
        break;
        case SPELL_PREMONITION:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROT_PREMONITION));

            nDamRedLimit = si.clevel * 10;
            nDamRed = 30;

            if(si.clevel <= 20)
                nDamRedPower = 5;
            else if(si.clevel <= 30)
                nDamRedPower = 6;
            else {
                nDamRedPower = 6 + ((si.clevel - 30) / 6); // +11 at 60
                nDamRed += ((si.clevel - 30) / 6);
            }
            nDamRedPower = GetDamagePower(nDamRedPower);

        break;
        case SPELL_STONESKIN:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_PROT_STONESKIN));
            eImpact = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

            nDamRed = 10;
            nDamRedLimit = (si.clevel > 10) ? 100 : si.clevel * 10;

            if(si.clevel <= 20)
                nDamRedPower = 4;
            else if(si.clevel <= 30)
                nDamRedPower = 5;
            else {
                nDamRedPower = 5 + ((si.clevel - 30) / 6); // +10 at 60
                nDamRed += ((si.clevel - 30) / 6);
            }
            nDamRedPower = GetDamagePower(nDamRedPower);
        break;
    }
    if(bDebug){
        Logger(si.caster, VAR_DEBUG_SPELLS, LOGLEVEL_DEBUG, "Generic Damage Reduction: " +
               "Soak: %s/+%s; Limit: %s", IntToString(nDamRed), IntToString(nDamRedPower),
               IntToString(nDamRedLimit));
    }
    eLink = eDur;

    if(nDamRed > 0)
        eLink = EffectLinkEffects(eLink, EffectDamageReduction(nDamRed, nDamRedPower, nDamRedLimit));

    if(bEtraordinary)
        eLink = ExtraordinaryEffect(eLink);

    if(bSupernatural)
        eLink = SupernaturalEffect(eLink);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, si.loc);
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                //Fire spell cast at event for target
                SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));
                //Apply VFX impact and bonus effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, si.loc);
        }
    }
}
