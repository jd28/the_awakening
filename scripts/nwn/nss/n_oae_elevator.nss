//::///////////////////////////////////////////////
//:: Name n_oae_elevator
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Mostly made by Bioware
*/
//:://////////////////////////////////////////////
//:: Modified By: nereng
//:: Modified On: 12.11.04
//:://////////////////////////////////////////////

void main()
{
    object oControl = GetObjectByTag("CONTROL");

    if(GetLocalInt(OBJECT_SELF, "DoOnce") != 10) //init numbers
    {
       // destroying any existing vertices:
       int i;
       string sTag1, sTag2;
       object oV1, oV2;
       for(i = 1; i <= 6; i++)
       {
           sTag1 = "q4b_vertex_a" + IntToString(i);
           sTag2 = "q4b_vertex_b" + IntToString(i);
           oV1 = GetObjectByTag(sTag1);
           oV2 = GetObjectByTag(sTag2);
           DestroyObject(oV1);
           DestroyObject(oV2);
       }
       // Setting number beams
       object oWPa1 = GetObjectByTag("q4b_wp_number_a1");
       object oWPa2 = GetObjectByTag("q4b_wp_number_a2");

       vector vPosA1 = GetPosition(oWPa1);
       vector vPosA3 = GetPosition(oWPa1);
       vector vPosA5 = GetPosition(oWPa1);
       vPosA1.z += 1.5;
       vPosA3.z += 2.5;
       vPosA5.z += 3.5;

       vector vPosA2 = GetPosition(oWPa2);
       vector vPosA4 = GetPosition(oWPa2);
       vector vPosA6 = GetPosition(oWPa2);
       vPosA2.z += 1.5;
       vPosA4.z += 2.5;
       vPosA6.z += 3.5;

       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA1, 0.0), FALSE, "q4b_vertex_a1");
       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA2, 0.0), FALSE, "q4b_vertex_a2");
       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA3, 0.0), FALSE, "q4b_vertex_a3");
       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA4, 0.0), FALSE, "q4b_vertex_a4");
       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA5, 0.0), FALSE, "q4b_vertex_a5");
       CreateObject(OBJECT_TYPE_PLACEABLE, "q4b_vertex", Location(OBJECT_SELF, vPosA6, 0.0), FALSE, "q4b_vertex_a6");

       SetLocalInt(OBJECT_SELF, "DoOnce", 10);

       ExecuteScript("n_display", oControl);
    }
    SetLocalInt(oControl, "RunHB",1);
}
