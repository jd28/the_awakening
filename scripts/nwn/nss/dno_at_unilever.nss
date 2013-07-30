///////////////////////////////////
//: dno_at_unilever
//: Universal Placed Lever Activation.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;

DelayCommand(0.5,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

    string sDoor = "_DR";
    string sSelf = GetTag(OBJECT_SELF);

    object oTarget = GetObjectByTag( sSelf + sDoor );

SetLocked(oTarget, FALSE);

DelayCommand(2.0,AssignCommand(oTarget, ActionOpenDoor(oTarget)));

DelayCommand(12.0, AssignCommand(oTarget, ActionCloseDoor(oTarget)));

DelayCommand(12.0, AssignCommand(oTarget, SetLocked(oTarget, TRUE)));

DelayCommand(12.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
}
