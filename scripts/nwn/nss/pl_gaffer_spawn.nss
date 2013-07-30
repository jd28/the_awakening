void GafferSpeak(){

    switch(d6()){
        case 1: PlayVoiceChat(VOICE_CHAT_ATTACK); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BADIDEA); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 4: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 5: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
        case 6: PlayVoiceChat(VOICE_CHAT_HELLO); break;
    }

    DelayCommand(6.0f, GafferSpeak());
}

void main(){
    object oDummy = GetNearestObjectByTag("CombatDummy");
    ActionAttack(oDummy);
    DelayCommand(6.0f, GafferSpeak());
}
