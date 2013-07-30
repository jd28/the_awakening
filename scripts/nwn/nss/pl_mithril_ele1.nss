#include "nwnx_inc"

void main(){
    int nNode = GetSelectedNodeID(), nDamType;

    switch(nNode){
        case 0: nDamType = DAMAGE_TYPE_ACID; break;
        case 1: nDamType = DAMAGE_TYPE_COLD; break;
        case 2: nDamType = DAMAGE_TYPE_ELECTRICAL; break;
        case 3: nDamType = DAMAGE_TYPE_FIRE; break;
        case 4: nDamType = DAMAGE_TYPE_SONIC; break;
    }
    SetLocalInt(OBJECT_SELF, "MithDam1", nDamType+1);
}
