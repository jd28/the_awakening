///////////////////////////////////
//: dno_at_uniportals
//: Universal Placed Portal Transition.
//: .
/////////////////////////////
//: K9-69 ;o)
/////////////
#include "nw_i0_tool"
void main()
{

    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;


string sSelf = GetTag(OBJECT_SELF);
string sDest = "DST_";

    object oTarget;
   location lTarget;
        oTarget = GetWaypointByTag( sDest + sSelf );
       lTarget = GetLocation(oTarget);

   if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;



AssignCommand(oPC, ClearAllActions());

DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

//int nInt;
//nInt = GetObjectType(oTarget);

//if (nInt != OBJECT_TYPE_WAYPOINT)


ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
//else ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));

}
