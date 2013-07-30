#include "quest_func_inc"

void main(){

    object oWater, oFire, oEarth, oAir, oRing;
    object oMod = GetModule(), oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest");
    int nQuestStatus = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + szPlotID);

    oWater = GetItemPossessedBy(oPC, "ep_crystal_water");
    oFire = GetItemPossessedBy(oPC, "ep_crystal_fire");
    oEarth = GetItemPossessedBy(oPC, "ep_crystal_earth");
    oAir = GetItemPossessedBy(oPC, "ep_crystal_air");

    if(oWater == OBJECT_INVALID ||
       oFire  == OBJECT_INVALID ||
       oEarth == OBJECT_INVALID ||
       oAir   == OBJECT_INVALID)
    {
        SpeakString("You don't have the four items!");
        return;
    }
    SetPlotFlag(oWater, FALSE);
    DestroyObject(oWater, 0.2);
    SetPlotFlag(oFire, FALSE);
    DestroyObject(oFire, 0.2);
    SetPlotFlag(oEarth, FALSE);
    DestroyObject(oEarth, 0.2);
    SetPlotFlag(oAir, FALSE);
    DestroyObject(oAir, 0.2);


    oRing = GetItemPossessedBy(oPC, "pl_ring_elements");
    if(oRing == OBJECT_INVALID)
        CreateItemOnObject("pl_ring_elements", oPC);


    //AddPersistentJournalQuestEntry(szPlotID, nQuestStatus+1, oPC, TRUE, FALSE, FALSE);
    AddPersistentJournalQuestEntry(szPlotID, 2, oPC, FALSE, FALSE, FALSE);
    SetLocalInt(oMod, "NW_JOURNAL_ENTRY" + szPlotID, 2);
}
