////////////////////////////////////////////////////////////////////////////////
// gsp_move
//
// Spells:
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int bSingleTarget = TRUE, nShape;
    float fDuration, fDelay, fRadius = RADIUS_SIZE_COLOSSAL;
    effect eVis, eMove;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    string sMessage, sName;

    switch(si.id){
        case SPELL_MASS_HASTE:
            bSingleTarget = FALSE;
        case SPELL_HASTE:
            eVis = EffectVisualEffect(VFX_IMP_HASTE);
            if(si.class == CLASS_TYPE_BARD){
                fDuration = MetaDuration(si, 10);
                eMove = EffectMovementRate(MOVEMENT_RATE_FAST);
                if(si.id == SPELL_MASS_HASTE)
                    sName = "Mass Haste";
                else
                    sName = "Haste";
            }
            else
                eMove = EffectHaste();
        break;
        case SPELL_EXPEDITIOUS_RETREAT:
            fDuration = MetaDuration(si, 5);
            sName = "Expeditious Retreat";
            eMove = EffectMovementRate(MOVEMENT_RATE_FAST);
        break;
    }

    if (GetLocalInt(si.caster, "SPELL_DELAY_" + IntToString(si.id))){
        ErrorMessage(si.caster, sName+" is not castable yet.");
        return;
    }

    sMessage = IntToString(FloatToInt(2*fDuration));
    ErrorMessage(si.caster, sName+" Recastable In " + sMessage + " seconds.");
    DelayCommand(0.6, SpellDelay(si.caster, sName, si.id, 2*fDuration));

    effect eLink = EffectLinkEffects(eMove, eDur);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target);
        if(GetLevelByClass(CLASS_TYPE_MONK, si.target) == 0)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
    }
    else{
        //Get the first target in the radius around the caster
        object oTarget = GetFirstObjectInShape(nShape, fRadius, GetLocation(si.caster));
        while(GetIsObjectValid(oTarget)){
            if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget)){
                fDelay = GetRandomDelay(0.4, 1.1);
                //Fire spell cast at event for target
                SignalEvent(oTarget, EventSpellCastAt(si.caster, si.id, FALSE));
                //Apply VFX impact and bonus effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                if(GetLevelByClass(CLASS_TYPE_MONK, oTarget) == 0)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
            //Get the next target in the specified area around the caster
            oTarget = GetNextObjectInShape(nShape, fRadius, GetLocation(si.caster));
        }
    }
}
