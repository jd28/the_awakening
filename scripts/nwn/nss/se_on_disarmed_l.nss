//::////////////////////////////////////////////////////////////////////////////
//:: Name XP award on disarm of trap
//:: FileName se_on_disarmed_l v2.7
//:: Copyright (c) 2006 Melnibone Corp.
//::////////////////////////////////////////////////////////////////////////////
/*
    - Basic OnDisarm award XP script(location traps).
    - Award XP to the disarmer/recoverer based on the disarm DC
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created By : Sir Elric
//:: Created On : 19th June, 2006
//:: Modified On: 19th December, 2007
//:: Event Used : OnDisarm
//:: Patch      : 1.67 or above required
//::////////////////////////////////////////////////////////////////////////////

#include "se_inc_resp_trap"

void main()
{
   object oSelf = OBJECT_SELF;

   // If set to false there is no disarm xp reward
   if(SE_DISARM_XP_ACTIVE == FALSE) return;

   // find the spawner object or the location waypoint
   object oSpawner = GetNearestObjectByTag("INVIS_TRAP_SPAWNER", oSelf);
   if(!GetIsObjectValid(oSpawner) || GetDistanceBetween(oSelf, oSpawner) > 1.0f)
   {
      oSpawner = GetNearestObjectByTag("RANDOM_GROUND_TRAP_LOCATION", oSelf);
   }

   int nXP;
   object oTrapCreator = GetTrapCreator(oSelf);
   object oPC = GetLastDisarmed();

   if(GetIsPC(oPC) == FALSE) return;

   if(SE_DISARM_XP_ROGUE_ONLY)
   {
      // If disarmed via the Find Trap spell no xp award
      if(GetLocalInt(oSelf, "DISARMED_BY_SPELL") == TRUE)
      {
         SE_Debug("Disarmed by Find Trap spell. No Disarm XP awarded.");
         SetLocalInt(oSelf, "DISARMED_BY_SPELL", FALSE);
         return;
      }

      // Only reward Rogues
      if(GetLevelByClass(CLASS_TYPE_ROGUE, oPC) == 0)
      {
         SE_Debug("Must have at least 1 level of Rogue to receive disarm XP or 2 levels if multiclass."
              + " No Disarm XP awarded.");

         return;
      }
   }

   // Create a unique ID for the disarmer
   string sID = GetPCPlayerName(oPC) + GetName(oPC);

   // Check the disarmer hasn't done this one before
   if(SE_DISARM_XP_ONCE_ONLY == FALSE || GetLocalString(oSpawner, "DISARMED_BY_THIS_PC") != sID)
   {
         if(GetIsPC(oPC) && !GetIsPC(oTrapCreator))
         {
            nXP = GetTrapDisarmDC(oSelf);
            nXP *= SE_DISARM_XP_MULTIPLIER;
            nXP /= SE_DISARM_XP_DIVIDER;
            GiveXPToCreature(oPC, nXP);

            // Set this object as having awarded the current disarmer
            if(SE_DISARM_XP_ONCE_ONLY == TRUE)
            SetLocalString(oSpawner, "DISARMED_BY_THIS_PC", sID);

            FloatingTextStringOnCreature(IntToString(nXP)
                + " XP awarded for disarming this trap", oPC, TRUE);
         }
         else
         {
            SE_Debug("PC set trap. No disarm XP awarded.");
         }
   }
   else
   {
         SE_Debug("You only get XP once from each location trap. No Disarm XP awarded.");
   }
}
