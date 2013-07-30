#include "vfx_inc"
#include "item_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nCost = 30000000;
    int nGold = GetGold(oPC);

    if(nGold < nCost){
        SpeakString("Ye ain't got the gold!");
        return;
    }

    if(GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) < 30){
        SpeakString("Ye ain't strong enough! Ye need 30 base strength to use this.");
        return;
    }

    if(GetResRef(oArmor) != "pl_fafnir_arhvy"){
        SpeakString("Ye ain't got Fafnir's Armor");
        return;
    }

    object oQuest = GetItemPossessedBy(oPC, "ms_sv_mithril");
    if(oQuest == OBJECT_INVALID){
        SpeakString("Ye ain't got mithril ore!");
        return;
    }
    // Set strength restriction
    SetLocalString(oArmor, "ilr_ability", IntToString(ABILITY_STRENGTH+1) + ":30");

    DestroyObject(oQuest);
    DestroyObject(oArmor);
    TakeGoldFromCreature(nCost, oPC, TRUE);
    CreateItemOnObject("pl_fafnir_arhv2", oPC);

    ApplyVisualToObject(VFX_IMP_FLAME_M, oPC);
    SpeakString("There ye be.");
}
