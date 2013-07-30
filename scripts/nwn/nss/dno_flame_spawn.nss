void main()
 {
 object oTarget = OBJECT_SELF;

    effect eVis = EffectVisualEffect(VFX_DUR_INFERNO_NO_SOUND);
    effect eShield = EffectDamageShield(30, DAMAGE_BONUS_2d10, DAMAGE_TYPE_FIRE);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShield, oTarget);
}
