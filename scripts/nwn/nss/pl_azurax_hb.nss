#include "nwnx_inc"

void main(){
    string sSpells = GetLocalString(OBJECT_SELF, "Spells");
    if(sSpells == ""){
        sSpells = GetAllMemorizedSpells (OBJECT_SELF);
        SetLocalString(OBJECT_SELF, "Spells", sSpells);
    }
    int nCount = GetLocalInt(OBJECT_SELF, "HB_COUNT") + 1;
    if(nCount % 6 == 0)
        RestoreReadySpells(OBJECT_SELF, sSpells);

    SetLocalInt(OBJECT_SELF, "HB_COUNT", nCount);
}
