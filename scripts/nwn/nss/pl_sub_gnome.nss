#include "sha_subr_methds"
void main()
{

//:::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Gnome - Whisper ::::::
//:::::::::::::::::::::::::::::::::::

//Subrace Name: Gnome-whisper

//Must be: Gnome.
    CreateSubrace(RACIAL_TYPE_GNOME, "Gnome-whisper", "pl_subhide_008", "pl_subitem_007");

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier SprigganStats = CustomBaseStatsModifiers(-2, 4, 0, 2, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Gnome-whisper", SprigganStats, 1);

//LETO - Feats:
    ModifySubraceFeat("Gnome-whisper", FEAT_DEFENSIVE_ROLL, 1);

//Skills
    ModifySubraceSkill("Gnome-whisper", SKILL_HIDE, 10);
    ModifySubraceSkill("Gnome-whisper", SKILL_MOVE_SILENTLY, 10);
    ModifySubraceSkill("Gnome-whisper", SKILL_TUMBLE, 5);


//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Gnome - Svirfneblin :::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Svirfneblin

//Must be: Gnome.
//Light Sensitive.
//ECL: + 2
    CreateSubrace(RACIAL_TYPE_GNOME, "Gnome-svirfneblin", "pchide", "pl_subitem_014", TRUE, 0, FALSE);

// Hair, Skin: stone = 60
    ModifySubraceAppearanceColors("Gnome-svirfneblin",16,16,60,60);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier SvirnStats = CustomBaseStatsModifiers(0, 2, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Gnome-svirfneblin", SvirnStats, 1);

//Subrace Name: Svirfneblin

//Must be: Gnome.
//Light Sensitive.
//ECL: + 2
    CreateSubrace(RACIAL_TYPE_GNOME, "Gnome-svirf", "pchide", "pl_subitem_014", TRUE, 0, FALSE);

// Hair, Skin: stone = 60
    ModifySubraceAppearanceColors("Gnome-svirf",16,16,60,60);

//LETO - Change ability scores:
    SvirnStats = CustomBaseStatsModifiers(0, 2, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Gnome-svirf", SvirnStats, 1);


/*
//:::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Gnome - Vegepygmy ::::::
//:::::::::::::::::::::::::::::::::::

//Subrace Name: Tinker

//Must be: Gnome.
    CreateSubrace(RACIAL_TYPE_GNOME, "Vegepygmy", "pl_subhide_008", "");

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier TinkerStats = CustomBaseStatsModifiers(0, 0, 2, -4, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Vegepygmy", TinkerStats, 1);
*/

    WriteTimestampedLogEntry("SUBRACE : pl_sub_gnome : Loaded");
}
