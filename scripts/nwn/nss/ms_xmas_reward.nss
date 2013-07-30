#include "quest_func_inc"
void main(){
    object oPC = GetPCSpeaker();
    object oRing = GetItemPossessedBy(oPC, "pl_iceelf_ring");
    object oBowl = GetItemPossessedBy(oPC, "ep_crystal_water");

    if( oRing == OBJECT_INVALID ||
        oBowl == OBJECT_INVALID){

       SpeakString("Oh, no.  You must have dropped them...  Christmas is ruined!!");
       return;
    }
    DestroyObject(oRing);
    DestroyObject(oBowl);
    SpeakString("Ho Ho Ho!  Christmas is saved!");
    CreateItemOnObject("ms_ringofchristm", oPC);
    QuestAdvance(OBJECT_SELF, oPC, 2);
}
