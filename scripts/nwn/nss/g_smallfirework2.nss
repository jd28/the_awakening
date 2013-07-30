//::///////////////////////////////////////////////
//:: Firework Wand Explosion
//:: g_smallfirework2.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This is the OnDamage Event for the firework wand. You can edit the effect below.


And items that will shoot a firework in the sky above the PCs head and do a small
firework. Give it to you players for some fun.
*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eExplode,oTarget);
    effect eExtra;
    float fFire = 0.5;
    int nNum;
    nNum = Random(21)+1;

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
}
