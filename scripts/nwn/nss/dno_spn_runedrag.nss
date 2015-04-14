void ActionCreate(string sCreature, location lLoc)
{
  CreateObject(OBJECT_TYPE_CREATURE, sCreature, lLoc);
}

#include "mod_funcs_inc"

void main()
{

  object oStatue;
  object oTarget;
  object oSpawn;
  object oSelf;
  location lTarget;

  oStatue = GetObjectByTag("dno_Rune_Statue");
  oSelf = (OBJECT_SELF);
  oTarget = GetWaypointByTag("dno_WP_Rune_Drag");

  lTarget = GetLocation(oTarget);

  string sCreature = "dno_rune_drag_1";
  location lLoc = lTarget;

  SetLocked(oSelf, TRUE);
  DestroyObject(oStatue);

  DelayCommand(0.5, ActionCreate(sCreature, lLoc));

  DelayCommand(2.0, DestroyObject(oSelf));
}
