#include "nwnx_redis"
#include "nwnx_database"

void DeletePersistantVariable(object pc, string var, int global=FALSE);

string GetRedisID(object pc, int global = FALSE);

int GetPersistantInt(object pc, string var, int global=FALSE);
string SetPersistantInt(object pc, string var, int val, int timeout = 0, int global=FALSE);

string GetPersistantString(object pc, string var, int global=FALSE);
string SetPersistantString(object pc, string var, string val, int timeout = 0, int global=FALSE);

location GetPersistantLocation(object pc, string var, int global=FALSE);
string SetPersistantLocation(object pc, string var, location val, int timeout = 0, int global=FALSE);

void DeletePersistantVariable(object pc, string var, int global=FALSE) {
  if(!GetIsObjectValid(pc) || !GetStringLength(var)) return;
  string nvar = var + ":" + GetRedisID(pc, global);
  DEL(nvar);
}

string GetRedisID(object pc, int global = FALSE) {
    if(global) {
        return GetLocalString(pc, VAR_PC_PLAYER_NAME);
    }
    else {
        return GetLocalString(pc, VAR_PC_PLAYER_NAME)+":"+GetLocalString(pc, VAR_PC_BIC_FILE);
    }
}

int GetPersistantInt(object pc, string var, int global=FALSE) {
  return StringToInt(GetPersistantString(pc, var, global));
}

string SetPersistantInt(object pc, string var, int val, int timeout = 0, int global=FALSE) {
  return SetPersistantString(pc, var, IntToString(val), timeout, global);
}

string GetPersistantString(object pc, string var, int global=FALSE) {
  if(!GetIsObjectValid(pc) || !GetStringLength(var)) return "";
  string nvar = var + ":" + GetRedisID(pc, global);

  string cur = GetLocalString(pc, nvar);
  if(GetStringLength(cur)) {
    return cur;
  }

  cur = GET(nvar);
  SetLocalString(pc, nvar, cur);
  return cur;
}

string SetPersistantString(object pc, string var, string val, int timeout = 0, int global=FALSE) {
  if(!GetIsObjectValid(pc) || !GetStringLength(var)) return "";
  string nvar = var + ":" + GetRedisID(pc, global);
  return SET(nvar, val, timeout);
}

location GetPersistantLocation(object pc, string var, int global=FALSE) {
  return APSStringToLocation(GetPersistantString(pc, var, global));
}

string SetPersistantLocation(object pc, string var, location val, int timeout=0, int global=FALSE) {
  return SetPersistantString(pc, var, APSLocationToString(val), timeout, global);
}

void SavePersistentLocation(object pc){
  object oArea = GetArea(pc);
  int type = GetLocalInt(oArea, VAR_AREA_LOC_SAVE);
  string key, loc;
  switch(type){
    case 2:
      SendPCMessage(pc, C_RED+"You have reached a point of no return.  In order to save your location " +
          "you must return to the previous area (if you can).  Your previous saved location has been deleted." + C_END);
      DeletePersistantVariable(pc, "loc");
      // No break;
    case 1:
      SendPCMessage(pc, C_RED+"Your location cannot be saved in this area."+C_END);
    break;
    default:
      SetPersistantLocation(pc, "loc", GetLocation(pc));
      SendPCMessage(pc, C_GREEN+"Your location has been saved."+C_END);
    }
}
