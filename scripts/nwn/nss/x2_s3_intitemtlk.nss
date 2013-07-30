//::///////////////////////////////////////////////
//:: Black Blade of Disaster
//:: X2_S0_BlckBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greatsword to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, July 28 - 2003

#include "gsp_func_inc"

void main(){

    object oPC = OBJECT_SELF;
    object oItem = GetSpellCastItem();

    SetLocalInt(oPC, "CON_ITEM", TRUE);
    SetLocalObject(oPC, "ITEM_TALK_TO", oItem);
    AssignCommand(oPC, ActionStartConversation(oPC, GetTag(oItem), TRUE, FALSE));

}
