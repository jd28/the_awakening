#include "inc_draw"
#include "quest_func_inc"

void main(){
    if(GetLocalInt(OBJECT_SELF, "Deactivated"))
        return;

    object oPC = GetLastUsedBy();
    object oItem = GetItemPossessedBy(oPC, "pl_azurax_gem");
    if(oItem == OBJECT_INVALID){
        SpeakString("You see a indentation on the top of the device.");
        return;
    }


    QuestAdvance(OBJECT_SELF, oPC, 2);

    string sTag;
    SetLocalInt(OBJECT_SELF, "Deactivated", 1);

    //SpeakString("Attempting to destroy cage.");

    object oCage = GetFirstObjectInArea(OBJECT_SELF);
    while (oCage != OBJECT_INVALID){
        sTag = GetTag(oCage);
        //SpeakString(sTag);
        if (GetStringLeft(sTag, 4) == "PSC_") {
            GroupDestroyObject(oCage);
        }
        oCage = GetNextObjectInArea(OBJECT_SELF);
    }
}
