#include "nwnx_inc"

void main(){
    int nNode = GetSelectedNodeID();

    switch (nNode){
        case 0:
            SetLocalInt(GetPCSpeaker(),"MODCODE",100);
        break; 
        case 1:
            SetLocalInt(GetPCSpeaker(),"MODCODE",200);
        break; 
        case 2:
            SetLocalInt(GetPCSpeaker(),"MODCODE",300);
        break; 
        case 3:
            SetLocalInt(GetPCSpeaker(),"MODCODE",400);
        break; 
        case 4:
            SetLocalInt(GetPCSpeaker(),"MODCODE",500);
        break; 
    }
    
}
