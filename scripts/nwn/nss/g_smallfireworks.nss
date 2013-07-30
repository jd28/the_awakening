//::///////////////////////////////////////////////
//:: Small Fireworks Explosion
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
    float fFire = 0.5;
    int nNum;
    //Check to see if another script set the explosion for us
    if (GetLocalInt(oSource,"SmallFireWorks") == 0)
    {
        //No script did pick one at random
        nNum = Random(21)+1;
    }
    else
    {
        //Another script did get the explosion type.
        nNum = GetLocalInt(oSource,"SmallFireWorks");
    }

    //Get and fire the effect picked
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
            eExtra = EffectVisualEffect(VFX_FNF_HOWL_MIND);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 4:
        {
            eExtra = EffectVisualEffect(VFX_FNF_SOUND_BURST);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 5:
        {
            eExtra = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 6:
        {
            eExtra = EffectVisualEffect(13);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 7:
        {
            eExtra = EffectVisualEffect(18);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 8:
        {
            eExtra = EffectVisualEffect(31);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 9:
        {
            eExtra = EffectVisualEffect(69);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 10:
        {
            eExtra = EffectVisualEffect(149);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 11:
        {
            eExtra = EffectVisualEffect(190);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 12:
        {
            eExtra = EffectVisualEffect(218);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 13:
        {
            eExtra = EffectVisualEffect(279);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 14:
        {
            eExtra = EffectVisualEffect(463);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 15:
        {
            eExtra = EffectVisualEffect(315);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 16:
        {
            eExtra = EffectVisualEffect(140);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 17:
        {
            eExtra = EffectVisualEffect(187);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 18:
        {
            eExtra = EffectVisualEffect(217);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 19:
        {
            eExtra = EffectVisualEffect(407);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 20:
        {
            eExtra = EffectVisualEffect(82);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        case 21:
        {
            eExtra = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
        default :
        {
            eExtra = EffectVisualEffect(VFX_FNF_HOWL_MIND);
            DelayCommand(fFire,ApplyEffectToObject(DURATION_TYPE_INSTANT,eExtra,oTarget));
            break;
        }
    }
    //Are we to call for another firework?
    if (GetLocalInt(oSource,"NEWFIREWORK") == TRUE)
    {
        //Yes then call it
        DelayCommand(6.0,ExecuteScript("g_fireworks",oSource));
    }
}
