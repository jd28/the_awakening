//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::File Name: sha_leto_sraces2 ::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: OnModuleLoad script ::::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// Description: This script holds the pre-made 'wacky' subraces.These sub-races
//              are either planar or monsterous. These include things like:
//              Ogre, Illithid, Pixies... just to name a few.
//              This script is the Leto equivalent of sha_subraces2.
//              It will give players permanent ability scores,feats, etc rather than
//              as a bonus from skin/creature hide. It may also contain added benefits like
//              wings.

#include "sha_subr_methds"
void main(){

    struct SubraceBaseStatsModifier stats;
    string subrace;

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Dryad :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Dryad";
//Must be: Half-Elf
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 0, 0, 0, 2, 6, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:

//LETO - Skills:
    ModifySubraceSkill(subrace, SKILL_PERSUADE, 5, 1, FALSE);

//Appearance: Satyr - Permanent.
     CreateSubraceAppearance(subrace, TIME_BOTH, 51, 51);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace, FALSE , TRUE);

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Gnoll :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Gnoll";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(4, 0, 2, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    ModifySubraceFeat(subrace, FEAT_TOUGHNESS, 1);
    ModifySubraceFeat(subrace, FEAT_POWER_ATTACK, 1);
    ModifySubraceFeat(subrace, FEAT_CLEAVE, 1);

//LETO - Skills:

//Appearance: Satyr - Permanent.
     CreateSubraceAppearance(subrace, TIME_BOTH, 388, 389);

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Kenku :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Kenku";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(-2, 4, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    ModifySubraceFeat(subrace, FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);

//LETO - Skills:

//Appearance: Satyr - Permanent.
     CreateSubraceAppearance(subrace, TIME_BOTH, 1515, 1516);


//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Nymph :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Nymph";
//Must be: Half-Elf
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 2, 0, 0, 0, 6, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:

//LETO - Skills:
    ModifySubraceSkill(subrace, SKILL_TAUNT, 5, 1, FALSE);

//Appearance: Satyr - Permanent.
     CreateSubraceAppearance(subrace, TIME_BOTH, 126, 126);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace, FALSE , TRUE);

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Satyr :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Satyr";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 2, 4, 0, -2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat(subrace, FEAT_ARTIST, 1);
    ModifySubraceFeat(subrace, FEAT_FAVORED_ENEMY_ABERRATION, 1);

//LETO - Skills:
    //  Hide, move silent, listen, perform, spot +4
    ModifySubraceSkill(subrace, SKILL_PERFORM, 4, 1, FALSE);
    ModifySubraceSkill(subrace, SKILL_SPOT, 4, 1, FALSE);

//Appearance: Satyr - Permanent.
     CreateSubraceAppearance(subrace, TIME_BOTH, 33, 33);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace,TRUE,FALSE);

//-------------------------------------------------------------------------------------------------------------------------
// Plain

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Dryad :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Dryad_plain";
//Must be: Half-Elf
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 0, 0, 0, 2, 6, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:

//LETO - Skills:
    ModifySubraceSkill(subrace, SKILL_PERSUADE, 5, 1, FALSE);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace, FALSE , TRUE);

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Gnoll :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Gnoll_plain";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(4, 0, 2, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    ModifySubraceFeat(subrace, FEAT_TOUGHNESS, 1);
    ModifySubraceFeat(subrace, FEAT_POWER_ATTACK, 1);
    ModifySubraceFeat(subrace, FEAT_CLEAVE, 1);

//LETO - Skills:

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Kenku :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Kenku_plain";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(-2, 4, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    ModifySubraceFeat(subrace, FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);

//LETO - Skills:


//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Nymph :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Nymph_plain";
//Must be: Half-Elf
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 2, 0, 0, 0, 6, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:

//LETO - Skills:
    ModifySubraceSkill(subrace, SKILL_TAUNT, 5, 1, FALSE);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace, FALSE , TRUE);

//::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Elf - Satyr :::::::
//::::::::::::::::::::::::::::::::::::::
    subrace = "Satyr_plain";
//Must be: Half-Elf
//  ECL : +2
    CreateSubrace(RACIAL_TYPE_HALFELF, subrace, "pchide", "", FALSE, 0, FALSE, 0, 2);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    stats = CustomBaseStatsModifiers(0, 2, 4, 0, -2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, stats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat(subrace, FEAT_ARTIST, 1);
    ModifySubraceFeat(subrace, FEAT_FAVORED_ENEMY_ABERRATION, 1);

//LETO - Skills:
    //  Hide, move silent, listen, perform, spot +4
    ModifySubraceSkill(subrace, SKILL_PERFORM, 4, 1, FALSE);
    ModifySubraceSkill(subrace, SKILL_SPOT, 4, 1, FALSE);

// Gender : Male Only
     CreateSubraceGenderRestriction(subrace,TRUE,FALSE);

    WriteTimestampedLogEntry("SUBRACE : pl_sub_halfelf : Loaded");
}
