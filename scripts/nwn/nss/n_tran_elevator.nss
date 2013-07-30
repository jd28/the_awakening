
void main()
{
    string sDest = GetLocalString(OBJECT_SELF, "DEST");
    object oWaypoint = GetWaypointByTag("n_WP_floor" + sDest);
    object oClicker = GetClickingObject();
    object oControl = GetNearestObjectByTag("CONTROL");

    //SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

    AssignCommand(oClicker,JumpToObject(oWaypoint));

    DelayCommand(1.0, ExecuteScript("n_check_area", oControl));
}
