//::///////////////////////////////////////////////
//:: Lights On
//:: g_lightson.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Will turn all the Tilelights in the current area back to their normal color.
Color was saved from the Light Out script.

*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    object oArea = GetArea(OBJECT_SELF);
    int x,y;
    vector vLoc;
    location lLoc;
    string sLight;
    string sLight2;
    for(x=0;x<32;x++)
    {
        for(y=0;y<32;y++)
        {
            vLoc = Vector(IntToFloat(x),IntToFloat(y),0.0);
            lLoc = Location(oArea,vLoc,0.0);
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".1";
                sLight2 = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".2";
                SetTileMainLightColor(lLoc,GetLocalInt(oArea,sLight),GetLocalInt(oArea,sLight2));
                DeleteLocalInt(oArea,sLight);
                DeleteLocalInt(oArea,sLight2);
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".3";
                sLight2 = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".4";
                SetTileSourceLightColor(lLoc,GetLocalInt(oArea,sLight),GetLocalInt(oArea,sLight2));
                DeleteLocalInt(oArea,sLight);
                DeleteLocalInt(oArea,sLight2);
        }
    }
    RecomputeStaticLighting(oArea);
}
