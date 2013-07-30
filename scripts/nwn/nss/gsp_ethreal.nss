////////////////////////////////////////////////////////////////////////////////
// gsp_ethreal
//
// Spells: Sanctuary, Greater Sanctuary.
////////////////////////////////////////////////////////////////////////////////


#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    float fDuration, fDelay;
    effect eVis, eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), eLink, eSanc;

    switch (si.id) {
        case SPELL_SANCTUARY:
            fDuration = MetaDuration(si, si.clevel);
            eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
            eSanc = EffectSanctuary(si.dc);
        break;
        case SPELL_NATURES_BALANCE:
        case SPELL_ETHEREALNESS: // Greater Sanctuary.
            eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
            eSanc = EffectEthereal();
            fDuration = (si.meta == METAMAGIC_EXTEND) ? 24.0f : 12.0f;
            fDelay = (si.meta == METAMAGIC_EXTEND) ? 60.0f : 30.0f;

            if (GetLocalInt(OBJECT_SELF, "SPELL_DELAY_" + IntToString(si.id)) == 1){
                SendMessageToPC(si.caster, C_RED + "Greater Sanctuary is not castable yet." + C_END);
                return;
            }
            string sMessage = IntToString(FloatToInt(fDelay));
            SendMessageToPC(si.caster, C_RED + "Greater Sanctuary Recastable In " + sMessage + " seconds." + C_END);
            DelayCommand(0.2, SpellDelay(si.caster, "Greater Sanctuary", si.id, fDelay));
        break;
    }
    Logger(si.caster, "DebugSpells", LOGLEVEL_DEBUG, "Generic Ethrealness: Spell: %s, Duration: %s, Cooldown: %s",
           IntToString(si.id), FloatToString(fDuration, 4, 0), FloatToString(fDelay, 4, 0));

    //Fire cast spell at event for the specified target
    SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

    eLink = EffectLinkEffects(eDur, eVis);
    eLink = EffectLinkEffects(eLink, eSanc);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, fDuration);
}
