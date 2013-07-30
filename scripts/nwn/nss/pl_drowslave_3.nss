#include "quest_func_inc"

void main()
{
    object oPC = GetPCSpeaker();
    string sLetter = "pl_drowslave_let";
    string sKey = "pl_drowslave_key";

    if(!QuestDestroyItem(oPC, sKey)){
        SpeakString("You don't have the key!");
        return;
    }
    QuestAdvance(OBJECT_SELF, oPC, 3);
    CreateItemOnObject(sLetter, oPC);
}
