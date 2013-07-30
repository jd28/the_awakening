///////////////////////////////////
//: dno_at_lever_03b
//: Unlock & Open Door, then Close after delay.
//: 30 secs Delay.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

object oD1 = GetObjectByTag("dno_AT_002_003c");

ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

SetLocked(oD1, FALSE);

AssignCommand(oD1, ActionOpenDoor(oD1));

DelayCommand(30.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));

DelayCommand(30.0, AssignCommand(oD1, ActionCloseDoor(oD1)));

DelayCommand(30.0, AssignCommand(oD1, SetLocked(oD1, TRUE)));




}
