///////////////////////////////////////////////////////////////////////////////
// file: place_conv
// event: OnUsed
// description: A conversation with the same name as the placeables's tag will be
//      started with the PC. If you use any of conversation scripts the
//      variables can be set on the placeable.  e.g. con_port. The conversation will
//      be private.
///////////////////////////////////////////////////////////////////////////////
void main(){

    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;

    //AssignCommand(oPC, ClearAllActions());
    ActionStartConversation(oPC);
}
