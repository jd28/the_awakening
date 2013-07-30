void main(){
    string sResref1 = "pl_sb_axdw"; // Dwarven Waraxe
    string sResref2 = "pl_sb_scythe"; // Scythe
    string sResref3 = "pl_sb_axgrt"; // Great Axe
    string sResref4 = "pl_sb_hamwar"; // Warhammer
    object oWeapon, oShield;
    int bTwo = FALSE;

    switch(d8()){

        case 1:
        case 5: oWeapon = CreateItemOnObject(sResref1); break;
        case 2:
        case 6:
            oWeapon = CreateItemOnObject(sResref2);
            bTwo = TRUE;
        break;
        case 3:
        case 7:
            oWeapon = CreateItemOnObject(sResref3);
            bTwo = TRUE;
        break;
        case 4:
        case 8: oWeapon = CreateItemOnObject(sResref4); break;
    }
    SetDroppableFlag(oWeapon, FALSE);
    SetIdentified(oWeapon, TRUE);

    AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
    AssignCommand(OBJECT_SELF, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));

    if(!bTwo){ // If single-handed weapon get them a shield
        oShield = CreateItemOnObject("ms_sv_dwarfshiel");
        SetDroppableFlag(oShield, FALSE);
        SetIdentified(oShield, TRUE);
        AssignCommand(OBJECT_SELF, ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND));
    }
    AssignCommand(OBJECT_SELF, ActionDoCommand(SetCommandable(TRUE)));
    AssignCommand(OBJECT_SELF, SetCommandable(FALSE));

    //WriteTimestampedLogEntry("DEBUG : pl_sb_dynweap : Complete");
}
