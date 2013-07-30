#include "sha_subr_methds"
void main(){

//:::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Dwarf - Artic :::::::::
//:::::::::::::::::::::::::::::::::::::

//Subrace Name: Dwarf-Artic.

//Must be: Dwarf.
    CreateSubrace(RACIAL_TYPE_DWARF, "Dwarf-arctic", "pchide", "pl_subitem_005", FALSE, 0, FALSE, 0);

//LETO - Feats:
    ModifySubraceFeat("Dwarf-arctic", FEAT_EPIC_ENERGY_RESISTANCE_COLD_1, 1);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier DwarfArticStats = CustomBaseStatsModifiers(0, 0, 4, 0, 0, 0, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Dwarf-arctic", DwarfArticStats, 1);

// Hair: lightest gray = 16, Skin: stone = 60
    ModifySubraceAppearanceColors("Dwarf-arctic",27,27,164,164);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Dwarf - Duergar :::::::::
//:::::::::::::::::::::::::::::::::::::::

//Subrace Name: Dwarf-Duergar

//Abilities from the unique item:
//Must be: Dwarf. Light sensitive.
    CreateSubrace(RACIAL_TYPE_DWARF, "Dwarf-duergar", "pl_subhide_006", "pl_subitem_008", TRUE);

// Hair: lightest gray = 16, Skin: stone = 60
    ModifySubraceAppearanceColors("Drow-male", 16, 16, 30, 30, 1);

//LETO - Change ability scores:
    struct SubraceBaseStatsModifier DwarfDuergarStats = CustomBaseStatsModifiers(0, 2, 0, 0, 4, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Dwarf-duergar", DwarfDuergarStats, 1);

//LETO - Feats:
    ModifySubraceFeat("Dwarf-duergar", FEAT_WEAPON_FOCUS_SICKLE, 1);
    ModifySubraceFeat("Dwarf-duergar", FEAT_IMPROVED_CRITICAL_SICKLE, 1);

//:::::::::::::::::::::::::::::::::::::::
//:::: SUBRACE: Dwarf - Mountain ::::::::
//:::::::::::::::::::::::::::::::::::::::


//Subrace Name: Dwarf-Mountain.

//Must be: Dwarf.
   CreateSubrace(RACIAL_TYPE_DWARF, "Dwarf-mountain", "pchide", "pl_subitem_006");

// Abilities
    struct SubraceBaseStatsModifier MountDwarfStats = CustomBaseStatsModifiers(2, 0, 4, 0, 0, -2, MOVEMENT_SPEED_CURRENT);
    CreateBaseStatModifier("Dwarf-mountain", MountDwarfStats, 1);

//LETO - Feats:
    ModifySubraceFeat("Dwarf-mountain", FEAT_WEAPON_PROFICIENCY_EXOTIC, 1);
    ModifySubraceFeat("Dwarf-mountain", FEAT_WEAPON_SPECIALIZATION_DWAXE, 1);

/////////////////////////////////////////////////////////////////////////////////////////////

    WriteTimestampedLogEntry("SUBRACE : pl_sub_dwarf : Loaded");
}
