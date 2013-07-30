#include "nw_i0_tool"
#include "x2_inc_switches"
void main()
{

object oSelf = OBJECT_SELF;

int nCharisma = GetAbilityModifier(ABILITY_CHARISMA, oSelf);
int nChaTwice = (nCharisma * 2);
int nChaHalf = (nCharisma / 2);
int nChaPlusHalf = (nCharisma + nChaHalf);

effect eVis1 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
effect eDamage = EffectDamageIncrease(nChaTwice, DAMAGE_TYPE_NEGATIVE);
effect eDiv1 = EffectLinkEffects(eDamage, eVis1);

effect eVis2 = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
effect eProtection = EffectDamageReduction(nChaTwice, DAMAGE_POWER_PLUS_TWENTY, 0);
effect eDiv2 = EffectLinkEffects(eProtection, eVis2);

effect eDiv3 =  EffectLinkEffects(eDiv1, eDiv2);

effect eRegen = EffectRegenerate(nChaPlusHalf, 3.0);
effect eShield = EffectDamageShield(nChaTwice, DAMAGE_BONUS_2d12, DAMAGE_TYPE_FIRE);
effect eDiv4 =  EffectLinkEffects(eRegen, eShield);

effect eDiv =  EffectLinkEffects(eDiv3, eDiv4);

//ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDiv, oSelf);
//ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDiv2, oSelf);
 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDiv, oSelf);

}
