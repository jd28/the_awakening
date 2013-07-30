//::///////////////////////////////////////////////
//:: Title : Open a Store (based on the tag of the NPC and the store objects)
//:: Author: Michael Marzilli
//:: Module: PVP Warzone!
//:: Date  : Aug 01, 2005
//:: Vers  : 1.0
//:://////////////////////////////////////////////

// Set the Tag of the NPC Merchant to the tag of the store that you want
// them to open.  This script opens the Store Object which has the same
// Tag as the NPC trying to open the store.

void main() {
  object oPC    = GetPCSpeaker();
  string sName  = GetTag(OBJECT_SELF);
  object oStore = GetNearestObjectByTag(sName);

  OpenStore(oStore, oPC);

}

