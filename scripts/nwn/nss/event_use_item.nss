void main(){
    object oPC = OBJECT_SELF;
    object oTarget = GetLocalObject(OBJECT_SELF, "NWNX!EVENTS!TARGET");
    object oItem = GetLocalObject(OBJECT_SELF, "NWNX!EVENTS!ITEM");
    //WriteTimestampedLogEntry(GetName(oPC)+" used item '"+GetName(oItem)+"' on "+GetName(oTarget));
    AssignCommand(GetFirstPC(), SpeakString("Target: "+ GetName(oTarget) + "; Item: " +GetName(oItem)));
}
