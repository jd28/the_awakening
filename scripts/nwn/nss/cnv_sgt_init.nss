//::///////////////////////////////////////////////
//:: Title : Sargeant Conversation Initialization
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

void main() {
  object oPC       = GetPCSpeaker();
  int    iPVParea  = GetLocalInt(GetModule(), "PVP_ACTIVE_AREA");
  object oAnnounce = GetObjectByTag("WP_ANNOUNCE_" + IntToString(iPVParea));
  int    i;

/*
  // DEFINE KILLS
  i = GetDBint("PC_Stats", oPC, "KILLS",    "KILLS");
  SetCustomToken(7001, IntToString(i));

  // DEFINE DEATHS
  i = GetDBint("PC_Stats", oPC, "DEATHS",   "DEATHS");
  SetCustomToken(7002, IntToString(i));

  // DEFINE CAPTURES
  i = GetDBint("PC_Stats", oPC, "CAPTURES", "CAPTURES");
  SetCustomToken(7003, IntToString(i));

  // DEFINE RETURNS
  i = GetDBint("PC_Stats", oPC, "RETURNS",  "RETURNS");
  SetCustomToken(7004, IntToString(i));

  // DEFINE VICTORIES
  i = GetDBint("PC_Stats", oPC, "VICTORIES", "VICTORIES");
  SetCustomToken(7005, IntToString(i));
*/
  // DEFINE TEAM AFFILIATION
  if (GetLocalString(oPC, "PVP_SIDE") == "red")
    SetCustomToken(7006, "Arcavian");
  if (GetLocalString(oPC, "PVP_SIDE") == "blue")
    SetCustomToken(7006, "Hamptonshire");

  // DEFINE TEAM COUNTS
  SetCustomToken(7011, IntToString(GetLocalInt(GetModule(), "PVP_COUNT_blue")));
  SetCustomToken(7012, IntToString(GetLocalInt(GetModule(), "PVP_COUNT_red")));

  // DEFINE BATTLE SCORES
  SetCustomToken(7013, IntToString(GetLocalInt(oAnnounce, "BLUE_POINTS")));
  SetCustomToken(7014, IntToString(GetLocalInt(oAnnounce, "RED_POINTS")));

  // DEFINE ACTIVE BATTLE GROUND NAME
  SetCustomToken(7020, GetName(GetObjectByTag("pvp_area_"+IntToString(GetLocalInt(GetModule(), "PVP_ACTIVE_AREA")))));

}

