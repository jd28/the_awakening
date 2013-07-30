
void main()
{
    //Set the AOE effect and place it in the world.  The Aura abilities
    //are all permamnent and do not require recasting.
    effect eAOE = EffectAreaOfEffect(AOE_MOB_BLINDING);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
