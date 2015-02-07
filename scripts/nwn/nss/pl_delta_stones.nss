///////////////////////////////////////////////////////////////////////////////
//:: File: tdfakestone_used
//:: Date: 06/19/08
//:: Acknowledgements: Taken from Path of Acension.
//:: Description: Respawns pile of stones after use.
///////////////////////////////////////////////////////////////////////////////

#include "quest_func_inc"

void RespawnObject(string sResref, int iType, location lLoc) {
    CreateObject(iType, sResref, lLoc);
}

void main(){
    object oSnake, oPC = GetLastUsedBy();
    int iType = GetObjectType(OBJECT_SELF);

    // For creatures, save the location at spawn-time as a local location and
    // use it instead. Otherwise, the creature will respawn where it died.
    location lLoc = GetLocation(OBJECT_SELF);

    float fDelay = 300.0;  // Delay in seconds before fake rocks respawn.

    if(GetLocalInt(OBJECT_SELF, "Right")){
		CreateItemOnObject("pl_delta_key", OBJECT_SELF);
		effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

		DeleteLocalInt(GetModule(), "pl_delta_key");
        WriteTimestampedLogEntry("QUEST : Key Found.");
        DelayCommand(1.0f, SpawnDeltaKey());
        DestroyObject(OBJECT_SELF, 0.1);
    }
    else{
        if(Random(100)+1 > 50)
            oSnake = CreateObject(OBJECT_TYPE_CREATURE, "pl_delta_viper", lLoc);

        AssignCommand(GetModule(), DelayCommand(fDelay, RespawnObject("pl_delta_stones", iType, lLoc)));

        DestroyObject(OBJECT_SELF, 0.0);
    }
}
