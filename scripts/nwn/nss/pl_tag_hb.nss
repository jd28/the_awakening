#include "mod_funcs_inc"

void main()
{
    if(GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND) ||
       GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND)){
        IncrementLocalInt(OBJECT_SELF, "BigbyCount");
        if(GetLocalInt(OBJECT_SELF, "BigbyCount") >= 5){
            ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), OBJECT_SELF);
        }
        return;
    }

    if(GetLocalInt(OBJECT_SELF, "BigbyCount") > 0)
        DeleteLocalInt(OBJECT_SELF, "BigbyCount");

}
