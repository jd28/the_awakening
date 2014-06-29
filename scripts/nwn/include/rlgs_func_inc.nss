#include "pc_funcs_inc"
#include "vfx_inc"
//#include "nwnx_inc"



void RLGSGenerateLoot(struct rlgs_info ri);
void RLGS_Generate_SS_Loot(struct rlgs_info ri, object oChest, int nChance, int nAttempts, int nDenominator);

void RLGSGenerateLoot(struct rlgs_info ri){

    int nChance, nRoll, nSubString, nAttempts, nDenominator, nHD, nQuality, nOdds;
    int nPlayers = GetLocalInt(GetArea(ri.oHolder), VAR_AREA_OCCUPIED);
    int nObjectType = GetObjectType(ri.oHolder);
    string sChest, sCode;
    object oChest, oItem;

    ri.nRange = GetLocalInt(GetArea(ri.oContainer), RLGS_RANGE);

    // Sonic Soul Loot Merchants
    int nCount = 1;
    sChest = GetLocalString(ri.oHolder, RLGS_SS + IntToString(nCount));

    while (sChest != ""){
        nSubString = FindSubString(sChest, ":");
        if(nSubString != -1){
            sCode = GetStringRight(sChest, GetStringLength(sChest) - (nSubString + 1));
            sChest = GetStringLeft(sChest, nSubString);
            nChance = StringToInt(GetStringLeft(sCode,3));
            nAttempts = StringToInt(GetStringRight(sCode,3));
        }
        else{
            nChance = RLGS_DEFAULT_CHANCE + (nPlayers * 3);
            nAttempts = RLGS_DEFAULT_ATTEMPTS;
        }

        // If there is a specified denominator use it, if not 100.
        nDenominator = GetLocalInt(ri.oContainer, RLGS_SS + IntToString(nCount));
        if (nDenominator == 0) nDenominator = 100; // This defaults to 100

        //Make sure chest exists.
        oChest = GetObjectByTag(sChest);
        if(GetIsObjectValid(oChest))
            RLGS_Generate_SS_Loot(ri, oChest, nChance, nAttempts, nDenominator);

        nCount++;
        sChest = GetLocalString(ri.oContainer, RLGS_SS + IntToString(nCount));
    }

    // Do Static Items
    nCount = 1;

    if (nObjectType == OBJECT_TYPE_CREATURE)
        ri.oHolder = ri.oContainer;

    string sResref = GetLocalString(ri.oHolder, RLGS_ITEM + IntToString(nCount));
    int nStack;
    int nPartyMod = GetLocalInt(ri.oHolder, RLGS_PARTY_MOD);

    while (sResref != ""){
        nChance = GetLocalInt(ri.oHolder, RLGS_ITEM + IntToString(nCount));
        nStack = nChance / 1000;
        if(nStack == 0) nStack = 1;

        nChance = nChance % 1000;

        if(nChance == 0)
            nChance = 100;
        if(nPartyMod == 0)
            nPartyMod = 5;

        nChance += (nPlayers * nPartyMod);

        //Logger(ri.oPC, "DebugLoot", LOGLEVEL_DEBUG, "Item: %s, Resref: %s, Chance: %s, Stack: %s, Party Mod: %s",
        //    IntToString(nCount), sResref, IntToString(nChance), IntToString(nStack), IntToString(nPlayers * nPartyMod));

        if(Random(100)+1 <= nChance){
            oItem = CreateItemOnObject(sResref, ri.oContainer, nStack);
            if(ri.nRange > RLGS_RANGE_NONE)
                SetIdentified(oItem, FALSE);
        }

        nCount++;
        sResref = GetLocalString(ri.oHolder, RLGS_ITEM + IntToString(nCount));
    }

    //Generate Gold Coins.  Random based on RLGS Level gold non Monsters containers.
    int nGold = GetLocalInt(ri.oHolder, RLGS_GOLD);
    if (nObjectType != OBJECT_TYPE_CREATURE){
        if(ri.nRange >= RLGS_RANGE_5)
            nGold += d20(100);
        else if(ri.nRange >= RLGS_RANGE_4)
            nGold += d20(75);
        else if(ri.nRange >= RLGS_RANGE_3)
            nGold += d20(50);
        else if(ri.nRange >= RLGS_RANGE_2)
            nGold += d20(25);
        else if(ri.nRange >= RLGS_RANGE_1)
            nGold += d20(10);
        else
            nGold += d20();

        CreateItemOnObject("nw_it_gold001", ri.oContainer, nGold);
    }
    else GiveGoldToCreature(ri.oContainer, nGold);
/*
    if(d100() <= GetLocalInt(ri.oHolder, "rlgs_spirit_shard")){
        CreateItemOnObject("pl_spirit_shard", ri.oContainer);
        Logger(ri.oPC, "DebugLoot", LOGLEVEL_DEBUG, "Spirit Shard Dropped: %s",
            GetTag(ri.oHolder));
    }
*/        

    //DestroyObject(ri.oContainer, 0.2);
}

void RLGS_Generate_SS_Loot(struct rlgs_info ri, object oChest, int nChance, int nAttempts, int nDenominator){
    int nCount, nRoll;
    object oItem, oCopy;

    // Count all Items in Inventory
    nCount = CountItemsInInventory(oChest);
    if(nCount == 0 || nAttempts <= 0) return;

    //Logger(ri.oPC, "DebugLoot", LOGLEVEL_DEBUG, "Chest: %s, Denominator: %s, Chance: %s, Attempts: %s",
    //    GetTag(oChest), IntToString(nDenominator), IntToString(nChance), IntToString(nAttempts));

    while (nAttempts > 0){
        nRoll = (Random(nDenominator) + 1); //roll chance

        if (nRoll <= nChance){ //Success
            nRoll = (Random(nCount) + 1); //roll random item position
            oItem = GetFirstItemInInventory(oChest);
            if (nRoll > 1){ // If not the first item, loop and find it.
                for (nCount = 2; nCount <= nRoll; nCount++){
                    oItem = GetNextItemInInventory(oChest);
                }
            }
            //Create item
            oCopy = CopyItem(oItem, ri.oContainer, TRUE);

            //If chest is "Finite" destroy the object and decrement inventory count.
            //Only one attempt on finite chests, due to not
            if (GetLocalInt(oChest, "finite") > 0 ){
                DestroyObject(oItem, 0.01);
                return;
            }
            if(GetBaseItemType(oCopy) != BASE_ITEM_GEM)
                SetIdentified(oCopy, FALSE);
        }
        nAttempts--;
    }
}
