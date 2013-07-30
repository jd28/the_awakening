#include "nwnx_inc"

int StartingConditional()
{
    int nNode = GetCurrentNodeID();
    int nDamType = GetLocalInt(OBJECT_SELF, "MithDam3") - 1;
    switch(nNode){
        case 0: if(nDamType == DAMAGE_TYPE_DIVINE) return FALSE;
        case 1: if(nDamType == DAMAGE_TYPE_MAGICAL) return FALSE;
        case 2: if(nDamType == DAMAGE_TYPE_NEGATIVE) return FALSE;
        case 3: if(nDamType == DAMAGE_TYPE_POSITIVE) return FALSE;
    }

    return TRUE;
}
