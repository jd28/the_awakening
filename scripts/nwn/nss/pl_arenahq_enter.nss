#include "pl_pvp_inc"

void main(){
    object oOther = GetFirstPC();
    object oPC = GetEnteringObject();
    int iFound = FALSE, i;
    int nGameType = GetLocalInt(GetModule(), "PVP_ACTIVE");
    int nTeam = GetLocalInt(OBJECT_SELF, "pvp_team");

    if(nTeam == 0) return;

    // Delete any old gear.
    string sTag = "dk_team"+IntToString(nTeam);
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        if(GetStringLeft(GetTag(oItem), 8) != sTag)
            DestroyObject(oItem);

        oItem = GetNextItemInInventory(oPC);
    }

    // If already on a team, decriment it.
    if(GetLocalInt(oPC, "PVP_SIDE")){
        i = GetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(GetLocalInt(oPC, "PVP_SIDE")));
        SetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(GetLocalInt(oPC, "PVP_SIDE")), i-1);
    }

    //Set Team
    SetLocalInt(oPC, "PVP_SIDE", nTeam);

    // INCREASE SIDE'S COUNT
    i = GetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(nTeam));
    SetLocalInt(GetModule(), "PVP_COUNT_" + IntToString(nTeam), i+1);

    // DEDUCE THE PROPER TEAM NAME FROM COLOR
    string sTeam = PVPGetTeamName(nTeam);

    // LET THE PLAYER JOIN THE APPROPRIATE TEAM
    while (oOther != OBJECT_INVALID && iFound == FALSE) {
        if (GetLocalInt(oPC, "PVP_SIDE") == GetLocalInt(oOther, "PVP_SIDE") &&
            GetName(oOther) != GetName(oPC)) {
            iFound = TRUE;
            AddToParty(oPC, oOther);
        }
        oOther = GetNextPC();
    }
    // SET LIKE AND DISLIKES
    if (iFound) {
        oOther = GetFirstPC();
        while (oOther != OBJECT_INVALID) {
            if (GetLocalInt(oPC, "PVP_SIDE") == GetLocalInt(oOther, "PVP_SIDE"))
                SetPCLike(oPC, oOther);
            else
                SetPCDislike(oPC, oOther);
            oOther = GetNextPC();
        }
    }

    // ANNOUNCE TEAM AFFILIATION
    if (sTeam != "") {
        PVPAnnounce(GetName(oPC) + " has joined the " + sTeam + ".", oPC);
    }
}
