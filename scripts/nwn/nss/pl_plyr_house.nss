#include "nwnx_inc"
#include "pc_funcs_inc"

// OnFailToOpen
void main(){
    SpeakString("pl_plyr_house");

    if(GetLocalInt(OBJECT_SELF, "HouseLock"))
        return;

    SetLocalInt(OBJECT_SELF, "HouseLock", TRUE);

    object oPC = GetClickingObject(), oHouse;
    string sPlayer = GetStringLowerCase(GetLocalString(OBJECT_SELF, "pc_player_name"));
    int nType, nHouse;
    string sResref, sTag;

    SpeakString(sPlayer);

    if(sPlayer != GetStringLowerCase(GetPCPlayerName(oPC))){
        ErrorMessage(oPC, "This is not your house!");
        return;
    }

    sTag = GetLocalString(GetModule(), "hse_" + sPlayer);
    if(sTag == ""){
        SpeakString("Attempting to Create House");

        // No house created.
        int nType = GetLocalInt(OBJECT_SELF, "pc_house_type");
        if(nType == 0) nType = 1;

        sResref = "pl_plyrhse_00" + IntToString(nType);

        oHouse = CreateArea(sResref);
        if(oHouse == OBJECT_INVALID)
            ErrorMessage(oPC, "Waypoint Failed to Create");

        // Update house count
        nHouse = GetLocalInt(GetModule(), "hse_count") + 1;
        SetLocalInt(GetModule(), "hse_count", nHouse);

        // Create a new tag for the house, set it on the module so that a player
        // can easily re-enter the area.
        sTag = "hse_tag_" + IntToString(nHouse);
        //SetTag(oHouse, sTag);
        SetAreaName(oHouse, GetLocalString(OBJECT_SELF, "pl_hse_name"));
        SetLocalString(GetModule(), "hse_" + sPlayer, sTag);

        object oTemp = GetFirstObjectInArea(oHouse);
        if(GetTag(oTemp) != "pl_plyrhse_spawn")
            oTemp = GetNearestObjectByTag("pl_plyrhse_spawn", oTemp);

        object oWay = CreateObject(OBJECT_TYPE_WAYPOINT, "pl_plyrhse_way", GetLocation(oTemp), FALSE, "wp_" + sTag);
        if(oWay == OBJECT_INVALID)
            ErrorMessage(oPC, "Waypoint Failed to Create");

        Logger(oPC, "DebugHouses", LOGLEVEL_DEBUG, "Player: %s, House Type: %s, Resref: %s, Tag: %s, House Count: %s",
            sPlayer, IntToString(nType), sResref, sTag, IntToString(nHouse));
    }

    // Port em in.
    JumpSafeToWaypoint("wp_" + sTag, oPC);

    DelayCommand(2.0f, DeleteLocalInt(OBJECT_SELF, "HouseLock"));
}
