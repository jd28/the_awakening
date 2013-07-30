
#include "sha_subr_methds"
void main(){

    string name;
    struct SubraceBaseStatsModifier MyStats;

    name = "Acrobat";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 2, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_DODGE, 1);

    name = "Ascetic";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 2, 0, 0, 4, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, TA_FEAT_INTUITIVE_STRIKE, 1);

    name = "Crusader";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(2, 0, 0, 0, 0, 4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_POWER_ATTACK, 1);

    name = "Curate";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 0, 0, 0, 4, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_POWER_ATTACK, 1);

    name = "Dragon-slayer";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(2, 0, 4, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);

    name = "Friar";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_WEAPON_FINESSE, 1);

    name = "Gypsy";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(2, 0, 0, 0, 4, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_BLIND_FIGHT, 1);

    name = "Hunter";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_KEEN_SENSE, 1);

    name = "Jester";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 2, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_MOBILITY, 1);

    name = "Knight";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(4, 0, 0, 0, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_POWER_ATTACK, 1);

    name = "Larcenist";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 0, 2, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_SKILL_FOCUS_OPEN_LOCK, 1);

    name = "Meathead";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(4, 0, 2, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_TOUGHNESS, 1);

    name = "Minstrel";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 2, 0, 0, 0, 4, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_ARTIST, 1);

    name = "Pagan";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 2, 0, 0, 4, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_COMBAT_CASTING, 1);

//Subrace Name: Paragon
    CreateSubrace(RACIAL_TYPE_ALL, "Paragon", "pchide");
    MyStats = CustomBaseStatsModifiers(20, 20, 20, 20, 20, 20, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Paragon", MyStats, 1, TRUE);

    name = "Sage";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 0, 0, 0, 4, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, 381, 1);

    name = "Scholar";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 0, 0, 4, 2, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_COMBAT_CASTING, 1);

    name = "Sniper";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 2, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_POINT_BLANK_SHOT, 1);

    name = "Swashbuckler";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(0, 4, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_WEAPON_FINESSE, 1);

    name = "Zealot";
    CreateSubrace(RACIAL_TYPE_ALL, name, "pchide");
    MyStats = CustomBaseStatsModifiers(4, 0, 0, 0, 0, 2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier(name, MyStats, 1);
    ModifySubraceFeat(name, FEAT_POWER_ATTACK, 1);

}
