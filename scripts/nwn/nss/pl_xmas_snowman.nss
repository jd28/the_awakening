void main () {
    int is_spawned = GetLocalInt(OBJECT_SELF, "SnowManSpawned");
    if(is_spawned) return;

    SetLocalInt(OBJECT_SELF, "SnowManSpawned", TRUE);
    object way = GetWaypointByTag("wp_xmas_real_" + IntToString(d3()));

    CreateObject(OBJECT_TYPE_PLACEABLE, "pl_snowman_fk001", GetLocation(way));
}
