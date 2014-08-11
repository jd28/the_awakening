#include "sha_subr_methds"
void main()
{
//:::::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Ape :::::::
//:::::::::::::::::::::::::::::::::::::::::
	struct SubraceBaseStatsModifier stats;

//Subrace Name: Ape

//Must be: Half-Orc.
   CreateSubrace(RACIAL_TYPE_HALFORC, "Ape", "pl_subhide_007", "",FALSE, 0, FALSE, 0);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(2, 4, 2, 0, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ape", stats, 1);

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
    stats = CustomBaseStatsModifiers(2, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Minotaur", stats, 1);

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
    stats = CustomBaseStatsModifiers(4, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ogre", stats, 1);

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
	 stats = CustomBaseStatsModifiers(2, 4, 4, -2, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Wemic", stats, 1);

//Apearance: Bugbear - Permanent.
    CreateSubraceAppearance("Wemic", TIME_BOTH, 1000, 1000);

// Feats
    ModifySubraceFeat("Wemic", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Wemic", FEAT_DARKVISION, 1);

// SKills

    ModifySubraceSkill("Wemic", SKILL_SPOT, 20);
    ModifySubraceSkill("Wemic", SKILL_LISTEN, 20);

//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PLAIN
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

//Must be: Half-Orc.
   CreateSubrace(RACIAL_TYPE_HALFORC, "Ape_plain", "pl_subhide_007", "",FALSE, 0, FALSE, 0);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(2, 4, 2, 0, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ape_plain", stats, 1);

// Feats
    ModifySubraceFeat("Ape_plain", FEAT_DODGE, 1);
    ModifySubraceFeat("Ape_plain", FEAT_MOBILITY, 1);
    ModifySubraceFeat("Ape_plain", FEAT_AMBIDEXTERITY, 1);

//:::::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Minotaur :::::::
//:::::::::::::::::::::::::::::::::::::::::

//Subrace Name: Minotaur

//Must be: Half-Orc.
   CreateSubrace(RACIAL_TYPE_HALFORC, "Minotaur_plain", "pl_subhide_009", "pl_subitem_009",FALSE, 0, FALSE, 0);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    //Ability Bonus: str +2
    //Decreased Ability: Int, Cha: -2
    stats = CustomBaseStatsModifiers(2, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Minotaur_plain", stats, 1);

// Feats
    ModifySubraceFeat("Minotaur_plain", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Minotaur_plain", FEAT_DARKVISION, 1);
    ModifySubraceFeat("Minotaur_plain", FEAT_BULLHEADED, 1);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Ogre :::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Ogre

//Must be:  Half-Orc
     CreateSubrace(RACIAL_TYPE_HALFORC, "Ogre_plain", "pl_subhide_001", "", FALSE, 0, FALSE, 0);

//LETO - Change ability scores:
    stats = CustomBaseStatsModifiers(4, -2, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Ogre_plain", stats, 1);

//Can't use any Tiny weapons (Too big to hold them!!)
    SubraceRestrictUseOfItems("Ogre_plain", ITEM_TYPE_WEAPON_SIZE_TINY, TIME_BOTH);

// Feats
    ModifySubraceFeat("Ogre_plain", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Ogre_plain", FEAT_THUG, 1);
    ModifySubraceFeat("Ogre_plain", FEAT_CLEAVE, 1);
    ModifySubraceFeat("Ogre_plain", FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);


//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Bugbear ::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Bugbear.

//Properties from the Skin:
    //AC Bonus +3

//Must be: Half-Orc.
//ECL: + 1
     CreateSubrace(RACIAL_TYPE_HALFORC, "Wemic_plain", "pl_subhide_010", "pl_subitem_015", FALSE, 0 , FALSE, 0, 1);

//LETO - Change ability scores:
    stats = CustomBaseStatsModifiers(2, 4, 4, -2, -2, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Wemic_plain", stats, 1);

// Feats
    ModifySubraceFeat("Wemic_plain", FEAT_KNOCKDOWN, 1);
    ModifySubraceFeat("Wemic_plain", FEAT_DARKVISION, 1);

// SKills

    ModifySubraceSkill("Wemic_plain", SKILL_SPOT, 20);
    ModifySubraceSkill("Wemic_plain", SKILL_LISTEN, 20);

    WriteTimestampedLogEntry("SUBRACE : pl_sub_halforc : Loaded");
}
