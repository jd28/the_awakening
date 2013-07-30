//::///////////////////////////////////////////////
//:: Fireworks Finale
//:: g_fireworksfinal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

This is called by g_fireworks after so many fireworks have been shot. This is a
heavily scripted event. If you don't know what to do don't mess with it.

If you do edit it make sure you always use DelayCommand with the varible
"fTimeDelay" Make sure you increase "fTimeDelay" or everything will happen at
the same time.

*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    object oSource = GetObjectByTag("FireworksSource");
    object oArea = GetArea(oSource);
    object oTarget;
    string sTag;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eDam = EffectDamage(1);
    effect eFire = EffectVisualEffect(VFX_COM_HIT_FIRE);

    //Single Targets to use later On!
    //These can be used by you to make other patterns for the finale
    object oSTarget1 = GetObjectByTag("FireworksSTarget1");
    object oSTarget2 = GetObjectByTag("FireworksSTarget2");
    object oSTarget3 = GetObjectByTag("FireworksSTarget3");
    object oSTarget4 = GetObjectByTag("FireworksSTarget4");
    object oSTarget5 = GetObjectByTag("FireworksSTarget5");
    object oSTarget6 = GetObjectByTag("FireworksSTarget6");
    object oSTarget7 = GetObjectByTag("FireworksSTarget7");
    object oSTarget8 = GetObjectByTag("FireworksSTarget8");
    object oSTarget9 = GetObjectByTag("FireworksSTarget9");
    object oSTarget10 = GetObjectByTag("FireworksSTarget10");
    object oSTarget11 = GetObjectByTag("FireworksSTarget11");
    object oSTarget12 = GetObjectByTag("FireworksSTarget12");
    object oMTarget = GetObjectByTag("FireworksMTarget3");
    object oMTarget1 = GetObjectByTag("FireworksMTarget1");
    object oMTarget2 = GetObjectByTag("FireworksMTarget2");
    object oLTarget = GetObjectByTag("FireworksLTarget3");
    object oLTarget1 = GetObjectByTag("FireworksLTarget1");
    object oLTarget2 = GetObjectByTag("FireworksLTarget2");

    int EffectNum;
    int EffectNum1;

    int i;

    float fTimeDelay = 1.0;
    float fDist, fDelay;
    SetLocalInt(oSource,"NewMedFire",FALSE);
    SetLocalInt(oSource,"NEWFIREWORK",FALSE);
    SetLocalInt(oSource,"NOSPAWN",TRUE);

    //Counter Clockwise with Howl
    DelayCommand(fTimeDelay,SetLocalInt(oSource,"SmallFireWorks",3));; //Howl Circle
    for(i=1;i<13;i++)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;
    }
    fTimeDelay += 3.0;

    //Clockwise with dispel
    DelayCommand(fTimeDelay,SetLocalInt(oSource,"SmallFireWorks",2)); //Dispel
    for(i=12;i>0;i--)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;
    }
    fTimeDelay += 3.0;

    //Order fire with Electric Burst
    DelayCommand(fTimeDelay,SetLocalInt(oSource,"SmallFireWorks",9));
    for(i=1;i<7;i++)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;

        sTag = "FireworksSTarget" + IntToString(i+6);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;
    }

    for(i=7;i<13;i++)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;
        sTag = "FireworksSTarget" + IntToString(i-6);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        fTimeDelay += 0.5;
        fDelay += fTimeDelay;
    }
    fTimeDelay += 3.0;

    //Fire Medium Firework off followed by a Large shortly after
    fDist = GetDistanceBetween(oSource, oMTarget);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oMTarget));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oMTarget));
    fTimeDelay += 3.0;
    fDist = GetDistanceBetween(oSource, oLTarget);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oLTarget));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oLTarget));


    //Odd smalls go off with unused effects
    fTimeDelay += 10.0;
    EffectNum = 13;
    fDist = GetDistanceBetween(oSource, oSTarget1);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget1));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget1));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget1));
    fDist = GetDistanceBetween(oSource, oSTarget3);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget3));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget3));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget3));
    fDist = GetDistanceBetween(oSource, oSTarget5);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget5));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget5));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget5));
    fDist = GetDistanceBetween(oSource, oSTarget7);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget7));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget7));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget7));
    fDist = GetDistanceBetween(oSource, oSTarget9);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget9));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget9));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget9));
    fDist = GetDistanceBetween(oSource, oSTarget11);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget11));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget11));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum),oSTarget11));


    //Even Small go off now
    fTimeDelay += 2.0;
    EffectNum1 = 13;
    fDist = GetDistanceBetween(oSource, oSTarget2);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget2));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget2));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget2));
    fDist = GetDistanceBetween(oSource, oSTarget4);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget4));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget4));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget4));
    fDist = GetDistanceBetween(oSource, oSTarget6);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget6));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget6));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget6));
    fDist = GetDistanceBetween(oSource, oSTarget8);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget8));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget8));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget8));
    fDist = GetDistanceBetween(oSource, oSTarget10);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget10));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget10));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget10));
    fDist = GetDistanceBetween(oSource, oSTarget12);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oSTarget12));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oSTarget12));
    DelayCommand(fDelay+0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(EffectNum1),oSTarget12));

    //Put some Rapid shot Random Mediums here
    for(i=1;i<11;i++)
    {
        fDist = GetDistanceBetween(oSource, oMTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oMTarget));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oMTarget));
        fTimeDelay += 2.5;
    }



    //GRAND ENDING!
    fTimeDelay += 6.0;
    //Grand Ending here Weird without darkness with a dragon flight to a big explosion.
    fDist = GetDistanceBetween(oSource, oLTarget);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oLTarget));
    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_FIREBALL),oLTarget));

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(323), oLTarget));
    fTimeDelay = fDelay + 1.0;
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(488), oLTarget));
    fTimeDelay += 5.0;
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(464), oLTarget));
    fTimeDelay += 4.0;
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(477), oLTarget));
    for(i=1;i<13;i++)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        fDist = GetDistanceBetween(oSource, oTarget);
        fDelay = fDist/(3.0 * log(fDist) + 2.0);
        fDelay += fTimeDelay;
        DelayCommand(fTimeDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oSource));
        DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(193), oTarget));
        DelayCommand(fDelay+0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(407), oTarget));
        DelayCommand(fDelay+1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(459), oTarget));
    }
    fTimeDelay += 5.0;
    //Stop the Music
    DelayCommand(fTimeDelay,MusicBattleStop(oArea));
    //Turn TileLights back on
    DelayCommand(fTimeDelay,ExecuteScript("g_lightson",oTarget));
    //Clean up all the targets
    fTimeDelay += 5.0;
    DestroyObject(oSTarget1,fTimeDelay);
    DestroyObject(oSTarget2,fTimeDelay);
    DestroyObject(oSTarget3,fTimeDelay);
    DestroyObject(oSTarget4,fTimeDelay);
    DestroyObject(oSTarget5,fTimeDelay);
    DestroyObject(oSTarget6,fTimeDelay);
    DestroyObject(oSTarget7,fTimeDelay);
    DestroyObject(oSTarget8,fTimeDelay);
    DestroyObject(oSTarget9,fTimeDelay);
    DestroyObject(oSTarget10,fTimeDelay);
    DestroyObject(oSTarget11,fTimeDelay);
    DestroyObject(oSTarget1,fTimeDelay);
    DestroyObject(oMTarget,fTimeDelay);
    DestroyObject(oMTarget2,fTimeDelay);
    DestroyObject(oMTarget,fTimeDelay);
    DestroyObject(oLTarget1,fTimeDelay);
    DestroyObject(oLTarget,fTimeDelay);
    DestroyObject(oLTarget,fTimeDelay);
    //Allow for another show to start
    DelayCommand(fTimeDelay,SetLocalInt(oArea,"FIREWORKSHOW",FALSE));
}
