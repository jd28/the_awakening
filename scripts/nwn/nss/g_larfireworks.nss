//::///////////////////////////////////////////////
//:: Large Fireworks Explosion
//:: g_smallfireworks
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

This is the OnDamaged Event for the firework targets. Do not Edit unless you know
what you are doing.

*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    object oSource = GetObjectByTag("FireworksSource");
    object oTarget = OBJECT_SELF;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eExplode,oTarget);
    effect eExtra;
    int i;
    int SmallTarget;
    string sTag;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eDam = EffectDamage(1);
    int nMissiles = 1;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    fTime = fDelay+1.0;
    float fFire = 0.5;

    SetLocalInt(oSource,"NewMedFire",FALSE);
    SetLocalInt(oSource,"NEWFIREWORK",FALSE);
    //Get Random small firework targets and fire a Magic Missile at it
    //No more than 12 smaller target at least 6.
    //Get 1 random medium and fire at it.

    int nNumSmall = Random(2)+1;

    for(i=1;i<13;i=i+nNumSmall)
    {
        sTag = "FireworksSTarget" + IntToString(i);
        oTarget = GetObjectByTag(sTag);
        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(0.1,ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
        SetLocalInt(oSource,"SmallFireWorks",Random(20)+1);
    }

    nNumSmall = Random(3)+1;
    sTag = "FireworksMTarget" + IntToString(nNumSmall);
    oTarget = GetObjectByTag(sTag);
    DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

    oTarget = OBJECT_SELF;

    int nNum = Random(19)+1;

    switch(nNum)
    {
        case 1:
        {
            eExtra = EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 2:
        {
            eExtra = EffectVisualEffect(VFX_FNF_DISPEL);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 3:
        {
            eExtra = EffectVisualEffect(VFX_FNF_FIRESTORM);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 4:
        {
            eExtra = EffectVisualEffect(VFX_FNF_HOWL_MIND);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 5:
        {
            eExtra = EffectVisualEffect(VFX_FNF_SOUND_BURST);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 6:
        {
            eExtra = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }

        case 7:
        {
            eExtra = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 8:
        {
            eExtra = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 9:
        {
            eExtra = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 10:
        {
            eExtra = EffectVisualEffect(VFX_FNF_SUNBEAM);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 11:
        {
            eExtra = EffectVisualEffect(223);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 12:
        {
            eExtra = EffectVisualEffect(231);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 13:
        {
            eExtra = EffectVisualEffect(254);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 14:
        {
            eExtra = EffectVisualEffect(29);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 15:
        {
            eExtra = EffectVisualEffect(497);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 16:
        {
            eExtra = EffectVisualEffect(487);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 17:
        {
            eExtra = EffectVisualEffect(477);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 18:
        {
            eExtra = EffectVisualEffect(464);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 19:
        {
            eExtra = EffectVisualEffect(467);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        default :
        {
            break;
        }
    }
    if (GetLocalInt(oSource,"NOSPAWN") == FALSE)
    {
        DelayCommand(12.0,ExecuteScript("g_fireworks",oSource));
    }
}
