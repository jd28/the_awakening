#include "nw_i0_generic"

void DoZombie2(object oSpawn, object oPC){
        AssignCommand(oSpawn, SetCommandable(TRUE, oSpawn));
        AssignCommand(oSpawn, ActionWait(5.0f));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oSpawn, 0.5f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectKnockdown()), oSpawn, 1.0f);

        AssignCommand(oSpawn, DetermineCombatRound(oPC));
        SetCommandable(FALSE, oSpawn);

}


void DoZombie(object oPC){
        location lTarget = GetLocation(OBJECT_SELF);
        object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "nr_truelyundead", lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL), lTarget);

        DelayCommand(0.5, DoZombie2(oSpawn, oPC));
}

void main(){

    object oPC = GetLastKiller();

    if (!GetIsPC(oPC)) return;

    if (d100()<=40){

        DelayCommand(1.0, DoZombie(oPC));

    }
}

