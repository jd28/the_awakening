#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();

    CreateItemOnObject("dno_hallowaegis", oPC);
    if(GetItemPossessedBy(oPC, "nr_lollipop") == OBJECT_INVALID){
        CreateItemOnObject("nr_lollipop", oPC);
    }
    else{
        SpeakString("It seems as tho I've ran out of rewards.");
    }

    JumpSafeToWaypoint("wp_elfcity", oPC);
}

