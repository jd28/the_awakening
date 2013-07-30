#include "quest_func_inc"
#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC, "pl_jerry_talon");

    if(oItem == OBJECT_INVALID){
        SpeakString("You no have talon!");
        return;
    }

    DestroyObject(oItem);
    CreateItemOnObject("pl_farmhand_boot", oPC);
    GiveTakeXP(oPC, 100, TRUE, TRUE);

    QuestAdvance(OBJECT_SELF, oPC, 2);
}
