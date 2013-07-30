#include "quest_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    object oStaff = GetItemPossessedBy(oPC, "pl_azurax_gem");
    if(oStaff == OBJECT_INVALID){
        SpeakString("You do not have the staff!");
        return;
    }
    QuestAdvance(OBJECT_SELF, oPC, 3);

    DestroyObject(oStaff);
    object oBranch = GetItemPossessedBy(oPC, "pl_branch_life");
    if(oBranch == OBJECT_INVALID)
        oBranch = CreateItemOnObject("pl_branch_life", oPC);

    SetLocalInt(oBranch, "QuestComplete", TRUE);

}
