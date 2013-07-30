//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//:::::::::::::::::File Name: sha_leto_sraces1 ::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::: OnModuleLoad script ::::::::::::::::::::::::::::::::::::
//:: Written By: Shayan.
//:: Contact: mail_shayan@yahoo.com
//
// Description: This script holds the pre-made 'normal' subraces. (By normal I mean,
//              subraces that are often found on persistent worlds. These sub-races
//              are humaniod sub-races... that is subraces like:
//              Drow, Aasimar, Duergar, etc.
//              This script is the Leto equivalent of sha_subraces1.
//              It will give players permanent ability scores,feats, etc rather than
//              as a bonus from skin/creature hide. It may also contain added benefits like
//              wings.


#include "sha_subr_methds"
void main(){

struct SubraceBaseStatsModifier MyStats;

//:::::::::::::::::::::::::::::::::::::
//:::: SUBRACES: Default ::::::::::::::
//:::::::::::::::::::::::::::::::::::::
//Subrace Name: Dwarf
//Must be: Dwarf.
    CreateSubrace(RACIAL_TYPE_DWARF, "Dwarf", "pchide");
    //SetupSubraceAlias("Dwarf-Hill", "Hill Dwarf");

//Subrace Name: Elf
//Must be: Elf
   CreateSubrace(RACIAL_TYPE_ELF, "Elf", "pchide");

//Subrace Name: Gnome
//Must be: Gnome.
    CreateSubrace(RACIAL_TYPE_GNOME, "Gnome", "pchide");
    //SetupSubraceAlias("Gnome-Rock", "Rock Gnome");

//Subrace Name: Half-Orc
//Must be: Half-Orc
    CreateSubrace(RACIAL_TYPE_HALFORC, "Half-Orc", "pchide");
    MyStats = CustomBaseStatsModifiers(2, 0, 0, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Half-Orc", MyStats, 1);

//Subrace Name: Human
//Must be: Human
     CreateSubrace(RACIAL_TYPE_HUMAN, "Human", "pchide");

//Subrace Name: Half-High
//Must be: Half-Elf
    CreateSubrace(RACIAL_TYPE_HALFELF, "Half-Elf", "pchide");

//Subrace Name: Halfling
//Must be: Halfling.
    CreateSubrace(RACIAL_TYPE_HALFLING, "Halfling", "pchide");

}

