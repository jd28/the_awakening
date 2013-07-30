//:://////////////////////////////////////////////////
//:: NW_C2_DEFAULT7
/*
  Default OnDeath event handler for NPCs.

  Adjusts killer's alignment if appropriate and
  alerts allies to our death.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/22/2002
//:://////////////////////////////////////////////////

#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "rlgs_func_inc"

void main()
{
    object oKiller = GetLastKiller();

    // Scarface's XP/GP System
    ExecuteScript("mod_xp_system", OBJECT_SELF);
    // End
/*
    //RLGS Loot...
    struct rlgs_info ri;

    ri.oContainer = CreateObject(OBJECT_TYPE_PLACEABLE, "rlgs_loot_bag", GetLocation(OBJECT_SELF));
    if(!GetIsObjectValid(ri.oContainer)) return;

    ri.oHolder = OBJECT_SELF;
    ri.oPC = OBJECT_INVALID;

    DelayCommand(0.5f, RLGSGenerateLoot(ri));
*/

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // NOTE: the OnDeath user-defined event does not
    // trigger reliably and should probably be removed
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
         SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
    //craft_drop_items(oKiller);
}
