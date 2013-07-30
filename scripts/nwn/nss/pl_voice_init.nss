#include "mod_const_inc"
#include "nwnx_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nCurrent = GetSoundset(oPC);
    string sStrref = Get2DAString("soundset", "STRREF", nCurrent);
    SetCustomToken(PL_VOICE_CHANGE_TOKEN, GetStringByStrRef(StringToInt(sStrref)));
}
