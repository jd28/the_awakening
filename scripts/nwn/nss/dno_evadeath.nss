void main()
{

object oPC = GetLastKiller();
if (GetIsPC(oPC)) return;

object oTarget = OBJECT_SELF;
location lTarget = GetLocation(oTarget);

effect eEffect;
eEffect = EffectDamage(75, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY);

ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION),(lTarget));

ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);

}

