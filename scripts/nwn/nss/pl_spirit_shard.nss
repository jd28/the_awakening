#include "x2_inc_switches"
#include "pc_funcs_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACQUIRE)
        return;

    object pc = GetModuleItemAcquiredBy();
    object item = GetModuleItemAcquired();

    if(GetIsDM(pc) || GetIsDMPossessed(pc))
        return;

    if(!GetIsPC(pc))
        return;

    // Only need to do this once... or every loggin could become annoying.
    if(GetLocalInt(item, "Found"))
        return;

    // -------------------------------------------------------------------------
    // Announce to the server
    // -------------------------------------------------------------------------
    SendAllMessage(C_GOLD+GetName(pc) + " has found a Spirit Shard! Congratulations!"+C_END);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), pc);

    SetLocalInt(item, "Found", 1);
}

