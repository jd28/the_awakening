#include "sha_subr_methds"
void main(){

	struct SubraceBaseStatsModifier MyStats;

//:::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Human - Aasimar :::::
//:::::::::::::::::::::::::::::::::::

//Subrace Name: Aasimar/////////////////////////////////////////////////////////

//Must be: Human
	string subrace = "Aasimar";
	CreateSubrace(RACIAL_TYPE_HUMAN, subrace, "pchide", "pl_subitem_010", FALSE, 0, FALSE, 0);

//LETO - Change ability scores:
    MyStats = CustomBaseStatsModifiers(0, 0, 0, 0, 2, 4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, MyStats, 1);

//LETO - Feats:
    ModifySubraceFeat(subrace, FEAT_RESIST_ENERGY_COLD, 1);
    ModifySubraceFeat(subrace, FEAT_RESIST_ENERGY_ELECTRICAL, 1);
    ModifySubraceFeat(subrace, FEAT_RESIST_ENERGY_SONIC, 1);
    ModifySubraceFeat(subrace, FEAT_IMPROVED_INITIATIVE, 1);

//LETO - Skills:
    ModifySubraceSkill(subrace, SKILL_PERSUADE, 5, 1, FALSE);
    ModifySubraceSkill(subrace, SKILL_SPELLCRAFT, 5, 1, FALSE);

//LETO - Add Angel Wings.
     ModifySubraceAppearanceAttachment(subrace, CREATURE_WING_TYPE_ANGEL, CREATURE_WING_TYPE_ANGEL, 0, 0, 1);

//End Subrace Name: Aasimar/////////////////////////////////////////////////////

//:::::::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Half-Orc - Lizardfolk :::::::
//:::::::::::::::::::::::::::::::::::::::::::

//Subrace Name: Lizardfolk

//Must be: Half-Orc.
	 subrace = "Lizardfolk";
	 CreateSubrace(RACIAL_TYPE_HUMAN, subrace, "pl_subhide_005", "pl_subitem_017");

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    MyStats = CustomBaseStatsModifiers(2, 0, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, MyStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat(subrace, FEAT_DODGE, 1);
    ModifySubraceFeat(subrace, FEAT_MOBILITY, 1);

//Apearance: Goblin - Permanent.
      CreateSubraceAppearance(subrace, TIME_BOTH, 2508, 2509);

//Subrace Name: Tiefling////////////////////////////////////////////////////////
//Must be: Human
     CreateSubrace(RACIAL_TYPE_HUMAN, "Tiefling", "pchide", "pl_subitem_001", FALSE, 0, FALSE, 0);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier TieflingStats = CustomBaseStatsModifiers(0, 2, 0, 4, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Tiefling", TieflingStats, 1);

// Eyes : Red
   ModifySubraceEyeColors("Tiefling", SUBRACE_EYE_COLOR_RED,SUBRACE_EYE_COLOR_RED);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat("Tiefling", FEAT_RESIST_ENERGY_ACID, 1);
    ModifySubraceFeat("Tiefling", FEAT_RESIST_ENERGY_ELECTRICAL, 1);
    ModifySubraceFeat("Tiefling", FEAT_RESIST_ENERGY_FIRE, 1);
    ModifySubraceFeat("Tiefling", FEAT_WEAPON_FOCUS_RAPIER, 1);

//LETO - Skills:
    ModifySubraceSkill("Tiefling", SKILL_SPOT, 5, 1, FALSE);
    ModifySubraceSkill("Tiefling", SKILL_INTIMIDATE, 5, 1, FALSE);

//LETO - Add Demon Wings and Demon tail.
     ModifySubraceAppearanceAttachment("Tiefling", CREATURE_WING_TYPE_DEMON, CREATURE_WING_TYPE_DEMON, CREATURE_TAIL_TYPE_DEVIL, CREATURE_TAIL_TYPE_DEVIL, 1);


//End Subrace Name: Tiefling////////////////////////////////////////////////////

//::::::::::::::::::::::
//:::SUBRACE: Werewolf ::
//::::::::::::::::::::::

//Human.
//ECL: + 3
   CreateSubrace(RACIAL_TYPE_HUMAN, "Werewolf", "pl_subhide_004", "pl_subitem_018", FALSE, 0, FALSE, 0, 3);

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    struct SubraceBaseStatsModifier WereWolfStats = CustomBaseStatsModifiers(2, 0, 2, -2, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Werewolf", WereWolfStats, 1);

//LETO - Feats:
    //Darkvision, Creature Wep Porf, Iron Will
    ModifySubraceFeat("Werewolf", FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, 1);
    ModifySubraceFeat("Werewolf", FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, 1);

/////////////////////////////////////////////////////////////////////////////////////////

//Subrace Name: Lizardfolk_plain

//Must be: Half-Orc.
	 subrace = "Lizardfolk_plain";
	 CreateSubrace(RACIAL_TYPE_HUMAN, subrace, "pl_subhide_005", "pl_subitem_017");

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    MyStats = CustomBaseStatsModifiers(2, 0, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(subrace, MyStats, 1);

//LETO - Feats:
    //Darkvision
    ModifySubraceFeat(subrace, FEAT_DODGE, 1);
    ModifySubraceFeat(subrace, FEAT_MOBILITY, 1);

    WriteTimestampedLogEntry("SUBRACE : pl_sub_human : Loaded");
}
