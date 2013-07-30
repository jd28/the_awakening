#include "pc_funcs_inc"

void main(){
    int nNode = GetSelectedNodeID();
    object oItem = GetLocalObject(GetPCSpeaker(), "ITEM_TALK_TO");

    switch(nNode){
        case 0: // On / Off
            if(!GetLocalInt(oItem, "PL_MOB_SPAWNING")){
                SendMessageToPC(GetPCSpeaker(), "Mob Spawn Activated.");
                SetLocalInt(oItem, "PL_MOB_SPAWNING", 1);
            }
            else{
                SendMessageToPC(GetPCSpeaker(), "Mob Spawn Deactivated.  Monsters now selectable.");
                SetLocalInt(oItem, "PL_MOB_SPAWNING", 0);
            }
        break;
        case 1: // clear;
            SendMessageToPC(GetPCSpeaker(), "Mob Spawn Cleared.");
            SetLocalInt(oItem, "PL_MOB_SPAWN_COUNT", 0);
        break;
    }
}
