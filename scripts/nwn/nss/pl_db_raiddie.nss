//::///////////////////////////////////////////////
//:: Name x2_def_ondeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDeath script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main(){
    ExecuteScript("nw_c2_default7", OBJECT_SELF);

    // Spawn the worg because the goblin has died
    location lLoc= GetLocation(OBJECT_SELF);
    effect eKnockdwn = ExtraordinaryEffect(EffectKnockdown());
    object oSpawn = CreateObject(OBJECT_TYPE_CREATURE,"pl_ww_direwolf",lLoc,FALSE);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdwn, oSpawn, 2.0);
}
