//::///////////////////////////////////////////////
//:: Fireworks Start Program
//:: g_startfireworks.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Put this script on the OnUsed event for a placeable.
This script creates all the targets needed for the show. It will then start the
show.

For your area pick some execiting battle music it will play with the show.

Only thing you need to edit if you wish is the height of the explosions.
If its on flat land I suggest 7.5 if you build raised areas for people to watch
from I suggest 10.0 or higher but I wouldn't go over 20.0 or some weird timing
effects come in.
*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    //Edit Settings here ///////////////////////////////////////////////////////
    float z = 7.5;       //How High the fireworks go before exploding
    //DO NOT EDIT BELOW THIS LINE //////////////////////////////////////////////
    object oArea = GetArea(OBJECT_SELF);
    object oTarget = OBJECT_SELF;
    {
        //No Firework show in progress.
        //Tell the system that a show is in progress.
        SetLocalInt(oArea,"FIREWORKSHOW",TRUE);
        float x,y,tx,ty;
        float fAngle = 30.0;
        int nCount;
        vector nTarget = GetPosition(oTarget);
        vector nCreate;
        string sTag;
        tx = nTarget.x;
        ty = nTarget.y;

        //12 small targets in a clock pattern
        for(nCount = 1;nCount < 13;nCount++)
        {
            x = tx + (cos(fAngle)*10);
            y = ty + (sin(fAngle)*10);
            sTag = "FireworksSTarget" + IntToString(nCount);
            CreateObject(OBJECT_TYPE_PLACEABLE,"fireworksstarget",Location(oArea,Vector(x,y,z),0.0),FALSE,sTag);
            fAngle += 30.0;
        }

        x = tx;
        y = ty;
        //3 Medium and Large targets same x,y different z
        for (nCount = 1;nCount < 4;nCount++)
        {
            sTag = "FireworksMTarget" + IntToString(nCount);
            CreateObject(OBJECT_TYPE_PLACEABLE,"fireworksmtarget",Location(oArea,Vector(x,y,z),0.0),FALSE,sTag);
            sTag = "FireworksLTarget" + IntToString(nCount);
            CreateObject(OBJECT_TYPE_PLACEABLE,"fireworksltarget",Location(oArea,Vector(x,y,z),0.0),FALSE,sTag);
            z += 1.5;
        }

        //Start the SHOW!
        DelayCommand(3.0,ExecuteScript("g_lightsout",oTarget));
        DelayCommand(4.0,MusicBattlePlay(oArea));
        DelayCommand(4.0,ExecuteScript("g_fireworks",oTarget));
    }
}
