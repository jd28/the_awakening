#include "pc_funcs_inc"

void main(){
    object oPC = GetPCSpeaker();
    int nCode = GetLocalInt(OBJECT_SELF,"MODCODE"), nGold, nXP;
    string sResref;

    int nAmount = nCode % 100;
    nCode /= 100;

    switch(nCode){
        case 1: // Cat's Grace
            sResref = "nw_it_mpotion014";
            nGold = 60;
            nXP = 5;
        break;
        case 2: // Divine Power
            sResref = "pl_p_divine_powe";
            nGold = 5000;
            nXP = 50;
        break;
        case 3: // Shadow Shield
            sResref = "pl_p_shad_shield";
            nGold = 10000;
            nXP = 100;
        break;
        default: // Eagle Splendor
            sResref = "nw_it_mpotion010";
            nGold = 60;
            nXP = 5;
    }

    switch(nAmount){
        case 1: nAmount = 10; break;
        case 2: nAmount = 25; break;
        case 3: nAmount = 50; break;
        case 4: nAmount = 100; break;
        default: nAmount = 1;
    }

    // Check to see if we have the xp and gold needed
    nGold *= nAmount;
    nXP *= nAmount;

    if((GetXP(oPC) - GetXPByLevel(GetHitDice(oPC))) < nXP){
        FloatingTextStringOnCreature(C_RED+"You don't have " + IntToString(nXP) + " above what you need for your current level.", oPC, FALSE);
        return;
    }
    else if(GetGold(oPC) < nGold){
        FloatingTextStringOnCreature(C_RED+"You don't have " + IntToString(nGold) + " gold pieces.", oPC, FALSE);
        return;
    }

    TakeGoldFromCreature(nGold, oPC, TRUE);
    GiveTakeXP(oPC, -nXP);

    object oPotions = CreateItemOnObject(sResref, oPC, nAmount);
}
