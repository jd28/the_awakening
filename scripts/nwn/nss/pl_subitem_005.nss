// pl_subitem_002
#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_ICESKIN);

	int bonus;
	int hd = GetHitDice(oPC);
	if (hd >= 38) {
		bonus = DAMAGE_BONUS_2d10;
	}
	else if (hd >= 28) {
		bonus = DAMAGE_BONUS_2d8;
	}
	else if (hd >= 18) {
		bonus = DAMAGE_BONUS_2d6;
	}
	else {
		bonus = DAMAGE_BONUS_2d6;
	}


    effect eDmgShield = EffectDamageShield(hd/2, bonus, DAMAGE_TYPE_COLD);
	effect imm = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 10);
	effect vul = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 10);
    effect eLink = EffectLinkEffects(eDur, eDur2);
    eLink = EffectLinkEffects(eLink, eDmgShield);
    eLink = EffectLinkEffects(eLink, imm);
    eLink = EffectLinkEffects(eLink, vul);

    ApplyVisualToObject(VFX_IMP_HEAD_COLD, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(hd));
}
