////////////////////////////////////////////////////////////////////////////////
// gsp_mantle
//
// Spells: Lesser Spell Mantle, Spell Mantle, Greater Spell Mantle,
//      Minor Globe of Invulnerability, Minor Globe of Invulnerability (GSC),
//      Globe of Invulnerability
//
////////////////////////////////////////////////////////////////////////////////
#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    int nSpellAbsorb, nSpellAbsorbMax, nSpellAbsorbSchool = SPELL_SCHOOL_GENERAL;
    float fDuration = MetaDuration(si, si.clevel);
    effect eImpact, eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eLink, eEffect;

    si.target = si.caster;

    switch(si.id){
        // Spells
        case SPELL_GLOBE_OF_INVULNERABILITY:
            nSpellAbsorb = 4;
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GLOBE_MINOR));
        break;
        case SPELL_GREATER_SPELL_MANTLE:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_SPELLTURNING));
            nSpellAbsorb = 9;
            nSpellAbsorbMax = MetaPower(si, 12, 1, 10, 0);
        break;
        case SPELL_LESSER_SPELL_MANTLE:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_SPELLTURNING));
            nSpellAbsorb = 9;
            nSpellAbsorbMax = MetaPower(si, 4, 1, 6, 0);
        break;
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY:
        case SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
            nSpellAbsorb = 3;
        break;
        case SPELL_SPELL_MANTLE:
            eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_SPELLTURNING));
            nSpellAbsorb = 9;
            nSpellAbsorbMax = MetaPower(si, 8, 1, 8, 0);
        break;
        case 810: // PDK Final Stand
            si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
            fDuration = RoundsToSeconds(si.clevel / 2);
            if(si.clevel < 20){
                eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
                nSpellAbsorb = 3;
            }
            else {
                nSpellAbsorb = 4;
                eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_GLOBE_MINOR));
            }
        break;
    }

    eEffect = EffectSpellLevelAbsorption(nSpellAbsorb, nSpellAbsorbMax, nSpellAbsorbSchool);
    eLink = EffectLinkEffects(eEffect, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    // Remove any other mantle effects
    if(nSpellAbsorb == 9){
        RemoveEffectsFromSpell(si.target, SPELL_LESSER_SPELL_MANTLE);
        RemoveEffectsFromSpell(si.target, SPELL_GREATER_SPELL_MANTLE);
        RemoveEffectsFromSpell(si.target, SPELL_SPELL_MANTLE);
    }

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, si.target);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
}
