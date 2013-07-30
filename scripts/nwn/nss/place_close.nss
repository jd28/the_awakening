void main(){
    int nDelay = GetLocalInt(OBJECT_SELF, "Delay");
    int nRelock = GetLocalInt(OBJECT_SELF, "Relock");

    if(nRelock != 0)
        DelayCommand(IntToFloat(nDelay), SetLocked(OBJECT_SELF, TRUE));

}
