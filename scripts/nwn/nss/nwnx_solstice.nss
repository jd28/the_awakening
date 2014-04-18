
// Remove object from Solstice cache.
void NWNXSolstice_RemoveFromObjectCache(object oObject);
void NWNXSolstice_UpdateCombatInfo(object oObject);

void NWNXSolstice_RemoveFromObjectCache(object oObject) {
	SetLocalString(GetModule(), "NWNX!SOLSTICE!REMOVEFROMCACHE", ObjectToString(oObject));
}

void NWNXSolstice_UpdateCombatInfo(object oObject) {
	SetLocalString(GetModule(), "NWNX!SOLSTICE!UPDATECOMBATINFO", ObjectToString(oObject));
}
