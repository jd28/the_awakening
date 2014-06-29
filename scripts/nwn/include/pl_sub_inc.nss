//pl_sub_inc
int GetIsNormalRace(object oPC);
int GetIsParagon(object oPC);

int GetIsNormalRace(object oPC){
    if(GetSubRace(oPC) == "Human")
        return TRUE;
    else if(GetSubRace(oPC) == "Dwarf")
        return TRUE;
    else if(GetSubRace(oPC) == "Elf")
        return TRUE;
    else if(GetSubRace(oPC) == "Gnome")
        return TRUE;
    else if(GetSubRace(oPC) == "Half-Orc")
        return TRUE;
    else if(GetSubRace(oPC) == "Half-Elf")
        return TRUE;
    else if(GetSubRace(oPC) == "Halfling")
        return TRUE;

    return FALSE;
}

int GetIsParagon(object oPC){
    return (GetSubRace(oPC) == "Paragon");
}
