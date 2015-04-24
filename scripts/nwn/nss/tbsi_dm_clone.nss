//  tbsi_dm_clone
////////////////////////////////////////////////////////////////////////////////
// Created by:   The Krit
// Created on:   04-03-2010
// Modified by:  Genisys / Guile
// Modified on:  04-30-2011
///////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------------------------------------
//Required Include (DO NOT TOUCH!)
#include "x2_inc_switches"
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// oItem was acquired (by a PC or an NPC).
// Run by the module.
void OnAcquire(object oItem, object oAcquiredBy, object oTakenFrom, int nStackSize)
{
    // Enter code to execute when this event happens
}


// -----------------------------------------------------------------------------
// oItem was activated ("activate item" or "unique power").
// Run by the module.
void OnActivate(object oItem, object oActTarget, location lActTarget, object oActivator)
{
  object oTarget = oActTarget;
  if(!GetIsPC(oTarget) && !GetIsDM(oTarget) &&
     GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
  CopyObject(oTarget, GetLocation(oTarget));
  CopyObject(oTarget, GetLocation(oTarget));}
  else
  {
   FloatingTextStringOnCreature("You must target a creature, not a pc or dm!",
   oActivator, FALSE);
  }
}


// -----------------------------------------------------------------------------
// oItem was equipped by a PC.
// Run by the module.
void OnEquip(object oItem, object oEquippedBy)
{
    // Enter code to execute when this event happens
}


// -----------------------------------------------------------------------------
// oItem is a weapon that just hit a target, or it is the armor of someone who
// was just hit by someone else's weapon.
// Run by the caster.
void OnHit(object oItem, object oHitTarget, object oCaster)
{
    // Enter code to execute when this event happens
}


// -----------------------------------------------------------------------------
// Someone cast a spell at oItem.

// Run by the caster.
int OnSpellCast(object oItem, int nSpell, object oCaster)
{
   // Enter code to execute when this event happens

   return FALSE; //Necessary return (Do this !)
}


// -----------------------------------------------------------------------------
// oItem was unacquired/lost (by a PC or NPC).
// Run by the module.
void OnUnacquire(object oItem, object oLostBy)
{
    // Enter code to execute when this event happens
}


// -----------------------------------------------------------------------------
// oItem was unequipped by a PC.
// Run by the module.
void OnUnequip(object oItem, object oUnequippedBy)
{
    // Enter code to execute when this event happens
}


//////////////////////////////////////////////////////////////////////////////
// ##### WARNINING:: DON'T TOUCH ANYTHING BELOW THIS LINE!!! #### ///////////
////////////////////////////////////////////////////////////////////////////

// The main function.
void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // Spells might continue to their spell scripts. All other events are
    // completely handled by this script.
    if ( nEvent != X2_ITEM_EVENT_SPELLCAST_AT )
        SetExecutedScriptReturnValue();

    // Determine which event triggered this script's execution.
    switch ( nEvent )
    {
        // Item was acquired.
        case X2_ITEM_EVENT_ACQUIRE:
                OnAcquire(GetModuleItemAcquired(), GetModuleItemAcquiredBy(),
                          GetModuleItemAcquiredFrom(), GetModuleItemAcquiredStackSize());
                break;

        // Item was activated ("activate item" or "unique power").
        case X2_ITEM_EVENT_ACTIVATE:
                OnActivate(GetItemActivated(), GetItemActivatedTarget(),
                           GetItemActivatedTargetLocation(), GetItemActivator());
                break;

        // Item was equipped by a PC.
        case X2_ITEM_EVENT_EQUIP:
                OnEquip(GetPCItemLastEquipped(), GetPCItemLastEquippedBy());
                break;

        // Item is a weapon that just hit a target, or it is the armor of someone
        // who was just hit.
        case X2_ITEM_EVENT_ONHITCAST:
                OnHit(GetSpellCastItem(), GetSpellTargetObject(), OBJECT_SELF);
                break;

        // A PC (or certain NPCs) cast a spell at the item.
        case X2_ITEM_EVENT_SPELLCAST_AT:
                if ( OnSpellCast(GetSpellTargetObject(), GetSpellId(), OBJECT_SELF) )
                    SetExecutedScriptReturnValue();
                break;

        // Item was unacquired.
        case X2_ITEM_EVENT_UNACQUIRE:
                OnUnacquire(GetModuleItemLost(), GetModuleItemLostBy());
                break;

        // Item was unequipped by a PC.
        case X2_ITEM_EVENT_UNEQUIP:
                OnUnequip(GetPCItemLastUnequipped(), GetPCItemLastUnequippedBy());
                break;
    }
}

