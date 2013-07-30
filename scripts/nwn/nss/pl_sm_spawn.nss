//pl_sm_spawn
//
//spawn master OnSpawn Script


#include "mod_funcs_inc"
#include "pl_sm_inc"

void main(){
    SetName(OBJECT_SELF, " ");
    SetLocalInt(OBJECT_SELF, "PL_SM_LOCKED", TRUE);
    DelayCommand(30.0f, DeleteLocalInt(OBJECT_SELF, "PL_SM_LOCKED"));

    effect eEff = EffectCutsceneGhost();
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, OBJECT_SELF);
    eEff = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, OBJECT_SELF);

    //Logger(GetFirstPC(), VAR_DEBUG_LOGS, LOGLEVEL_DEBUG, "Spawn Master Spawned: %s",
    //    GetTag(OBJECT_SELF));

    //Spawn the monsters immegiately.
    SMDoSpawn();
}
