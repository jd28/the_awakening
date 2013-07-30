//::///////////////////////////////////////////////
//:: Firework Wand
//:: g_missile.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This script is called from g_firework_wand script. This does all the hard work.
It needs to be called like this for timing reasons.

And items that will shoot a firework in the sky above the PCs head and do a small
firework. Give it to you players for some fun.
*/
//:://////////////////////////////////////////////
//:: Created By: Jay Clark
//:: Created On: August 31, 2004
//:://////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    object oArea = GetArea(oPC);
    location lNewLoc;
    vector vPC,vNewVec;
    float x,y,z,face;
    //Make SmallFireTarget over PCs head
    vPC = GetPosition(oPC);
    x = vPC.x;
    y = vPC.y;
    z = vPC.z;
    z += 7.5;
    face = GetFacing(oPC);
    vNewVec = Vector(x,y,z);
    lNewLoc = Location(oArea,vNewVec,face);
    object oTarget = CreateObject(OBJECT_TYPE_PLACEABLE,"wandfireworktarg",lNewLoc);
    effect eMissile = EffectVisualEffect(181); //233 is Fire Arrow
    effect eDam = EffectDamage(1);
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    float fDist, fDelay, fTimeDelay;
    fTimeDelay = 0.0;
    fDist = GetDistanceBetween(oPC, oTarget);
    fDelay = fDist/(3.0 * log(fDist) + 2.0);
    fDelay += fTimeDelay;
    DelayCommand(fTimeDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget));
    DestroyObject(oTarget,fDelay+2.0);
}
