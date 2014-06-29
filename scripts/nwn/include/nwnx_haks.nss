// Sets the script to be called when a player logs in.  If this function is not
// used the default script will be called which is "pl_load_enhance"
void SetEnhanceScript(string sScript);

// Tells the plugin what haks to send to the player,  if nEnhanced is less
// than or equal to 0 no hidden haks will be sent.  If greater than zero the plugin
// will send all the haks that are less than or equal to nLevel as set
// via the function: SetHakHidden(string sHak, int nLevel = 1); 
// - oPC : Target PC
// - nEnhanced : Determines which has the player can see depending on its
//               level as set by SetHakHidden
void SetPlayerEnhanced(object oPC, int nEnhanced);

// Sets a Fallback TLK that will be visible if the player logging in cannot
// see any hidden haks.  If unset the player will receive no tlk.  As if
// none were set in module properties "Custom TLK".  Mainly useful if you
// expect a player to have the CEP tlk, for example, but not your custom
// version of it.
// - sTLK : TLK file.
int SetFallBackTLK(string sTLK);

// Sets a Hak to be visible at a specified level.  Used in conjunction with
// SetPlayerEnhanced.  If the value passed to the latter function is greatre than
// or equal to nLevel that hak will be visible to the player.
// - sHak : Name of the hak file to hide.
// - nLevel : Level at which the hak is visible.  See SetPlayerEnhanced.
//   (Default: 1)
int SetHakHidden(string sHak, int nLevel = 1);

// Dumps the Hak list to the log file.  Useful for debugging.
void DumpHakList();

void DumpHakList() {
    SetLocalString(GetModule(), "NWNX!HAKS!DUMPMESSAGE", "nothing");
}
void DumpHiddenHakList() {
    SetLocalString(GetModule(), "NWNX!HAKS!DUMPHIDDENHAKS", "nothing");
}

void SetEnhanceScript(string sScript){
    SetLocalString(GetModule(), "NWNX!HAKS!SETENHANCESCRIPT", sScript);
} 

int SetHakHidden(string sHak, int nLevel = 1){
    if(nLevel <= 0)
        return -1;

    SetLocalString(GetModule(), "NWNX!HAKS!SETHAKHIDDEN", sHak + "|" + IntToString(nLevel));
    return StringToInt(GetLocalString(GetModule(), "NWNX!HAKS!SETHAKHIDDEN"));
}

int SetFallBackTLK(string sTLK){
    SetLocalString(GetModule(), "NWNX!HAKS!SETFALLBACKTLK", sTLK);
    return StringToInt(GetLocalString(GetModule(), "NWNX!HAKS!SETFALLBACKTLK"));
}

void SetPlayerEnhanced(object oPC, int nEnhanced) {
    SetLocalString(oPC, "NWNX!HAKS!SETPLAYERENHANCED", IntToString(nEnhanced));
}
