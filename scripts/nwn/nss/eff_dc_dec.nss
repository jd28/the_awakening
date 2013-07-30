#include "pl_effects_inc"

// Small example off an effect that can set variables... In this case
// a spell DC adjustment for a custom spell system.

// If you're not familiar with  the internal structure of NWN Effects, each
// effect stores properties in an array of integers.  We stored the amount
// of the DC adjustment in the integer indexed 1.

void main() {
    object oPC     = OBJECT_SELF;
    int nType      = GetCustomEffectType();
    int nEventType = GetCustomEffectEventType();
    int nNew       = GetLocalInt(oPC, "gsp_mod_dc");
    int nAmount    = GetCustomEffectInteger(1);

    if (nEventType == NWNX_EFFECTS_EVENT_APPLY) { // OnApply
        nNew -= nAmount;
    }
    else { // OnRemove
        nNew += nAmount;
    }
    
    SetLocalInt(oPC, "gsp_mod_dc", nNew);

    // Debugging
    SendMessageToPC(oPC, "Effect: " + IntToString(nType) + " New Value: " + IntToString(GetLocalInt(oPC, "AdjustDC")));
}
