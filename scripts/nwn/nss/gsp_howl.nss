#include "gsp_func_inc"



void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    struct SpellImpact impact = CreateSpellImpact();
    int nCap, nHowl;

    si.clevel = GetHitDice(si.caster);
    si.loc    = GetLocation(si.caster);
    si.dc     = si.clevel;

    switch(si.id){
        case SPELLABILITY_HOWL_SONIC:
            nHowl = VFX_FNF_HOWL_WAR_CRY;
        break;
        case SPELLABILITY_HOWL_CONFUSE:
            nHowl = VFX_FNF_HOWL_MIND;
        break;
        case SPELLABILITY_HOWL_DOOM:
            nHowl = VFX_FNF_HOWL_ODD;
        break;
        case SPELLABILITY_HOWL_FEAR:
            nHowl = VFX_FNF_HOWL_MIND;
        break; 
        case SPELLABILITY_HOWL_PARALYSIS:
            nHowl = VFX_FNF_HOWL_ODD;
        break; 
        case 272: //SPELLABILITY_HOWL_STUN:
            ApplyVisualToObject(VFX_FNF_HOWL_MIND, si.caster);
            si.sp            = -1;
            impact.nSave     = 0;
            impact.nImpact   = VFX_IMP_STUN;
            impact.nMask     = OBJECT_TYPE_CREATURE;
            impact.nDamType  = DAMAGE_TYPE_ELECTRICAL;
            impact.nDamSides = 12;
            impact.nDamDice  = 45;
            nCap             = 60;
            impact.bStorm    = TRUE;
            impact.fRadius   = RADIUS_SIZE_COLOSSAL;

            impact.fDuration = RoundsToSeconds(d4()); 
            impact.nDurType  = -1;
            impact.nDurSave  = SAVING_THROW_WILL;
            impact.eDur      = EffectStunned();
            impact.nDurVis   = VFX_DUR_MIND_AFFECTING_NEGATIVE;  
        break;
        default:
            SpeakString("Error Spell: " + IntToString(si.id));
    }
    

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, nCap);
    impact.nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    ApplySpellImpactToShape(si, impact, fb);
}
