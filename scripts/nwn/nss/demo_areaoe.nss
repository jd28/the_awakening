/*
This script handles the OnEnter event for the areas
*/
#include "inc_draw"

int gao_RandomAppearance()
{
   int j = d12();
   int i = (j==1) ? 472 : (j==2) ? 421 : (j==3) ? 420 : (j==4) ? 392 :
           (j==5) ? 38 : (j==6) ? 168 : (j==7) ? 92 : (j==8) ? 91 :
           (j==9) ? 90 : (j==10) ? 89 : (j==11) ? 72 : 57 ;
   return i;
}

void main()
{
   object oPC = GetEnteringObject();
   if (!GetIsPC(oPC)) return;

   if (!GetLocalInt(OBJECT_SELF, "explore")) // on first visit, explore area
   {
      ExploreAreaForPlayer(OBJECT_SELF, oPC);
      SetLocalInt(OBJECT_SELF, "explore", TRUE);
   }

   object oMod = GetModule();
   object oTextRing1 = GetLocalObject(oMod, "textring1");
   if (oTextRing1 != OBJECT_INVALID)
   {
      GroupDestroyObject(oTextRing1);
      DeleteLocalObject(oMod, "textring1");
   }
   object oTextRing2 = GetLocalObject(oMod, "textring2");
   if (oTextRing2 != OBJECT_INVALID)
   {
      GroupDestroyObject(oTextRing2);
      DeleteLocalObject(oMod, "textring2");
   }

   int i;
   float f;
   vector vLoc;
   location lLoc;
   vector vPos = GetPosition(oPC);
   location lPos = GetLocation(oPC);
   string sTag = GetTag(OBJECT_SELF);

   if (sTag == "CIRQUE")
   {
      for (i=0; i<6; i++)
      {
         f = IntToFloat(i);
         DelayCommand(f*2.0, DrawLineFromCenter(DURATION_TYPE_INSTANT, VFX_FNF_SMOKE_PUFF, lPos, 20.0, 45.0, 0.0, 20));
      }
   }
   else if (sTag == "ISOTOPIA")
   {
      BeamStellaOctangula(2, VFX_BEAM_SILENT_COLD, lPos, 1.0, 0.0, "", 0.0, 1.0);
      SetLocalString(oPC, "junk", "INVISOBJ");
   }
   else if (sTag == "CONFETTI")
   {
      if (GetLocalInt(OBJECT_SELF, "doonce")) return;
      SetLocalInt(OBJECT_SELF, "doonce", TRUE);
      effect eVis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
      object oLever = GetFirstObjectInArea(OBJECT_SELF);
      string sTag;
      while (oLever != OBJECT_INVALID)
      {
         sTag = GetStringRight(GetTag(oLever), 4);
         if (!GetIsEffectValid(GetFirstEffect(oLever)))
         {
            if (sTag == "EVER") ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oLever);
            else if (sTag == "DRAW") ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PARALYZED), oLever);
         }
         oLever = GetNextObjectInArea(OBJECT_SELF);
      }
   }
   else if (sTag == "pl_wiztow_005")
   {
      BlackScreen(oPC);
      DelayCommand(3.0, FadeFromBlack(oPC, FADE_SPEED_SLOWEST));

      object oCage = GetFirstObjectInArea(OBJECT_SELF);
      while (oCage != OBJECT_INVALID)
      {
         sTag = GetTag(oCage);
         if (sTag == "PSC_B_ICOSAHEDRON" || sTag == "PSC_B_DODECAHEDRON" || sTag == "PSC_B_TRIACONTAHEDRON" || sTag == "PSC_X_TEXTMESSAGE") GroupDestroyObject(oCage);
         else if (sTag == "GOLEM") SetCreatureAppearanceType(oCage, gao_RandomAppearance());
         oCage = GetNextObjectInArea(OBJECT_SELF);
      }

      lLoc = Location(OBJECT_SELF, Vector(15.0, 15.0, -1.5), 0.0);
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

      if (GetLocalInt(OBJECT_SELF, "doonce")) return;
      SetLocalInt(OBJECT_SELF, "doonce", TRUE);
      NightToDay(oPC);
      SetFogAmount(FOG_TYPE_SUN, 0, OBJECT_SELF);
      MusicBackgroundChangeDay(OBJECT_SELF, 4);
      for (i=0; i<8; i++)
      {
         f = IntToFloat(i);
         lLoc = Location(OBJECT_SELF, Vector(5.0, 5.0, 0.105) + Vector(0.0, f*10.0), 0.0);
         DelayCommand(0.1, PlaceLineFromCenter("invisobj2", lLoc, 80.0, 0.0, 8, 2.0, "z", 2, 402));
      }
   }
   else if (sTag == "OBLONGATA")
   {
      PlacePolygonalSpring("plc_flamesmall", lPos, 5.0, 5.0, 0.0, 20.0, 6, 360, 10.0, 6.0, 180.0, "x", -1, -1, 0.0, 1.0, 12.0);
      SetLocalString(oPC, "junk", "FlameSmall");
   }
   else if (sTag == "GLOBALVILLAGE")
   {
      SetCameraFacing(195.0, 6.0, 80.0);
      for (i=0; i<7; i++)
      {
         f = IntToFloat(i);
         vLoc = vPos - Vector(f*5.0);
         lLoc = Location(OBJECT_SELF, vLoc, 0.0);
         DelayCommand(f*0.5, DrawSphere(0, 46, lLoc, 3.0, 0.0, 60, 10.0, 2.0));
      }
   }
   else if (sTag == "CONSTELLATE")
   {
      DrawPentacle(0, 239, lPos, 5.0, 0.0, 120, 2.0, 4.0);
   }
   else if (sTag == "TORI")
   {
      DrawToroidalSpring(0, 48, lPos, 6.0, 4.0, 6.0, 4.0, -5.0, -25.0, 0.0, 420, 36.0, 1.0, 8.0, -45.0, "y");
   }
   else if (sTag == "ELYSIUM")
   {
      lLoc = Location(OBJECT_SELF, Vector(40.0, 37.5, 1.0), 0.0);
      DrawEllipse(0, VFX_IMP_HEAD_SONIC, lLoc, 20.0, 5.0, 0.0, 360, 2.0, 9.0, 240.0);
   }
   else if (sTag == "SPINOFF")
   {
      DrawHypocycloidSpring(0, 98, lPos, 7.0, -4.0, -16.0, 1.4, 0.0, 240, 6.0, 12.0, 0.0, "x");
   }
   else if (sTag == "SINUS")
   {
      for (i=0; i<5; i++)
      {
         f = IntToFloat(i);
         vLoc = vPos + Vector(f*1.0 - 2.0);
         lLoc = Location(OBJECT_SELF, vLoc, 0.0);
         PlaceSinusoid("plc_flamesmall", lLoc, 0.5, 16.0, 90.0, 40, 2.0, 4.0, 0.0, "z", -1, -1, 0.0, 1.0, 6.0);
      }
   }
}
