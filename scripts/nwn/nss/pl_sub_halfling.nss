#include "sha_subr_methds"
void main(){

struct SubraceBaseStatsModifier MyStats;
//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Brownie ::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Brownie

//Must be: Halfling.
//ECL: +3
    CreateSubrace(RACIAL_TYPE_HALFLING, "Brownie", "pchide", "pl_subitem_004", FALSE, 0, FALSE, 0);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier BrownieStats = CustomBaseStatsModifiers(0, 4, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Brownie", BrownieStats, 1);

//LETO - Feats:
    ModifySubraceFeat("Brownie", FEAT_DODGE, 1);
    ModifySubraceFeat("Brownie", FEAT_MOBILITY, 1);

//Appearance Change: Permanent - Pixie
    CreateSubraceAppearance("Brownie", TIME_BOTH, 1002, 1002);

//Can only use tiny weapons.
//Can only wear clothing. Can't use any shields.
   SubraceRestrictUseOfItems("Brownie", ITEM_TYPE_WEAPON_SIZE_TINY | ITEM_TYPE_ARMOR_TYPE_CLOTH, TIME_BOTH, ITEM_TYPE_REQ_ANY);
//Skills
    ModifySubraceSkill("Brownie", SKILL_MOVE_SILENTLY, 10);
    ModifySubraceSkill("Brownie", SKILL_HIDE, 10);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Goblin :::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Goblin

//Must be: Halfling.
      CreateSubrace(RACIAL_TYPE_HALFLING, "Goblin", "pl_subhide_002", "pl_subitem_002");

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier GoblinStats = CustomBaseStatsModifiers(0, 2, 0, 2, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Goblin", GoblinStats, 1);

//Apearance: Goblin - Permanent.
      CreateSubraceAppearance("Goblin", TIME_BOTH, APPEARANCE_TYPE_GOBLIN_CHIEF_B, APPEARANCE_TYPE_GOBLIN_A);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Kobold :::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Kobold


//Must be: Halfling.
      CreateSubrace(RACIAL_TYPE_HALFLING, "Kobold", "pl_subhide_002", "pl_subitem_003");

//LETO - Change ability scores:  (Str, Dex, Con, Int, Wis, Cha)
    struct SubraceBaseStatsModifier KoboldStats = CustomBaseStatsModifiers(0, 2, -2, 0, 0, 4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Kobold", KoboldStats, 1);

//Apearance: Goblin - Permanent.
      CreateSubraceAppearance("Kobold", TIME_BOTH, APPEARANCE_TYPE_KOBOLD_A, APPEARANCE_TYPE_KOBOLD_A);

//Skills
    ModifySubraceSkill("Kobold", SKILL_LORE, 8);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Halfling - Pixie ::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Pixie

//Must be: Halfling.
    CreateSubrace(RACIAL_TYPE_HALFLING, "Pixie", "pl_subhide_003", "pl_subitem_016", FALSE, 0, FALSE, 0, 3);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier PixieStats = CustomBaseStatsModifiers(-2, 4, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Pixie", PixieStats, 1);

//LETO - Feats:
    ModifySubraceFeat("Pixie", FEAT_SPRING_ATTACK, 1);
    ModifySubraceFeat("Pixie", FEAT_WHIRLWIND_ATTACK, 1);

//Appearance Change: Permanent - Pixie
    CreateSubraceAppearance("Pixie", TIME_BOTH, APPEARANCE_TYPE_FAIRY, APPEARANCE_TYPE_FAIRY);

//Effect: Visual Effect - Fairy Dust.
    AddSubraceEffect("Pixie", EFFECT_TYPE_VISUALEFFECT, VFX_DUR_PIXIEDUST, FALSE, DURATION_TYPE_PERMANENT, 0.0, TIME_BOTH);


//Can only use tiny weapons.
//Can only wear clothing. Can't use any shields.
   SubraceRestrictUseOfItems("Pixie", ITEM_TYPE_WEAPON_SIZE_TINY | ITEM_TYPE_ARMOR_TYPE_CLOTH, TIME_BOTH, ITEM_TYPE_REQ_ANY);

/////////////////////////////////////////////////////////////////////////////////////

    WriteTimestampedLogEntry("SUBRACE : pl_sub_halfling : Loaded");
}
