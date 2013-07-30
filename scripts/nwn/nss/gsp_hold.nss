////////////////////////////////////////////////////////////////////////////////
// gsp_hold
//
// Spells: Hold animal, hold monster, hold person.
//
////////////////////////////////////////////////////////////////////////////////

#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDuration = MetaDuration(si, 2);
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);


    switch(si.id){
        case SPELL_HOLD_ANIMAL:
            if(!GetRacialType(si.target) == RACIAL_TYPE_ANIMAL)
                return;
        break;
        case SPELL_HOLD_PERSON:
            if (!GetIsPlayableRacialType(si.target) ||
                !GetRacialType(si.target) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
                !GetRacialType(si.target) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
                !GetRacialType(si.target) == RACIAL_TYPE_HUMANOID_ORC ||
                !GetRacialType(si.target) == RACIAL_TYPE_HUMANOID_REPTILIAN)
                return;
        break;
        case SPELL_HOLD_MONSTER:
            // Nothing to be done
        break;
    }

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eDur3);

    if(!GetIsReactionTypeFriendly(si.target)){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));
        //Make SR check
        if (!GetSpellResisted(si, si.target)){
            //Make Will Save
            if(!GetSpellSaved(si, SAVING_THROW_WILL, si.target, SAVING_THROW_TYPE_NONE))
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
        }
    }
}
