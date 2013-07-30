///////////////////////////////////////////////////////////////////////////////
// file: con_isdm
// script: Text Appears When...
// description: Show text only when the person speaking is a DM or the DM
//      has possessed an NPC.
///////////////////////////////////////////////////////////////////////////////

int StartingConditional(){
    object oPC = GetPCSpeaker();
    return (GetIsDM(oPC) || GetIsDMPossessed(oPC));
}
