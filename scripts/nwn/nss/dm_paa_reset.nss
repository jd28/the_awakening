#include "dm_paa_include"

void main()
{
   object oTarget = GetLocalObject(OBJECT_SELF, "DM_PAA_oTarget");
   location lOriginal = GetLocalLocation(oTarget, "DM_PAA_lOriginal");

   RecreateObjectAtLocation(oTarget, lOriginal);
}
