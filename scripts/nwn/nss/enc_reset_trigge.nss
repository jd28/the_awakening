void main(){
    object oTrigger = GetObjectByTag("trig_"+GetTag(OBJECT_SELF));
    WriteTimestampedLogEntry(GetTag(OBJECT_SELF) + ": Exhausted.");

    DelayCommand(1800.0f, DeleteLocalInt(oTrigger, "Locked"));

}
