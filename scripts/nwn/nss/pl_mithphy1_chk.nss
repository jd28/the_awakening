#include "nwnx_inc"

int StartingConditional()
{
    int nNode = GetCurrentNodeID();
    int nDamType = GetLocalInt(OBJECT_SELF, "MithDam5") - 1;
    switch(nNode){
        case 0: if(nDamType == DAMAGE_TYPE_BLUDGEONING) return FALSE;
        case 1: if(nDamType == DAMAGE_TYPE_PIERCING) return FALSE;
        case 2: if(nDamType == DAMAGE_TYPE_SLASHING) return FALSE;
    }

    return TRUE;
}
