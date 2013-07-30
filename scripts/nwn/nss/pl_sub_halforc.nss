#include "sha_subr_methds"
void main()
{
//:::::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Ape :::::::
//:::::::::::::::::::::::::::::::::::::::::

//Subrace Name: Ape

//Must be: Half-Orc.
   CreateSubrace(RACIAL_TYPE_HALFORC, "Ape", "pl_subhide_007", "",FALSE, 0, FALSE, 0);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    struct SubraceBaseStatsModifier ApeStats = CustomBaseStatsModifiers(2, 4, 2, 0, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ape", ApeStats, 1);

//Apearance.
   CreateSubraceAppearance("Ape", TIME_BOTH, 1911, 1911);

// Feats
    ModifySubraceFeat("Ape", FEAT_DODGE, 1);
    ModifySubraceFeat("Ape", FEAT_MOBILITY, 1);
    ModifySubraceFeat("Ape", FEAT_AMBIDEXTERITY, 1);

//:::::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Minotaur :::::::
//:::::::::::::::::::::::::::::::::::::::::

//Subrace Name: Minotaur

//Must be: Half-Orc.
   CreateSubrace(RACIAL_TYPE_HALFORC, "Minotaur", "pl_subhide_009", "pl_subitem_009",FALSE, 0, FALSE, 0);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    //Ability Bonus: str +2
    //Decreased Ability: Int, Cha: -2
    struct SubraceBaseStatsModifier MinotaurStats = CustomBaseStatsModifiers(2, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Minotaur", MinotaurStats, 1);

//Apearance: Goblin - Permanent.
   CreateSubraceAppearance("Minotaur", TIME_BOTH, APPEARANCE_TYPE_MINOTAUR, APPEARANCE_TYPE_MINOTAUR_SHAMAN);

// Feats
    ModifySubraceFeat("Minotaur", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Minotaur", FEAT_DARKVISION, 1);
    ModifySubraceFeat("Minotaur", FEAT_BULLHEADED, 1);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Ogre :::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Ogre

//Must be:  Half-Orc
     CreateSubrace(RACIAL_TYPE_HALFORC, "Ogre", "pl_subhide_001", "", FALSE, 0, FALSE, 0);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier OgreStats = CustomBaseStatsModifiers(4, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ogre", OgreStats, 1);

//Appearance: Ogre - Permanent.
     CreateSubraceAppearance("Ogre", TIME_BOTH, 127, APPEARANCE_TYPE_OGREB);

//Can't use any Tiny weapons (Too big to hold them!!)
    SubraceRestrictUseOfItems("Ogre", ITEM_TYPE_WEAPON_SIZE_TINY, TIME_BOTH);

// Feats
    ModifySubraceFeat("Ogre", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Ogre", FEAT_THUG, 1);
    ModifySubraceFeat("Ogre", FEAT_CLEAVE, 1);
    ModifySubraceFeat("Ogre", FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);


//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Bugbear ::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Bugbear.

//Properties from the Skin:
    //AC Bonus +3

//Must be: Half-Orc.
//ECL: + 1
     CreateSubrace(RACIAL_TYPE_HALFORC, "Wemic", "pl_subhide_010", "pl_subitem_015", FALSE, 0 , FALSE, 0, 1);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier BugbearStats = CustomBaseStatsModifiers(2, 4, 4, -2, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Wemic", BugbearStats, 1);

//Apearance: Bugbear - Permanent.
    CreateSubraceAppearance("Wemic", TIME_BOTH, 1000, 1000);

// Feats
    ModifySubraceFeat("Wemic", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Wemic", FEAT_DARKVISION, 1);

// SKills

    ModifySubraceSkill("Wemic", SKILL_SPOT, 20);
    ModifySubraceSkill("Wemic", SKILL_LISTEN, 20);

//////////////////////////////////////////////////////////////////////////////

    WriteTimestampedLogEntry("SUBRACE : pl_sub_halforc : Loaded");
}

