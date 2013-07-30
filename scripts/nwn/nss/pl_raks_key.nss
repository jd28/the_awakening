#include "nw_i0_plot"
#include "mod_funcs_inc"

void main(){
    object oPC = GetLastUsedBy();

    if(GetLocalInt(OBJECT_SELF, "Used")){
        SendMessageToPC(oPC, "You see an indentation where a key might have been.  Perhaps it will be back later.");
    }

    string sWaypoint = "wp_raks_key_";
    location lLoc1 = GetLocation(GetWaypointByTag(sWaypoint+"1"));
    location lLoc2 = GetLocation(GetWaypointByTag(sWaypoint+"2"));
    location lLoc3 = GetLocation(GetWaypointByTag(sWaypoint+"3"));
    location lLoc4 = GetLocation(GetWaypointByTag(sWaypoint+"4"));

    if(!HasItem(oPC, "rak_bosskey")){
        CreateItemOnObject("rak_bosskey", oPC);
        SetLocalInt(OBJECT_SELF, "Used", 1);
        DelayCommand(1600.0f, DeleteLocalInt(OBJECT_SELF, "Used"));

        //Spawn Greater Raks
        DelayCommand(0.2f, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "rak_rakshasa4", lLoc1)));
        DelayCommand(0.2f, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "rak_rakshasa4", lLoc2)));
        DelayCommand(0.2f, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "rak_rakshasa4", lLoc3)));
        DelayCommand(0.2f, ObjectToVoid(CreateObject(OBJECT_TYPE_CREATURE, "rak_rakshasa4", lLoc4)));
    }


}
