// The following is a list of possible alignment shifts that can be used.
// Note:  If option "5" is used, it shifts both the PC's CHAOS/LAW and
// GOOD/EVIL alignment subdomains more toward neutrality.
// Note:  All alignment shifts affect every PC in a multiplayer party.  Keep
// this in mind as you implement alignment shifts based on PC actions.
////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    // 1 = Chaotic
    // 2 = Lawful
    // 3 = Evil
    // 4 = Good
    // 5 = Neutral
    // 6 = Lawful Good
    // 7 = Lawful Evil
    // 8 = Chaotic Good
    // 9 = Chaotic Evil
    ////////////////////////////////////////////////////////////////////////////

#include "quest_func_inc"

void main(){
    object oPC = GetPCSpeaker();
    string szPlotID = GetLocalString(OBJECT_SELF, "quest"); // Quest Identifier
    int nQuestStatus = GetLocalInt(oPC,"NW_JOURNAL_ENTRY_" + szPlotID);
    int nShiftType = GetLocalInt(OBJECT_SELF, "quest_" + IntToString(nQuestStatus) + "_shift_align");
    int nShiftAmount = GetLocalInt(OBJECT_SELF, "quest_" + IntToString(nQuestStatus) + "_shift_amount");
    int nShift1, nShift2, bParty = GetLocalInt(OBJECT_SELF, "quest_" + IntToString(nQuestStatus) + "_reward_party");


    // Check that player still has reqs, if not exit... set local variable to
    // prevent quest item dropping exploits... The player will not be able to
    // complete the quest legitemately until the server resets...
    if(!QuestHasReqs(OBJECT_SELF, oPC)){
        SetLocalInt(oPC, szPlotID + "_anticheat", TRUE);
        return;
    }
    // Take quest requirements...
    QuestTakeReqs(OBJECT_SELF, oPC);
    // Give reward...
    QuestGiveRewards(OBJECT_SELF, oPC, bParty);

    // Set up the alignment to be shifted based on the above table
    switch(nShiftType){
        case 1: nShift1 = ALIGNMENT_CHAOTIC; break;
        case 2: nShift1 = ALIGNMENT_LAWFUL;  break;
        case 3: nShift1 = ALIGNMENT_EVIL;    break;
        case 4: nShift1 = ALIGNMENT_GOOD;    break;
        case 5: nShift1 = ALIGNMENT_NEUTRAL; break;
        case 6: nShift1 = ALIGNMENT_LAWFUL;  nShift2 = ALIGNMENT_GOOD; break;
        case 7: nShift1 = ALIGNMENT_LAWFUL;  nShift2 = ALIGNMENT_EVIL; break;
        case 8: nShift1 = ALIGNMENT_CHAOTIC; nShift2 = ALIGNMENT_GOOD; break;
        case 9: nShift1 = ALIGNMENT_CHAOTIC; nShift2 = ALIGNMENT_EVIL; break;
    }

    // Perform desired alignment shift
    if (nShift1 != 0) AdjustAlignment(oPC, nShift1, nShiftAmount, bParty);
    if (nShift2 != 0) AdjustAlignment(oPC, nShift2, nShiftAmount, bParty);
}
