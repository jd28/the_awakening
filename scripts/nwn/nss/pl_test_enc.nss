#include "nwnx_encounters"

void main(){
    object enc = OBJECT_SELF;
    object oPC = GetEnteringObject();
    int count = GetSpawnPointCount(enc), i;
    SendMessageToPC(oPC, "Spawn Point Count: "+IntToString(count));

    for(i = 0; i < count; i++)
        GetSpawnPointByPosition(enc, i);
    
}
