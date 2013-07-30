#include "gsp_func_inc"

void main(){
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 0);

    switch (si.id){
        case SPELL_CURE_MINOR_WOUNDS:    Cure(si, 1, VFX_IMP_SUNSTRIKE, VFX_IMP_HEAD_HEAL); break;
        case SPELL_CURE_LIGHT_WOUNDS:    Cure(si, MetaPower(si, 1, 8, si.clevel, fb.dmg), VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_S); break;
        case SPELL_CURE_MODERATE_WOUNDS: Cure(si, MetaPower(si, 2, 8, si.clevel, fb.dmg), VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_M); break;
        case SPELL_CURE_SERIOUS_WOUNDS:  Cure(si, MetaPower(si, 3, 8, si.clevel, fb.dmg), VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_L); break;
        case SPELL_CURE_CRITICAL_WOUNDS: Cure(si, MetaPower(si, 4, 8, si.clevel, fb.dmg), VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G); break;
        case SPELL_HEAL:
                Cure(si, GetMaxHitPoints(si.target), VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_X);
        break;

        case SPELL_INFLICT_MINOR_WOUNDS:    Harm(si, 1, 246, VFX_IMP_HEALING_G); break;
        case SPELL_INFLICT_LIGHT_WOUNDS:    Harm(si, MetaPower(si, 1, 8, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case SPELL_INFLICT_MODERATE_WOUNDS: Harm(si, MetaPower(si, 2, 8, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case SPELL_INFLICT_SERIOUS_WOUNDS:  Harm(si, MetaPower(si, 3, 8, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case 611: // BG
            Harm(si, MetaPower(si, si.clevel, 8, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case SPELL_INFLICT_CRITICAL_WOUNDS: Harm(si, MetaPower(si, 4, 8, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case 612: // BG
            Harm(si, MetaPower(si, si.clevel, 12, si.clevel, fb.dmg), 246, VFX_IMP_HEALING_G); break;
        case SPELL_HARM:
                Harm(si, GetCurrentHitPoints(si.target) - d4(), 246, VFX_IMP_HEALING_G);
        case 759: // Undead Harm Self.
                //Harm(si, GetCurrentHitPoints(si.target), 246, VFX_IMP_HEALING_G);
        break;
    }
}
