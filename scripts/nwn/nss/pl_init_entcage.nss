#include "inc_draw2"

void main(){
/*
      object oCage = GetFirstObjectInArea(OBJECT_SELF);
      while (oCage != OBJECT_INVALID)
      {
         sTag = GetTag(oCage);
         if (sTag == "PSC_B_ICOSAHEDRON" || sTag == "PSC_B_DODECAHEDRON" || sTag == "PSC_B_TRIACONTAHEDRON" || sTag == "PSC_X_TEXTMESSAGE") GroupDestroyObject(oCage);
         else if (sTag == "GOLEM") SetCreatureAppearanceType(oCage, gao_RandomAppearance());
         oCage = GetNextObjectInArea(OBJECT_SELF);
      }
*/
      location lLoc = Location(OBJECT_SELF, Vector(15.0, 15.0, -1.5), 0.0);
      if (GetLocalInt(OBJECT_SELF, "golemcage"))
      {
         DelayCommand(0.1, BeamIcosahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamIcosahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DeleteLocalInt(OBJECT_SELF, "golemcage");
      }
      else
      {
         DelayCommand(0.1, BeamDodecahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamDodecahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         DelayCommand(0.1, BeamTriacontahedron(2, VFX_BEAM_FIRE_W_SILENT, lLoc, 5.0, 0.0, "", 2.0));
         SetLocalInt(OBJECT_SELF, "golemcage", TRUE);
      }
}
