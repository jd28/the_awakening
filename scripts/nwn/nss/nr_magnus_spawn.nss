#include "area_inc"
/*
int GetNumberOfPCsInArea(object oArea){
    object oHolder = GetFirstObjectInArea(oArea);
    int result = 0;

    while(oHolder != OBJECT_INVALID){
        if(GetIsPC(oHolder) && !(GetIsDM(oHolder) || GetIsDMPossessed(oHolder))
            result += 1;

        oHolder = GetNextObjectInArea(oArea);
    }

    return result;
}
*/
void main(){
    object oTarget = OBJECT_SELF;
    object oPC = GetLastKiller();

    object oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "nr_magnus", GetLocation(oTarget), FALSE, "Spawned");
    DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), GetLocation(oSpawn)));

    // Upgrade
    object oStone = GetItemPossessedBy(oPC, "nr_task_stone");
    string sArea = GetTag(GetArea(oPC));

    if(oStone == OBJECT_INVALID)
        AssignCommand(oPC, SpeakString("Stone Invalid"));

    //AssignCommand(oPC, SpeakString(sArea));
    //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));

    if(sArea == "nr_wiztest_002"){
        SetLocalInt(oStone, "Task", 1);
        //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));
    }
    else if(sArea == "nr_wiztest_003"){
        SetLocalInt(oStone, "Task", 2);
        //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));
    }
    else if(sArea == "nr_wiztest_004"){
        SetLocalInt(oStone, "Task", 3);
        //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));
    }
    else if(sArea == "nr_wiztest_005"){
        SetLocalInt(oStone, "Task", 4);
        //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));
    }
    else if(sArea == "nr_wiztest_006"){
        SetLocalInt(oStone, "Task", 5);
        //AssignCommand(oPC, SpeakString(IntToString(GetLocalInt(oStone, "Task") )));
    }
}
