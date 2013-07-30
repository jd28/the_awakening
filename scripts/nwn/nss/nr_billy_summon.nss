#include "nw_i0_spells"
#include "x2_inc_switches"

void main(){

    if(GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();

    object oTarget;

    oTarget=GetHenchman(oPC);
    RemoveHenchman(oPC, oTarget);
    oTarget = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);

if (GetIsPossessedFamiliar(oTarget)) AssignCommand(oPC, UnpossessFamiliar(oTarget));

if (GetIsObjectValid(oTarget)) DestroyObject(oTarget);

oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);

if (GetIsObjectValid(oTarget)) DestroyObject(oTarget);

oTarget = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

if (GetIsObjectValid(oTarget)) RemoveSummonedAssociate(oPC, oTarget);

if (GetIsObjectValid(oTarget)) DestroyObject(oTarget);

oTarget = GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);

if (GetIsObjectValid(oTarget)) RemoveSpecificEffect(EFFECT_TYPE_DOMINATED, oTarget);

if (GetIsObjectValid(oTarget)) DestroyObject(oTarget);

effect eEffect;
eEffect = EffectSummonCreature("nr_billybutchers", VFX_FNF_SUMMON_EPIC_UNDEAD, 1.0);

ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);

}

