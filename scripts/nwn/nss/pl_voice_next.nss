#include "mod_const_inc"
#include "nwnx_inc"

void main(){

    object oPC = GetPCSpeaker();
    int nCurrent = GetSoundset(oPC);
    int bFoundNext;
    string sSoundSet, sType, sStrref;

    while(!bFoundNext){
        nCurrent++;
        if(nCurrent > MAX_VOICESET_NUM)
            nCurrent = 0;

        sSoundSet = Get2DAString("soundset", "RESREF", nCurrent);
        sType = Get2DAString("soundset", "TYPE", nCurrent);
        sStrref = Get2DAString("soundset", "STRREF", nCurrent);

        if(sSoundSet == "" ||
           (!GetLocalInt(OBJECT_SELF, "IncludeMonsters") && sType == "4"))
            continue;

        bFoundNext = TRUE;
        SetCustomToken(PL_VOICE_CHANGE_TOKEN, GetStringByStrRef(StringToInt(sStrref)));
        SetSoundset(oPC, nCurrent);
        SendMessageToPC(oPC, "Current Voiceset: " + IntToString(nCurrent));
    }
}
