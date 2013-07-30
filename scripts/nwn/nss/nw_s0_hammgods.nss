#include "gsp_func_inc"

void main(){

    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0) return;

    //Declare major variables
    int nDamage;

    effect eDam;
    effect eDaze = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eStrike = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    float fDelay;

    struct FocusBonus fb = GetOffensiveFocusBonus(si.caster, si.school, 40);
    int nDamDice = (si.clevel > fb.cap) ? fb.cap : si.clevel;

    //Apply the holy strike VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, si.loc);
    
    for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc); 
        si.target != OBJECT_INVALID;
        si.target = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, si.loc)){ 

        //Make faction checks
        if (!GetIsSpellTarget(si, si.target, TARGET_TYPE_SELECTIVE))
            continue;
    
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id));

        //Make SR Check
        if (GetSpellResisted(si, si.target))
            continue;

        fDelay = GetRandomDelay(0.6, 1.3);

        //Roll damage
        nDamage = MetaPower(si, nDamDice, 8, 0, fb.dmg);

        //Make a will save for half damage and negation of daze effect
        if (GetSpellSaved(si, SAVING_THROW_WILL, si.target, SAVING_THROW_TYPE_DIVINE, fDelay))
            nDamage = nDamage / 2;
        else //Apply daze effect
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, si.target, RoundsToSeconds(2)));

        //Set damage effect
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE );
        //Apply the VFX impact and damage effect
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, si.target));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, si.target));
    }
}
