#include "pc_funcs_inc"
#include "nwnx_haks"

// The following is specific to my module, but really wouldn't matter
// how you determined that the PC was flagged.

// this script is run every time someone logs in.  You can change the script
// called by using SetEnhanceScript on module load.
void main () {
    object pc = OBJECT_SELF;
    int nAge = GetAge(pc);
    SetLocalInt(pc, "pc_is_pc", TRUE);
	SetLocalInt(pc, "pc_is_dm", GetIsDM(pc));
    SetLocalString(pc, "pc_player_name", GetPCPlayerName(pc));

    // Imagine a generic database call here, testing to see if the
    // player has indicated that they have the Haks.
    int enhanced = GetPlayerInt(pc, "pc_enhanced", TRUE);
    nAge = SetIntegerDigit(nAge, 0, enhanced);
    SetAge(pc, nAge);

    // This will tell the plugin whether to send the haks or not.  if
    // enhanced = 0 then none of the hidden haks will be sent.
    SetPlayerEnhanced(pc, enhanced);
}
