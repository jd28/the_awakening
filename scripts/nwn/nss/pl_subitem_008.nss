// pl_subitem_002
#include "gsp_func_inc"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();  //Which event triggered this
    if(nEvent != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();        // The player who activated the item
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if(oArmor == OBJECT_INVALID){
        ErrorMessage(oPC, "You must be wearing armor to use this item!");
        return;
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDexDec = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);

    effect eLink = EffectLinkEffects(eDur, eDexDec);

    ApplyVisualToObject(VFX_COM_CHUNK_STONE_MEDIUM, oPC);
    AddOnHitSpellToWeapon(oArmor, IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD, 40, 120.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 120.0f);
}
