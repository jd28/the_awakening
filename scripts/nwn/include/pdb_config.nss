//::///////////////////////////////////////////////
//:: Scarface's Persistent Banking
//:: pdb_config
//:://////////////////////////////////////////////
/*
    Written By Scarface
    Edited By pope_leo for persistent donation box
*/
//////////////////////////////////////////////////

/* WARNING!!!!! Please Read...

   If any changes are made to this script, you must
   use the "Build Module" option in toolset and check
   the "Scripts" box in order to compile (build) all
   scripts, failing to do so will result in any changes
   in thi sscript being overwritten back to its original
   state.....
*/

// Set the maximum amount of items allowed to be stored
// per player. I strongly recommend setting this no higher
// than 100. I cannot garuntee the system will function without
// any ill effects if you exceed this.
const int MAX_ITEMS = 100;

//////////////////////////////////////////////////
const string DATABASE_ITEM = "PDB_ITEM_";
