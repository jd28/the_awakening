//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: sfpb_config
//:://////////////////////////////////////////////
/*
    Written By Scarface
    Modified to be a universal Persistent bank/donation box
    System and use APS/NWNX DB.  It can handle XP, Gold,
    Generic Items, the normal persistent chests, and a
    persistent donation box.
*/
//////////////////////////////////////////////////

//#include "nwnx_inc"
#include "fky_chat_inc"

const int UPB_WELCOME = 0;
const int UPB_ENTER_VALUE = 1;
const int UPB_CONFIRM_ACTION = 2;
const int UPB_FINISH = 3;
const int UPB_AMOUNT_CTOKEN = 1000;
const int UPB_ACTION_CTOKEN = 1001;


// Do you want players to be able to share items and gold
// between their own characters....
// If this is set TRUE, then players will be able to retrieve
// their items and gold with any of their own characters, if set
// FALSE, then they will only be able to retrieve items or gold
// that were saved on particular characters.
const int CHARACTER_SHARING = TRUE;

// Set the maximum amount of items allowed to be stored
// per player. I strongly recommend setting this no higher
// than 100. I cannot garuntee the system will function without
// any ill effects if you exceed this.
const int MAX_ITEMS = 50;

////////////////////////////////////////////////////////////////////////////////
// DO NOT TOUCH ANY FUNCTIONS OR CONSANTS BELOW THIS LINE!!!!!!!
////////////////////////////////////////////////////////////////////////////////

const string DATABASE_GOLD = "UPB_GOLD";
const string DATABASE_ITEM = "SFPB_ITEM_";
const string DATABASE_GENERIC = "SFPB_";
const string DATABASE_XP = "SFPB_XP_";
const string DATABASE_DONATION_BOX = "PDB_ITEM_";
