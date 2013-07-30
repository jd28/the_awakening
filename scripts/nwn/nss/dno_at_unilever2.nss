///////////////////////////////////
//: dno_at_unilever2
//: Universal Placed Lever Activation.
//: Must be Attacked to Activate.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

    object oPC = GetLastAttacker();
    if (!GetIsPC(oPC)) return;

DelayCommand(3.0,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

    string sDoor = "_DR";
    string sSelf = GetTag(OBJECT_SELF);

    object oTarget = GetObjectByTag( sSelf + sDoor );

SetLocked(oTarget, FALSE);

DelayCommand(4.0,AssignCommand(oTarget, ActionOpenDoor(oTarget)));

DelayCommand(30.0, AssignCommand(oTarget, ActionCloseDoor(oTarget)));

DelayCommand(30.0, AssignCommand(oTarget, SetLocked(oTarget, TRUE)));

DelayCommand(30.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
}
