void CreateMaelephant(string sResref, location lLoc){
    CreateObject(OBJECT_TYPE_CREATURE, sResref, lLoc, FALSE, "Spawned");
}

void main(){
    object oDoor = GetNearestObjectByTag("pl_engdiab_doors");
    int nMage, nCount = 1;
    string sResref;

    if(GetLocalInt(OBJECT_SELF, "Spawned"))
        return;

    SetLocalInt(OBJECT_SELF, "Spawned", TRUE);

    SpeakString("Come forth, my servants!!!");

    while(oDoor != OBJECT_INVALID){
        if(d2() == 1 || nMage >= 3){
            sResref = "pl_engdiab_004";
            DelayCommand(1.0f, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
            DelayCommand(1.0f, AssignCommand(oDoor, CreateMaelephant(sResref, GetLocation(oDoor))));
        }
        else{
            DelayCommand(2.0f, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
            DelayCommand(2.0f, AssignCommand(oDoor, CreateMaelephant(sResref, GetLocation(oDoor))));
            sResref = "pl_engdiab_005";
            nMage++;
        }

        nCount++;
        oDoor = GetNearestObjectByTag("pl_engdiab_doors", OBJECT_SELF, nCount);
    }
}
