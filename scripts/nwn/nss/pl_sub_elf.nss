#include "sha_subr_methds"
void main(){

    struct SubraceBaseStatsModifier MyStats;

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE:    Elf - Grey :::::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Elf-ice

//Must be: Elf
    CreateSubrace(RACIAL_TYPE_ELF, "Elf-grey", "pchide", "");

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier ElfIceStat = CustomBaseStatsModifiers(-2, 0, 0, 4, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Elf-grey", ElfIceStat, 1);

//Feat
    ModifySubraceFeat("Elf-grey", FEAT_COMBAT_CASTING, 1);
    ModifySubraceFeat("Elf-grey", FEAT_SPELL_FOCUS_EVOCATION, 1);

//Skills
    ModifySubraceSkill("Elf-grey", SKILL_SPELLCRAFT, 8);
    ModifySubraceSkill("Elf-grey", SKILL_CONCENTRATION, 8);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE:    Elf - Wood :::::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Elf-wood

//Must be: Elf
    CreateSubrace(RACIAL_TYPE_ELF, "Elf-wood", "pchide");

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier ElfBloodStats = CustomBaseStatsModifiers(2, 4, 0, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Elf-wood", ElfBloodStats, 1);

//Feat
    ModifySubraceFeat("Elf-wood", FEAT_WEAPON_FOCUS_LONGBOW, 1);
    ModifySubraceFeat("Elf-wood", FEAT_POINT_BLANK_SHOT, 1);

//Skills
    ModifySubraceSkill("Elf-wood", SKILL_HIDE, 4);
    ModifySubraceSkill("Elf-wood", SKILL_MOVE_SILENTLY, 4);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE:    Elf - Drow :::::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Drow

//Must be Elf. Light Sensitive.
//ECL: +2
   CreateSubrace(RACIAL_TYPE_ELF, "Drow-male", "pchide", "pl_subitem_011", TRUE);

// White Hair, Black Skin
    ModifySubraceAppearanceColors("Drow-male", 16, 16, 30, 30, 1);

    CreateSubraceGenderRestriction("Drow-female", TRUE, FALSE);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier DrowStats = CustomBaseStatsModifiers(0, 2, 0, 2, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Drow-male", DrowStats, 1);

//Spell Resistance: Base (at Level 1): 10, Max(at Level 40): 50.
   CreateSubraceSpellResistance("Drow-male", 10, 50);

//Skills
    ModifySubraceSkill("Drow-male", SKILL_INTIMIDATE, 4);
    ModifySubraceSkill("Drow-male", SKILL_PARRY, 4);

//Feat
    ModifySubraceFeat("Drow-male", FEAT_AMBIDEXTERITY, 1);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE:    Elf - Drow :::::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Drow

//Must be Elf. Light Sensitive.
//ECL: +2
   CreateSubrace(RACIAL_TYPE_ELF, "Drow-female", "pchide", "pl_subitem_012", TRUE);

// White Hair, Black Skin
    ModifySubraceAppearanceColors("Drow-female", 16, 16, 30, 30, 1);

    CreateSubraceGenderRestriction("Drow-female", FALSE, TRUE);

//LETO - Change ability scores:
    DrowStats = CustomBaseStatsModifiers(2, 0, -2, 0, 4, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Drow-female", DrowStats, 1);

//Spell Resistance: Base (at Level 1): 10, Max(at Level 40): 50.
   CreateSubraceSpellResistance("Drow-female", 10, 50);

//Skills
    ModifySubraceSkill("Drow-female", SKILL_CONCENTRATION, 6);

//Feat
    ModifySubraceFeat("Drow-female", FEAT_COMBAT_CASTING, 1);


//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE:    Elf - Wild :::::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Elf-Wild

//Must be: Elf
    CreateSubrace(RACIAL_TYPE_ELF, "Elf-wild", "pchide");

//LETO - Change ability scores:
    //Decreased Ability Score: Con, Cha, Dex -2
    //Ability Scores: Str, Wis, Int +2
    struct SubraceBaseStatsModifier ElfWildStats = CustomBaseStatsModifiers(2, 0, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Elf-wild", ElfWildStats, 1);

//Feat
    ModifySubraceFeat("Elf-wild", FEAT_WILD_SHAPE, 1);

/////////////////////////////////////////////////////////////////////////////////////////////////////////

    WriteTimestampedLogEntry("SUBRACE : pl_sub_elf : Loaded");
}
