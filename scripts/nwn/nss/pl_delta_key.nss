//////////////////////////////////////////////////////////////////////////////
//:: File: pl_delta_key
//:: Date: 06/19/08
//::
//:: Description: After talking to the lady this script will create a Pile of
//::    Stones with the key created OnUsed in one of 20 random locations.
//::    6 potential waypoints on each of the four maps which have the format
//::    WP_<MAP>_OLKEY_<NUMBER>
//////////////////////////////////////////////////////////////////////////////

void main(){

    object oPC = GetPCSpeaker(), oStones, oWaypoint;
    location lWaypoint;
    string sWaypoint = "WP_";

    // Check to see if key stones already exist, if so just return. Also limit
    // Key spawning to once per reset for any PC
    if(GetLocalInt(oPC, "pl_delta_key") || GetLocalInt(GetModule(), "pl_delta_key")){
        return;
    }

    // Get which map where the key will be placed.
    switch(d4()){
        case 1: sWaypoint += "TDNE_OLKEY_"; break;
        case 2: sWaypoint += "TDW_OLKEY_"; break;
        case 3: sWaypoint += "TDC_OLKEY_"; break;
        case 4: sWaypoint += "TDE_OLKEY_"; break;
    }

    // Get which waypoint.
    sWaypoint += IntToString(d6());

    // Testing Purposes, comment out next line in live code.
    //sWaypoint = "WP_TDNE_OLKEY_1";

    oWaypoint = GetWaypointByTag(sWaypoint);
    lWaypoint = GetLocation(oWaypoint);

    oStones = CreateObject(OBJECT_TYPE_PLACEABLE, "pl_delta_stones", lWaypoint);
    SetLocalInt(oStones, "Right", 1);

    // Set quest active so it can't be Spammed
    SetLocalInt(GetModule(), "pl_delta_key", 1);
    SetLocalInt(oPC, "pl_delta_key", 1);

}
