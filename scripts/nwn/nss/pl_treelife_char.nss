#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker(),
           oBranch = GetItemPossessedBy(oPC, "pl_branch_life");

    int nGold = GetGold(oPC),
        nXP = GetXP(oPC);

    if(oBranch == OBJECT_INVALID){
        SpeakString("You don't have a Branch of Life!");
        return;
    }
    else if(nGold < 5000000){
        SpeakString("You don't have 5,000,000 gold!");
        return;
    }
    else if ( nXP <= 30000 ) {
        SpeakString("You don't have 30,000xp in excess of what is required for your current level!");
        return;
    }

    TakeGoldFromCreature(5000000, oPC, TRUE);
    GiveTakeXP(oPC, -30000);

    SetLocalInt(oBranch, "PL_BRANCH_CHARGES", 1);
    SpeakString("Your Branch has been charged.");
}
