//::///////////////////////////////////////////////
//:: Lights Out
//:: g_lightsout.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Will turn all the Tilelights in the current area to black. Save the light
settings so they can be turned back on later.

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
    for(x=0;x<32;x++)
    {
        for(y=0;y<32;y++)
        {
            vLoc = Vector(IntToFloat(x),IntToFloat(y),0.0);
            lLoc = Location(oArea,vLoc,0.0);
                //Save Color first for all lights
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".1";
                SetLocalInt(oArea,sLight,GetTileMainLight1Color(lLoc));
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".2";
                SetLocalInt(oArea,sLight,GetTileMainLight2Color(lLoc));
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".3";
                SetLocalInt(oArea,sLight,GetTileSourceLight1Color(lLoc));
                sLight = "LIGHT" + IntToString(x) + "." + IntToString(y) + ".4";
                SetLocalInt(oArea,sLight,GetTileSourceLight2Color(lLoc));
                SetTileMainLightColor(lLoc,TILE_MAIN_LIGHT_COLOR_BLACK,TILE_MAIN_LIGHT_COLOR_BLACK);
                SetTileSourceLightColor(lLoc,TILE_MAIN_LIGHT_COLOR_BLACK,TILE_MAIN_LIGHT_COLOR_BLACK);
        }
    }
    RecomputeStaticLighting(oArea);
}
