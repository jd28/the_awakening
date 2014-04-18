#include "mod_funcs_inc"
#include "nwnx_inc"

void main()
{
	effect eff;
	object creator = OBJECT_INVALID;
	for ( eff = GetFirstEffect(OBJECT_SELF);
		  GetIsEffectValid(eff);
		  eff = GetNextEffect(OBJECT_SELF) ) {
		if ( GetEffectSpellId(eff) == SPELL_BIGBYS_GRASPING_HAND ||
			 GetEffectSpellId(eff) == SPELL_BIGBYS_CRUSHING_HAND ) {
			creator = GetEffectCreator(eff);
		}
	}

    if(GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND) ||
       GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND)){
        IncrementLocalInt(OBJECT_SELF, "BigbyCount");
        if(GetLocalInt(OBJECT_SELF, "BigbyCount") >= 5){
			effect death = EffectDeath();
			SetEffectCreator(death, creator);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(death), OBJECT_SELF);
        }
        return;
    }

    if(GetLocalInt(OBJECT_SELF, "BigbyCount") > 0)
        DeleteLocalInt(OBJECT_SELF, "BigbyCount");

}
