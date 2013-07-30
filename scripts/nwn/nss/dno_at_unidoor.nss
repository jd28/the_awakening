///////////////////////////////////
//: dno_at_unidoor
//: Universal Placed Door Transition.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;

        ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);

string sSelf = GetTag(OBJECT_SELF);
string sDest = "DST_";

    object oTarget;
    location lTarget;
        oTarget = GetWaypointByTag( sDest + sSelf );
        lTarget = GetLocation(oTarget);

    if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

DelayCommand(2.0, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));

}
