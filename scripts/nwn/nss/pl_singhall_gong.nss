void main(){
    object oPC = GetLastUsedBy(), oMonster;

    SpeakString("*Gong*");
    PlaySound("as_cv_bell2");

    int nGongCount = GetLocalInt(OBJECT_SELF, "GongCount") + 1;
    if(GetLocalInt(OBJECT_SELF, "Spawning") || nGongCount > 3)
        return;

    SetLocalInt(OBJECT_SELF, "Spawning", TRUE);
    int i = 1;

    string sResref;
    switch(nGongCount){
        case 1: sResref = "ms_tn_satyrbard"; break;
        case 2: sResref = "ms_harpy_002"; break;
        case 3: sResref = "ms_harpy_boss"; break;
    }
    string sWaypoint = "wp_sh_gong_" + IntToString(nGongCount) +"_";

    object oWaypoint = GetWaypointByTag(sWaypoint + IntToString(i)), oCreature;
    while(oWaypoint != OBJECT_INVALID){
        if(nGongCount == 3){
            if(i == 4 || i == 5){
                sResref = "ms_harpy_002";
            }
            else if(i == 2 || i == 3){
                sResref = "ms_tn_satyrbard";
            }
            else sResref = "ms_harpy_boss";
        }

        oMonster = CreateObject(OBJECT_TYPE_CREATURE, sResref, GetLocation(oWaypoint), FALSE, "Delete");
        SetLocalInt(oMonster, "PL_AI_SPAWNED", TRUE);
        SetLocalInt(oMonster, "Despawn", TRUE);
        i++;
        oWaypoint = GetWaypointByTag(sWaypoint + IntToString(i));
    }

    SetLocalInt(OBJECT_SELF, "GongCount", nGongCount);

    if(nGongCount == 3)
        DelayCommand(1800.0f, DeleteLocalInt(OBJECT_SELF, "GongCount"));

    DelayCommand(10.0f, DeleteLocalInt(OBJECT_SELF, "Spawning"));
}
