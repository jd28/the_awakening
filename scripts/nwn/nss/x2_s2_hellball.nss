//::///////////////////////////////////////////////
//:: Hellball
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
Long range area of effect spell
10d6 sonic, acid, fire and lightning damage to all
objects in the area

10d6 points of negative energy damage to caster
if MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER switch
was enabled on the module.

This spell is supposed to hurt the caster if he
is stupid enough to stand in the area of effect
when all hell breaks loose. It will hurt other
players allied with the caster as well. These
effects are dependent on your difficulty setting

Save is 20 + relevant ability score, or, when cast
by a placeable, equal to the placeables WILL Save

There is no benefit from the evasion feats here
as the area of the spell is too large to avoid it


*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Noobs, Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////


#include "gsp_func_inc"
#include "x2_inc_spellhook"


void main(){

    if (!X2PreSpellCastCode()) return;

    struct SpellInfo sSI = GetSpellInfo(OBJECT_SELF);

    //Declare major variables
    int nDamage1, nDamage2, nDamage3, nDamage4;
    float fDelay;
    effect eExplode = EffectVisualEffect(464);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eVis3 = EffectVisualEffect(VFX_IMP_SONIC);

    // if this option has been enabled, the caster will take damage for casting
    // epic spells, as descripbed in the ELHB
    if (GetModuleSwitchValue( MODULE_SWITCH_EPIC_SPELLS_HURT_CASTER) == TRUE){
        effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        int nDamage5 = d8(10);
        effect eDam5 = EffectDamage(nDamage5, DAMAGE_TYPE_NEGATIVE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam5, OBJECT_SELF);
    }



    effect eDam1, eDam2, eDam3, eDam4, eDam5, eKnock;
    eKnock = EffectKnockdown();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, sSI.loc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, sSI.loc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    int nTotalDamage;
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {

            SignalEvent(oTarget, EventSpellCastAt(sSI.caster, sSI.id));

            fDelay = GetDistanceBetweenLocations(sSI.loc, GetLocation(oTarget))/20 + 0.5f;
            //Roll damage for each target
            nDamage1 = d6(30) + 20;
            nDamage2 = d6(30) + 20;
            nDamage3 = d6(30) + 20;
            nDamage4 = d6(30) + 20;
            // no we don't care about evasion. there is no evasion to hellball
            if (MySavingThrow(SAVING_THROW_REFLEX,oTarget, sSI.dc, SAVING_THROW_TYPE_SPELL, sSI.caster, fDelay) >0){
                nDamage1 /=2;
                nDamage2 /=2;
                nDamage3 /=2;
                nDamage4 /=2;
            }
            nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;
            //Set the damage effect
            eDam1 = EffectDamage(nDamage1, DAMAGE_TYPE_NEGATIVE);
            eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_POSITIVE);
            eDam3 = EffectDamage(nDamage3, DAMAGE_TYPE_FIRE);
            eDam4 = EffectDamage(nDamage4, DAMAGE_TYPE_SONIC);

            if(nTotalDamage > 0)
            {
                if (nTotalDamage > 50)
                {
                    DelayCommand(fDelay+0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget,3.0f));
                }

                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam3, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam4, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay+0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                DelayCommand(fDelay+0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, sSI.loc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


}

