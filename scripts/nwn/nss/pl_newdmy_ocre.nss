#include "mod_funcs_inc"

// The original function in all its glory. It is here because it is
// commented in later versions of the game, but still useful.

void ClearAllFactionMembers(object oMember, object oPlayer)
{
    AdjustReputation(oPlayer, oMember, 100);

    // Clear all faction members' reputations
    object oClear = GetFirstFactionMember(oMember, FALSE);
    while (GetIsObjectValid(oClear) == TRUE)
    {
        ClearPersonalReputation(oPlayer, oClear);
        oClear = GetNextFactionMember(oMember, FALSE);
    }
}

void main() {
	int n = IncrementLocalInt(OBJECT_SELF, "DummyRound");

	if (n >= 2) {
		object oLeader = GetNearestObjectByTag("pl_strongman_leadboard");
		object oPC = GetLocalObject(OBJECT_SELF,"PLC_INTERACT_USER");
		int nHitCount = GetLocalInt(OBJECT_SELF,"PLC_INTERACT_HITCOUNT");
		int nTotalDamage = GetLocalInt(OBJECT_SELF, "PLC_INTERACT_TOTAL");
		int nHighest = GetLocalInt(OBJECT_SELF, "PLC_INTERACT_HIGHEST");
		int nAvgDamage = nTotalDamage / nHitCount, bGood;

		string sMessage, sPlayer;
		sMessage = "Total Damage: " + IntToString(nTotalDamage) + "\n";
		sMessage += "Hits: " + IntToString(nHitCount) + "\n";
		if(nHitCount > 0)
			sMessage += "Average Damage per Hit: " + IntToString(nAvgDamage) + "\n";
		sMessage += "Hardest Hit: " + IntToString(nHighest);
		sPlayer = GetName(oPC)+ " ("+GetPCPlayerName(oPC)+")";


		ClearAllFactionMembers(OBJECT_SELF, oPC);
		DestroyObject(OBJECT_SELF);
		//AssignCommand(GetModule(),DelayCommand(4.0, DummyReactive()));
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oDummy)))
		AssignCommand(GetModule(),DelayCommand(4.0,FloatingTextStringOnCreature(sMessage, oPC)));
	}
}
