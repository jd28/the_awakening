#include "gsp_func_inc"

void DoPious(struct SpellInfo si, struct SpellImpact impact, struct FocusBonus fb){
    DelayCommand(2.8f, ApplyVisualAtLocation(VFX_FNF_SCREEN_SHAKE, si.loc)); 
    DelayCommand(3.0f, ApplySpellImpactToShape(si, impact, fb)); 
}

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;
    struct SpellImpact impact = CreateSpellImpact();
    struct FocusBonus fb;

    si.loc    = GetLocation(si.caster);
    si.clevel = GetLevelByClass(CLASS_TYPE_PURPLE_DRAGON_KNIGHT, si.caster);
    
    impact.fRadius   = 20.0f;
    impact.nImpact   = VFX_IMP_LIGHTNING_M;
    impact.nDamType  = DAMAGE_TYPE_ELECTRICAL;
    impact.nDamDice  = si.clevel;
    impact.nDamSides = 12;
    impact.nSave     = SAVING_THROW_NONE;
    impact.eDur      = EffectKnockdown();
    impact.fDuration = RoundsToSeconds(d2());
    impact.nDurType  = EFFECT_TRUETYPE_KNOCKDOWN;
    impact.nDurSave  = SAVING_THROW_REFLEX;

    AssignCommand(si.caster, ClearAllActions(FALSE));
    AssignCommand(si.caster, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0f, 6.0f));
    AssignCommand(si.caster, DoPious(si, impact, fb));
    AssignCommand(si.caster, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(si.caster, SetCommandable(FALSE));
}
