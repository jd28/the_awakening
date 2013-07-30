///////////////////////////////////
//: dno_at_lever_00
//: Unlock & Open 5 doors, then Close after delay
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

object oPC = GetLastUsedBy();
if (!GetIsPC(oPC)) return;

object oD1 = GetObjectByTag("dno_FL_DS_01_DR");
object oD2 = GetObjectByTag("dno_FL_DS_02_DR");
object oD3 = GetObjectByTag("dno_FL_DS_03_DR");
object oD4 = GetObjectByTag("dno_FL_DS_04_DR");
object oD5 = GetObjectByTag("dno_FL_DS_05_DR");


ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);

SetLocked(oD1, FALSE);
SetLocked(oD2, FALSE);
SetLocked(oD3, FALSE);
SetLocked(oD4, FALSE);
SetLocked(oD5, FALSE);

AssignCommand(oD1, ActionOpenDoor(oD1));
AssignCommand(oD2, ActionOpenDoor(oD2));
AssignCommand(oD3, ActionOpenDoor(oD3));
AssignCommand(oD4, ActionOpenDoor(oD4));
AssignCommand(oD5, ActionOpenDoor(oD5));

DelayCommand(60.0, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));

DelayCommand(60.0, AssignCommand(oD5, ActionCloseDoor(oD5)));
DelayCommand(48.0, AssignCommand(oD4, ActionCloseDoor(oD4)));
DelayCommand(36.0, AssignCommand(oD3, ActionCloseDoor(oD3)));
DelayCommand(24.0, AssignCommand(oD2, ActionCloseDoor(oD2)));
DelayCommand(12.0, AssignCommand(oD1, ActionCloseDoor(oD1)));

DelayCommand(60.5, AssignCommand(oD5, SetLocked(oD5, TRUE)));
DelayCommand(48.5, AssignCommand(oD4, SetLocked(oD4, TRUE)));
DelayCommand(36.5, AssignCommand(oD3, SetLocked(oD3, TRUE)));
DelayCommand(24.5, AssignCommand(oD2, SetLocked(oD2, TRUE)));
DelayCommand(12.5, AssignCommand(oD1, SetLocked(oD1, TRUE)));
}
