///////////////////////////////////////////////////////////////////////////////
// file: con_jump
// script type: Action Taken
// description:
//
// variables:
//      Name            Type        Description
//      ----            ----        -----------
///////////////////////////////////////////////////////////////////////////////

#include "mod_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oPorter = GetLocalObject(oPC, "PL_CONV_WITH");
    DeleteLocalObject(oPC, "PL_CONV_WITH");
    string sWaypoint = "wp_" + GetTag(oPorter);
    object oDestination = GetObjectByTag(sWaypoint);
    location lDestination = GetLocation(oDestination);

    float fFacing = GetFacing(oDestination);
    effect eFly = EffectDisappearAppear(lDestination);

    Logger(oPC, "DebugCon", LOGLEVEL_NONE, "Script: con_jump, Tag: %s, Waypoint: %s, Facing: %s",
           GetTag(OBJECT_SELF), sWaypoint, FloatToString(fFacing));

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, SetFacing(fFacing));
    // Duration MUST be 3.0 or higher. Higher for busy areas.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFly, oPC, 4.0);
}
