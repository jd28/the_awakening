void main()
{
string sOpenWaypoint = "WP_" + GetTag(OBJECT_SELF) + "_Open";
string sClosedWaypoint = "WP_" + GetTag(OBJECT_SELF) + "_Closed";
string sResRef = GetResRef(OBJECT_SELF);
string sPlaceableTag;
string sSelfTag = GetTag(OBJECT_SELF);
string sFail_Open_Message = GetLocalString(OBJECT_SELF,"Fail_Open_Message");
string sKey_Tag = GetLocalString(OBJECT_SELF,"Key_Tag");
string sDestroy_Key_Message = GetLocalString(OBJECT_SELF,"Destroy_Key_Message");
object oPC = GetLastUsedBy();
object oOpenWaypoint = GetWaypointByTag(sOpenWaypoint);
object oClosedWaypoint = GetWaypointByTag(sClosedWaypoint);
object oKey = GetItemPossessedBy(oPC,sKey_Tag);
object oTarget;
object oSpawn;
location lOpenWaypoint = GetLocation(oOpenWaypoint);
location lClosedWaypoint = GetLocation(oClosedWaypoint);
int iState = GetLocalInt(OBJECT_SELF,"Open");
int iUseable = GetUseableFlag(OBJECT_SELF);
int iAuto_Close = GetLocalInt(OBJECT_SELF,"Auto_Close");
int iLocked = GetLocalInt(OBJECT_SELF,"Locked");
int iRelock = GetLocalInt(OBJECT_SELF,"Relock");
int iDestroy_Key = GetLocalInt(OBJECT_SELF,"Destroy_Key");
int iNeed_Key = GetLocalInt(OBJECT_SELF,"Need_Key");
float fAuto_Close_Time = GetLocalFloat(OBJECT_SELF,"Auto_Close_Time");

    if(iState == 1) // Placeable at Open position
    {
        SetPlotFlag(OBJECT_SELF,FALSE);
        DestroyObject(OBJECT_SELF,0.0);
        oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE,sResRef,lClosedWaypoint,FALSE,sSelfTag);
        SetPlotFlag(oSpawn,TRUE);
        SetUseableFlag(oSpawn,iUseable);
        SetLocalInt(oSpawn,"Open",0);
        SetLocalInt(oSpawn,"Auto_Close",iAuto_Close);
        SetLocalFloat(oSpawn,"Auto_Close_Time",fAuto_Close_Time);
        if(!iRelock) // Not relocking?
        {// Yes
            SetLocalInt(oSpawn,"Locked",0); // set it unlocked
        } //  otherwise leave at default.
    }
    if(iState == 0) // Placeable at Closed position
    {
        if(iLocked)// Is it locked?
        {// Yes
            if(GetItemPossessedBy(oPC,sKey_Tag) == OBJECT_INVALID)// Got Key?
            {// No
                if(GetStringLength(sFail_Open_Message) > 0) // Has fail to open message?
                {// Yes
                    SendMessageToPC(oPC,sFail_Open_Message);// Send it
                    return; // End Script
                }
                else
                {// No
                    SendMessageToPC(oPC,"You can't open this yet."); // use default message
                    return; // End Script
                }
            }
        }
        // Has key or not locked
        if(iDestroy_Key) // Set to destroy key on use
        {// Yes
            DestroyObject(GetItemPossessedBy(oPC,sKey_Tag));
            if(GetStringLength(sDestroy_Key_Message) > 0) // Has destroy key message?
            {
                 SendMessageToPC(oPC,sDestroy_Key_Message); // Send it
            }
        }
        SetPlotFlag(OBJECT_SELF,FALSE);
        DestroyObject(OBJECT_SELF,0.0);
        oSpawn = CreateObject(OBJECT_TYPE_PLACEABLE,sResRef,lOpenWaypoint,FALSE,sSelfTag);
        SetPlotFlag(oSpawn,TRUE);
        SetUseableFlag(oSpawn,iUseable);
        SetLocalInt(oSpawn,"Open",1);
        SetLocalInt(oSpawn,"Auto_Close",iAuto_Close);
        SetLocalFloat(oSpawn,"Auto_Close_Time",fAuto_Close_Time);
        if(iAuto_Close)
        {
            ExecuteScript("db_auto_close",oSpawn);
        }
    }
}
