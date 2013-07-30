#include "gsp_func_inc"

void main () {
    struct SpellInfo si = GetSpellInfo();
    if (si.id < 0)
        return;
   
    int bSingleTarget = TRUE;
    int bHeal         = TRUE;
    int nPally;
    float fRadius;

    switch(si.id){
        case SPELL_PALADIN_SUMMON_MOUNT:
            nPally = GetLevelByClass(CLASS_TYPE_PALADIN, si.caster);     
            if (nPally >= 35){
                bSingleTarget = FALSE;        
                fRadius = 10.0f;
            }
            else if(nPally >= 25){
                fRadius = 5.0f;
                bSingleTarget = FALSE;        
            }

        break; 
        case SPELL_RAISE_DEAD:
            bHeal = FALSE;
        break;
        case SPELL_RESURRECTION:
        break;
    }
 

    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);

    if(bSingleTarget){
        //Fire cast spell at event for the specified target
        SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

        if(si.target == OBJECT_INVALID || !GetIsDead(si.target))
            return;

        // Jasperre's additions...
        AssignCommand(si.target, SpeakString("I AM ALIVE!", TALKVOLUME_SILENT_TALK));

        //Apply the bonus effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), si.target);
        if(bHeal)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(si.target) + 10), si.target);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(si.target));

        // Reapply SuperNatural Effects, in case.
        ApplyFeatSuperNaturalEffects(si.target);

    }
    else{
        //Apply Area Impact
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), si.loc);

        //Get the first target in the radius around the caster
        for(si.target = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, si.loc);
            si.target != OBJECT_INVALID;
            si.target = GetNextObjectInShape(SHAPE_SPHERE, fRadius, si.loc)){
        
            if(!GetIsDead(si.target))
                continue;
                
            fDelay = GetRandomDelay(0.4, 1.1);

            //Fire spell cast at event for target
            SignalEvent(si.target, EventSpellCastAt(si.caster, si.id, FALSE));

            // Jasperre's additions...
            AssignCommand(si.target, SpeakString("I AM ALIVE!", TALKVOLUME_SILENT_TALK));

            //Apply the bonus effect and VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), si.target);
            if(bHeal)
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(si.target) + 10), si.target);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(si.target));

            // Reapply SuperNatural Effects, in case.
            ApplyFeatSuperNaturalEffects(si.target);
        } 
    }
}
