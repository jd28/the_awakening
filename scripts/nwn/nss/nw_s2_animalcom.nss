//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "gsp_func_inc"

void main(){
    object oPC = OBJECT_SELF;

    if(GetLevelByClass(CLASS_TYPE_RANGER) >= 35 &&
       GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE) >= 30)
    {
        int nType = GetAnimalCompanionCreatureType(OBJECT_SELF);
        int nAppearance = -1, nPortrait = -1;
        switch(nType){
            case ANIMAL_COMPANION_CREATURE_TYPE_BADGER:
                nAppearance = APPEARANCE_TYPE_BADGER;
                nPortrait = 144;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_BEAR:
                nAppearance = APPEARANCE_TYPE_BEAR_BROWN;
                nPortrait = 148;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_BOAR:
                nAppearance = APPEARANCE_TYPE_BOAR;
                nPortrait = 152;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_DIRERAT:
                nAppearance = APPEARANCE_TYPE_RAT_DIRE;
                nPortrait = 603;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_DIREWOLF:
                nAppearance = APPEARANCE_TYPE_DOG_DIRE_WOLF;
                nPortrait = 184;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_HAWK:
                nAppearance = 1275;
                nPortrait = 2224;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_PANTHER:
                nAppearance = APPEARANCE_TYPE_CAT_PANTHER;
                nPortrait = 3496;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_SPIDER:
                nAppearance = APPEARANCE_TYPE_SPIDER_GIANT;
                nPortrait = 2089;
            break;
            case ANIMAL_COMPANION_CREATURE_TYPE_WOLF:
                nAppearance = APPEARANCE_TYPE_DOG_WOLF;
                nPortrait = 319;
            break;
        }
        if(GetPCPlayerName(oPC) == "Irimarblue" && CreateShadow(oPC, GetLevelByClass(CLASS_TYPE_RANGER),
            "Mr. Clucky", APPEARANCE_TYPE_CHICKEN, 168,
            "Here they come to snuff the rooster, aww yeah, hey yeah\nYeah here come the rooster, yeah\nYou know he ain't gonna die\nNo, no, no, ya know he ain't gonna die"))
        {
            return;
        }
        else if(GetPCPlayerName(oPC) == "Gnar22" && CreateShadow(oPC, GetLevelByClass(CLASS_TYPE_RANGER),
            "Kohan", APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE, GetPortraitId(oPC),
            "Here we are, born to be kings,\n We're the princes of the universe."))
        {
            return;
        }
        else if(CreateShadow(oPC, GetLevelByClass(CLASS_TYPE_RANGER),
            GetAnimalCompanionName(oPC), nAppearance, nPortrait))
            return; // Shadow created!
    }

    //Yep thats it
    SummonAnimalCompanion();
}
