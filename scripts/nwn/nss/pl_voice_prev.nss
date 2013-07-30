#include "mod_const_inc"
#include "nwnx_inc"

void main(){

    object oPC = GetPCSpeaker();
    int nCurrent = GetSoundset(oPC);
    int bFound;
    string sSoundSet, sType, sStrref;

    while(!bFound){
        nCurrent--;
        if(nCurrent < 0)
            nCurrent = MAX_VOICESET_NUM;

        sSoundSet = Get2DAString("soundset", "RESREF", nCurrent);
        sType = Get2DAString("soundset", "TYPE", nCurrent);
        sStrref = Get2DAString("soundset", "STRREF", nCurrent);

        if(sSoundSet == "" ||
           (!GetLocalInt(OBJECT_SELF, "IncludeMonsters") && sType == "4"))
            continue;

        bFound = TRUE;
        SetCustomToken(PL_VOICE_CHANGE_TOKEN, GetStringByStrRef(StringToInt(sStrref)));
        SetSoundset(oPC, nCurrent);

        SendMessageToPC(oPC, "Current Voiceset: " + IntToString(nCurrent));
    }
}
