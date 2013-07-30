//::///////////////////////////////////////////////
//:: Firework Show
//:: g_fireworks.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

This script is the heartbeat of the Firework show. Not much you need to do in
this file as it will handle everything on its own.

*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////


void main()
{
    object oTarget;
    object oSource = GetObjectByTag("FireworksSource");
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eDam = EffectDamage(1);
    effect eFire = EffectVisualEffect(VFX_COM_HIT_FIRE);
    int nNum;
    string sTag;
    int TotalCount;
    TotalCount = GetLocalInt(oSource,"FireworkCount");
    TotalCount++;
    SetLocalInt(oSource,"FireworkCount",TotalCount);

    //Make sure the new fireworks will happen which could be turned off in other scripts
    SetLocalInt(oSource,"NEWFIREWORK",TRUE);
    SetLocalInt(oSource,"SmallFireWorks",0);
    SetLocalInt(oSource,"NewMedFire",TRUE);
    SetLocalInt(oSource,"NOSPAWN",FALSE);

    //Roll to see what type of firework we are doing
    int nRoll = Random(100)+1;
    if (nRoll < 40)
    {
        //Small Firework One Target One Effect
        nNum = Random(12)+1;
        sTag = "FireworksSTarget" + IntToString(nNum);
        oTarget = GetObjectByTag(sTag);
    }
    else if (nRoll < 65)
    {
        //Medium Size One Target Many Effects might spawn other Targets
        nNum = Random(3)+1;
        sTag = "FireworksMTarget" + IntToString(nNum);
        oTarget = GetObjectByTag(sTag);
    }
    else if (nRoll < 90)
    {
        //Large One Target Many effect will spawn other targets with many effects
        nNum = Random(3)+1;
        sTag = "FireworksLTarget" + IntToString(nNum);
        oTarget = GetObjectByTag(sTag);
    }
    else
    {
        if (TotalCount > 50)
        {
            //Finale, Prescripted for the most part in g_fireworksfinal
            ExecuteScript("g_fireworksfinal",oSource);
        }
        else
        {
            ExecuteScript("g_fireworks",oSource);
        }
    }

    float fDist = GetDistanceBetween(oSource, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    fTime = fDelay;
    fDelay2 += 0.1;
    fTime += fDelay2;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource);
    DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
}
