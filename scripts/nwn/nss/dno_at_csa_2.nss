void main(){
    object oCapt = OBJECT_SELF;//GetObjectByTag("dno_Elf_Cpt_2");
    if(GetLocalInt(oCapt, "dno_attacked") == 2)
        return;

    object oWP1 = GetWaypointByTag("dno_WP_CSA_1");
    object oWP2 = GetWaypointByTag("dno_WP_CSA_2");
    object oWP3 = GetWaypointByTag("dno_WP_CSA_3");
    object oWP4 = GetWaypointByTag("dno_WP_CSA_4");

    location lWP1 = GetLocation(oWP1);
    location lWP2 = GetLocation(oWP2);
    location lWP3 = GetLocation(oWP3);
    location lWP4 = GetLocation(oWP4);

    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_fly", lWP1);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_bard", lWP2);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_fly", lWP3);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_bard", lWP4);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_fly", lWP2);
    CreateObject(OBJECT_TYPE_CREATURE, "dno_sf_dis_fly", lWP4);

    SetLocalInt(oCapt, "dno_attacked", 2);
}
