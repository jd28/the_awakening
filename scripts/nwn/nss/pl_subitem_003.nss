// pl_subitem_0023
// Kamakazi
#include "gsp_func_inc"

void DoBomb(object oPC){
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M), eDam;
    effect eDeath = SupernaturalEffect(EffectDeath());
    ApplyVisualAtLocation(VFX_FNF_FIREBALL, GetLocation(oPC));
    ApplyVisualAtLocation(481, GetLocation(oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(oPC));
    while (oTarget != OBJECT_INVALID){
        if(!GetIsNeutral(oTarget, oPC)){

            fDelay = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget))/20 + 0.5f;
            //Roll damage for each target
            nDamage = 10 + d8(GetHitDice(oPC));
            // no we don't care about evasion. there is no evasion to hellball
            if (MySavingThrow(SAVING_THROW_REFLEX,oTarget, 10 + GetHitDice(oPC), SAVING_THROW_TYPE_SPELL, oPC, fDelay) >0){
                nDamage /=2;
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);

            if(nDamage > 0){
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(oPC));
    }
}

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item

    DelayCommand(1.0, FloatingTextStringOnCreature("Bomb will detinate in 3...", oPC, FALSE));
    DelayCommand(2.0, FloatingTextStringOnCreature("Bomb will detinate in 2...", oPC, FALSE));
    DelayCommand(3.0, FloatingTextStringOnCreature("Bomb will detinate in 1...", oPC, FALSE));
    DelayCommand(4.0, AssignCommand(oPC, DoBomb(oPC)));
}
