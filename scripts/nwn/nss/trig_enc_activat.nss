void main(){
    object oPC = GetEnteringObject(), oEnc;

    if(!GetIsPC(oPC)) return;

    if(GetLocalInt(OBJECT_SELF, "Locked")){
        WriteTimestampedLogEntry("LOG: "+GetTag(OBJECT_SELF)+" spawn trigger locked!!");
        return;
    }
    string sSpawn = GetLocalString(OBJECT_SELF, "Encounter");
    if(sSpawn != ""){
        WriteTimestampedLogEntry("Log: Attempting to activate: "+sSpawn);
        oEnc = GetObjectByTag(sSpawn);
        if(!GetIsObjectValid(oEnc)){
            WriteTimestampedLogEntry("ERROR: "+GetTag(OBJECT_SELF)+" did not find an encounter!!");
        }
        if(!GetEncounterActive(oEnc)){
            SetEncounterActive(TRUE, oEnc);
            SetLocalInt(OBJECT_SELF, "Locked", TRUE);
        }
    }
}
