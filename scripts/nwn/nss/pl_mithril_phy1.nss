#include "nwnx_inc"

void main(){
    int nNode = GetSelectedNodeID(), nDamType;
    switch(nNode){
        case 0: nDamType = DAMAGE_TYPE_BLUDGEONING; break;
        case 1: nDamType = DAMAGE_TYPE_PIERCING; break;
        case 2: nDamType = DAMAGE_TYPE_SLASHING; break;
    }
    SetLocalInt(OBJECT_SELF, "MithDam5", nDamType+1);
}
