#include "nwnx_inc"

int StartingConditional()
{
    int nNode = GetCurrentNodeID();
    int nDamType = GetLocalInt(OBJECT_SELF, "MithDam1") - 1;
    switch(nNode){
        case 0: if(nDamType == DAMAGE_TYPE_ACID) return FALSE;
        case 1: if(nDamType == DAMAGE_TYPE_COLD) return FALSE;
        case 2: if(nDamType == DAMAGE_TYPE_ELECTRICAL) return FALSE;
        case 3: if(nDamType == DAMAGE_TYPE_FIRE) return FALSE;
        case 4: if(nDamType == DAMAGE_TYPE_SONIC) return FALSE;
    }

    return TRUE;
}
