// Load constants into Solstice environment.
// NOTE: This should ONLY be called in the module load event.
void NWNXSolstice_LoadConstants();

// Removes object from Solstice cache and calls DestroyObject.
void NWNXSolstice_DestroyObject(object oDestroy, float fDelay = 0.0f);

// Remove object from Solstice cache.
void NWNXSolstice_RemoveFromObjectCache(object oObject);

void NWNXSolstice_LoadConstants() {
     SetLocalString(GetModule(), "NWNX!SOLSTICE!LOADCONSTANTS", " ");
}

void NWNXSolstice_DestroyObject(object oDestroy, float fDelay = 0.0f) {
	NWNXSolstice_RemoveFromObjectCache(oDestroy);
	DestroyObject(oDestroy, fDelay);
}

void NWNXSolstice_RemoveFromObjectCache(object oObject) {
	SetLocalString(GetModule(), "NWNX!SOLSTICE!REMOVEFROMCACHE", ObjectToString(oObject));
}
