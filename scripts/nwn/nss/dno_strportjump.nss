int GetIsPCInArea(object oArea)
{
    if( !GetIsObjectValid(oArea) || (GetArea(oArea) != oArea)) return FALSE;

object oInArea = GetFirstObjectInArea( oArea);
    if( !GetIsObjectValid(oInArea)) return FALSE;
    if( GetIsPC(oInArea)) return TRUE;
return GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oInArea));
}

void PortalOff(object oArea)
{
if (!GetIsObjectValid(oArea) || (GetArea(oArea) != oArea) || GetIsPCInArea(oArea)) return;

object oSwitch = GetObjectByTag("dno_Port_Switch_1");
object oTarget = GetObjectByTag("dno_inv_Portal_6");
object oPortal = OBJECT_SELF; //GetObjectByTag("dno_Portal_044_1");


AssignCommand(oSwitch, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

effect eTarget = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eTarget))
    {
    if (GetEffectDurationType(eTarget) == DURATION_TYPE_PERMANENT)
    {
    RemoveEffect(oTarget, eTarget);
    }
    eTarget = GetNextEffect(oTarget);

int nActive = GetLocalInt (oSwitch,"X2_L_PLC_ACTIVATED_STATE");

SetLocalInt(oSwitch,"X2_L_PLC_ACTIVATED_STATE",!nActive);

SetUseableFlag(oPortal, FALSE);
}
}

void main()
{

object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC)) return;



object oKey1 = GetItemPossessedBy(oPC, "dno_Drag_Port1");
        if (!GetIsObjectValid(oKey1)) return;



object oWP1 = GetWaypointByTag("dno_WP_StrPort_1");

AssignCommand(oPC, ClearAllActions(FALSE));

AssignCommand(oPC, ActionJumpToObject(oWP1));

object oArea = GetObjectByTag("dno_Area_044");

DelayCommand(10.0, PortalOff(oArea));



}
