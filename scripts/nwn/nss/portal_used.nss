//----------------------------------------------------------------------
//  File: portal_used
//
//  Description: Ports PC to whatever waypoint is stored in the portal's
//      "WAYPOINT" variable, if "COMBAT" variable is 1 PC will not be
//      able to port in combat, if the "EFFECT" variable is -1 the PC won't
//      see any port effect, else it will apply whatever effect constant
//      it contains (Unsummon is 99).
//
//  Originally written 4/25/08 by Josh Dean (pope_leo) w/ Lilac Soul
//      Script Generator
//----------------------------------------------------------------------

void main(){

    int DEBUG = 0;
    object oPC = GetLastUsedBy(), oPortal = OBJECT_SELF;
    string sWaypoint = GetLocalString(oPortal, "WAYPOINT");

    if (!GetIsPC(oPC)) return;

    if(DEBUG){
        SendMessageToPC(oPC, "Your destination is " + sWaypoint + ".");
    }

    //Check for combat
    if (GetLocalInt(oPortal, "COMBAT") && GetIsInCombat(oPC)){
        SendMessageToPC(oPC, "You are unable to port in combat.");
        return;
    }

    object oWaypoint = GetWaypointByTag(sWaypoint);
    location lWaypoint = GetLocation(oWaypoint);

    //Check for valid location
    if (GetAreaFromLocation(lWaypoint)==OBJECT_INVALID){
        SendMessageToPC(oPC, "Destination is Invalid.");
        return;
    }

    //Port PC
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lWaypoint)));

    //Apply whatever visual effect, if any.
    int nVFX = GetLocalInt(oPortal, "EFFECT");
    if(nVFX >= 0){
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), oPC);
    }
}
