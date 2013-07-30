void main()
{

object oPC = GetLastHostileActor();

if (!GetIsPC(oPC)) return;

object oTarget;
oTarget = GetObjectByTag("nr_raven");

AssignCommand(oTarget, ActionSpeakString("Nevermore!"));

}

