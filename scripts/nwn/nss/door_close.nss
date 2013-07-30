///////////////////////////////////////////////////////////////////////////////
// file: door_close
// event: OnOpen
// original authors: EPOlson (eolson@cisco.com) snippets taken from scripts written by Fudder Elm & LetoII
// description: This script will automatically close and relock a door.  If variables
//      are not set defaults will be used, see below.
// variables:
//      Name            Type        Description
//      ----            ----        -----------
//      "Relock"        float       The amount of time before the door relocks in seconds.  If not set, door will not relock.
//      "Close"         float       The amount of time before the door closes in seconds.
//      "Near"          float       The distance a PC must be from the door for it to auto close.
///////////////////////////////////////////////////////////////////////////////

// Configuration Variables
//  float CLOSE - closes door 'n' seconds after opening (default 15s)
const float DEFAULT_CLOSE = 15.0;
//  float RELOCK - door locks 'n' seconds after opening (default never)
//  float NEAR - won't close the door if a PC is this close (default 5ft)
const float DEFAULT_NEAR = 5.0f;

// Close the door if no pc's are within sight. Continue attempting if a
// pc is near and witin sight.
void CloseDoor(object oDoor);

void main(){
    object oDoor=OBJECT_SELF;

    //Ignore delaying doors.
    if(GetLocalInt(oDoor, "Delay")) return;

    float fCloseDelay = IntToFloat(GetLocalInt(oDoor, "Close"));
    if (fCloseDelay == 0.0) { fCloseDelay = DEFAULT_CLOSE; }

    string sScript = GetLocalString(OBJECT_SELF, "ES_Open");
    if(sScript != "")
        ExecuteScript(sScript, OBJECT_SELF);

    // attempt to close the door
    DelayCommand(fCloseDelay,AssignCommand(oDoor,CloseDoor(oDoor)));
}

void CloseDoor(object oDoor)
{
    //int DEBUG = GetAreaInt(GetArea(oDoor),"DEBUG");

    // do nothing if the door is already closed
    if (!GetIsOpen(oDoor)) return;

    float fPC_Near_Range = IntToFloat(GetLocalInt(oDoor,"Near"));
    if (fPC_Near_Range == 0.0) { fPC_Near_Range = DEFAULT_NEAR; }
    float fCloseDelay = IntToFloat(GetLocalInt(oDoor,"Close"));
    if (fCloseDelay == 0.0) { fCloseDelay = DEFAULT_CLOSE; }

    // PC still near the door??
    object oNearPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oDoor,1);
    if (!GetIsObjectValid(oNearPC)) {
       // No PC around? just slam door
       AssignCommand(oDoor, ActionCloseDoor(oDoor));
       return;
    } else {
      if (GetDistanceBetween(oNearPC,oDoor) < fPC_Near_Range) {
        // PC too close to door, wait
        DelayCommand(fCloseDelay,AssignCommand(oDoor,CloseDoor(oDoor)));
        return;
      }
    }
    AssignCommand(oDoor, ActionCloseDoor(oDoor));
    if (GetLocalInt(OBJECT_SELF, "Relock")) {
        SetLocked(oDoor,TRUE);
    }
}


