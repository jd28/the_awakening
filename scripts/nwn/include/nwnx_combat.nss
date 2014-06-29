int NWNXCombat_GetABVersus(object oCreature = OBJECT_SELF,
                           object oVersus = OBJECT_INVALID);
int NWNXCombat_GetACVersus(object oCreature = OBJECT_SELF,
                           object oVersus = OBJECT_INVALID);
int NWNXCombat_GetMaxHitPoints(object oCreature = OBJECT_SELF);
int NWNXCombat_GetSkillRank(int skill, object oCreature = OBJECT_SELF, 
                            object oVersus = OBJECT_INVALID); 
void NWNXCombat_Update(object oCreature = OBJECT_SELF);

void NWNXCombat_InitTables();

void NWNXCombat_InitTables() {
    SetLocalString(GetModule(), "NWNX!COMBAT!INIT_TABLES", " ");
}

int NWNXCombat_GetABVersus(object oCreature = OBJECT_SELF,
                           object oVersus = OBJECT_INVALID) {
    SetLocalString(oCreature, "NWNX!COMBAT!GETABVERSUS", ObjectToString(oVersus));
    return StringToInt(GetLocalString(oCreature, "NWNX!COMBAT!GETABVERSUS"));
}

int NWNXCombat_GetACVersus(object oCreature = OBJECT_SELF,
                           object oVersus = OBJECT_INVALID) {

    SetLocalString(oCreature, "NWNX!COMBAT!GETACVERSUS", ObjectToString(oVersus));
    return StringToInt(GetLocalString(oCreature, "NWNX!COMBAT!GETACVERSUS"));
}


int NWNXCombat_GetMaxHitPoints(object oCreature = OBJECT_SELF) {
    SetLocalString(oCreature, "NWNX!COMBAT!GETMAXHITPOINTS", "            ");
    return StringToInt(GetLocalString(oCreature, "NWNX!COMBAT!GETMAXHITPOINTS"));
}

int NWNXCombat_GetSkillRank(int skill, object oCreature = OBJECT_SELF, 
                            object oVersus = OBJECT_INVALID) {
    string param = IntToString(skill) + " ";
    param += ObjectToString(oVersus);

    SetLocalString(oCreature, "NWNX!COMBAT!GETSKILLRANK", param);
    return StringToInt(GetLocalString(oCreature, "NWNX!COMBAT!GETSKILLRANK"));
}

void NWNXCombat_Update(object oCreature = OBJECT_SELF) {
    SetLocalString(oCreature, "NWNX!COMBAT!UPDATE", "");
}
