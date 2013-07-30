#include "nwnx_inc"
#include "area_inc"

void main(){
    object oArea = OBJECT_SELF;
    int nID, nDeletedNPC, nDeletedPlace;
    string sResref,  sNPCsSpawning, sRLGS;

   // Only initialize area once (could be called multiple times from different threads)
   if (GetLocalInt(oArea,"INITIALIZED")) {
     return;
   }
   SetLocalInt(oArea,"INITIALIZED",TRUE); // we are doing it now

    string sScript = GetLocalString(OBJECT_SELF, "InitScript");
    if(sScript != "")
        ExecuteScript(sScript, OBJECT_SELF);

    object oTrash = GetFirstObjectInArea(oArea);
    while(oTrash != OBJECT_INVALID){
        //Set all doors to plot
        if( GetObjectType(oTrash) == OBJECT_TYPE_DOOR ){
            //SendMessageToPC(GetFirstPC(), "Door");
            SetPlotFlag(oTrash, TRUE);
        }
        oTrash = GetNextObjectInArea(oArea);
    }

        WriteTimestampedLogEntry("AREA : Intializing " + GetName(oArea) +" : NPCs " + sNPCsSpawning +" : RLGS Placeables " + sRLGS);
}
