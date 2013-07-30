#include "quest_func_inc"

void main()
{
    object oPC = GetPCSpeaker();
    string sPrize = "pl_elf_brooch";
    string sLetter = "pl_drowslave_let";
    int nGold = 1000000, nXP = 50000;

    object oLetter = GetItemPossessedBy(oPC, sLetter);
    if(oLetter == OBJECT_INVALID){
        SpeakString("You have no letter!");
        return;
    }
    SetPlotFlag(oLetter, FALSE);
    DestroyObject(oLetter);

    QuestAdvance(OBJECT_SELF, oPC, 4);

    CreateItemOnObject(sPrize, oPC);
    GiveGoldToCreature(oPC, nGold);
    GiveTakeXP(oPC, nXP);
}
