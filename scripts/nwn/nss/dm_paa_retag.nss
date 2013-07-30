void main()
{
   // Retrieve variables from user, set up working variables
   object oTarget = GetLocalObject(OBJECT_SELF, "DM_PAA_oTarget");
   string sResRef = GetLocalString(OBJECT_SELF, "DM_PAA_sResRef");
   int iPlot = GetPlotFlag(oTarget);
   int iUseable = GetUseableFlag(oTarget);
   string sNewName = GetName(oTarget);
   string sNewTag = GetName(oTarget);
   string sNameTag = GetLocalString(oTarget, "sNameTag");
   string sDesc = GetDescription(oTarget);
   int iOriginal = GetLocalInt(oTarget, "DM_PAA_iOriginal");
   location lOriginal = GetLocalLocation(oTarget, "DM_PAA_lOriginal");

   location lTargetLocation = GetLocation(oTarget);

   // Destroy existing placeable, create new placeable, update variables
   DestroyObject(oTarget);
   oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lTargetLocation, FALSE, sNewTag);

   if(oTarget == OBJECT_INVALID)
   { SendMessageToPC(OBJECT_SELF, "ERROR: Invalid tag.");
     oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lTargetLocation, FALSE); }
   else
   { SetLocalInt(oTarget, "iRetagged", TRUE); }

   SetPlotFlag(oTarget, iPlot);
   SetUseableFlag(oTarget, iUseable);
   SetLocalString(oTarget, "sNameTag", sNameTag);
   SetName(oTarget, sNewName);
   if (GetDescription(oTarget) != sDesc)
   { SetDescription(oTarget, sDesc); }
   SetLocalObject(OBJECT_SELF, "DM_PAA_oTarget", oTarget);
   SetLocalInt(oTarget, "DM_PAA_iOriginal", iOriginal);
   SetLocalLocation(oTarget, "DM_PAA_lOriginal", lOriginal);

}
