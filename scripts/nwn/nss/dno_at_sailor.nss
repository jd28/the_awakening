///////////////////////////////////
//: dno_at_sailor
//: Increase Int sailordeaths by 1 for each kill.
//: force JumpTo if death count =3.
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
location lTarget;
object oTarget;

void main()
{

object oPC = GetLastKiller();

while (GetIsObjectValid(GetMaster(oPC)))
   {
   oPC=GetMaster(oPC);
   }

if (!GetIsPC(oPC)) return;

int nInt;
nInt = GetLocalInt(oPC, "sailordeaths");

nInt += 1;

SetLocalInt(oPC, "sailordeaths", nInt);

if (GetLocalInt(oPC, "sailordeaths")== 1)
   {

   AssignCommand(oPC, PlayVoiceChat(VOICE_CHAT_CUSS));
   FloatingTextStringOnCreature("That's one uneccesary death. This is supposed to be a stealth mission.", oPC);

   }
if (GetLocalInt(oPC, "sailordeaths")== 2)
   {

   AssignCommand(oPC, PlayVoiceChat(VOICE_CHAT_CUSS));
   FloatingTextStringOnCreature("Thats two uneccesary deaths. One more and it's abandon mission.", oPC);

   }
if (GetLocalInt(oPC, "sailordeaths")>= 3)
   {

   AssignCommand(oPC, PlayVoiceChat(VOICE_CHAT_CUSS));
   FloatingTextStringOnCreature("You was Warned, this was supposed to be a stealthy kill.", oPC);
   FloatingTextStringOnCreature("The Guild Token is emanating warmth from it's magically triggered teleport.", oPC);

   oTarget = GetWaypointByTag("dno_WP_AT_001_005");

   lTarget = GetLocation(oTarget);


   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

   oTarget=GetFirstFactionMember(oPC, FALSE);

   while (GetIsObjectValid(oTarget))
      {

      AssignCommand(oTarget, ClearAllActions());

      DelayCommand(3.0, AssignCommand(oTarget, ActionJumpToLocation(lTarget)));


      oTarget=GetNextFactionMember(oPC, FALSE);



}
}
}

