void main(){

    if(GetLocalInt(OBJECT_SELF, "Used")) return;
    int nReset = GetLocalInt(OBJECT_SELF, "place_reset");
    string sSpeak = GetLocalString(OBJECT_SELF, "place_msg");

    if(nReset > 0){
        SetLocalInt(OBJECT_SELF, "Used", 1);
        DelayCommand(IntToFloat(nReset), DeleteLocalInt(OBJECT_SELF, "Used"));
    }

    if(sSpeak != ""){
        SpeakString(sSpeak);
    }
}
