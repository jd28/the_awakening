#include "nwnx_inc"

void main(){
    int nNode = GetSelectedNodeID(), nDamType;
    switch(nNode){
        case 0: nDamType = DAMAGE_TYPE_DIVINE; break;
        case 1: nDamType = DAMAGE_TYPE_MAGICAL; break;
        case 2: nDamType = DAMAGE_TYPE_NEGATIVE; break;
        case 3: nDamType = DAMAGE_TYPE_POSITIVE; break;
    }
    SetLocalInt(OBJECT_SELF, "MithDam3", nDamType+1);
}
