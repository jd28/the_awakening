#include "mod_const_inc"
#include "nwnx_inc"

struct SubString {
    string first, rest;
};

struct IntList {
    int i0, i1, i2, i3, i4, i5, i6;
};

// Return color (sColor) text instead of sText
// - iMode: TRUE - used tokens
string ColorText(string sText, string sColor = C_NONE, int iMethod = TRUE);

// Return sText in color which defined in RGB
string ColorTextRGB(string sText, int iRed, int iGreen, int iBlue);

// Counts all items in inventory
int CountItemsInInventory(object oObject);

// XXX
void FloatToVoid(float fFloat);

// Return ASCII Symbol based on it number (iByte) in ASCII Table
// Note: iByte must be bigger then 35
string GetASCIIChar(int iByte);

//XXX
string GetColorStringByStrRef(int iStrRefToDisplay, string sColor = C_NONE, int iGender = GENDER_MALE);

// XXX
int GetDamagePowerFromNumber(int nPower);

// Author: Acaos
struct SubString GetFirstSubString (string sString, string sSep = " ");

// Gets the highest number from a psuedo array on a PC.
// Author: FunkySwerve HGLL
int GetHighestItemFromArray(object oPC, int nNumberInArray);

// Gets the integer at nDigit in an integer mask
int GetIntegerDigit(int nString, int nDigit);

struct IntList GetIntList(string sString, string sSep = " ");

// TRUE if the timer set to sName is still running.
int GetLocalTimer(string sName, object oCreature = OBJECT_SELF);
// Sets up a timer.
// * sName - the variable name (Adds a pre-fix).
// * fDuration - the time until it is removed.
void SetLocalTimer(string sName, float fDuration, object oCreature = OBJECT_SELF);

// Check whether lLoc is valid
int GetIsLocationValid(location lLoc);

//Checks strings to make sure they don't contain '<', '>', '/', '~', or quotation marks.
int GetIsStringLegal(string sString);

// XXX
void IntToVoid(int nInt);

// Execute a Leto script.
string Leto(string script);

//////////////////////////////////////////////////////////////////////
// Move a Location in a Specified Direction and Distance
// lCurrent = Current Location to move
// fDirection = 0 - 360 from current location 0 = Strieght ahead, 180 = Backwards
// fDistance = Distance in meters
// fOffFacing = Face the object offFacing from its current Facing. 0.0 Default
// fOffZ = Increas or Decreas the Z Axis. 0.0 Default
//////////////////////////////////////////////////////////////////////
location MoveLocation(location lCurrent,float fDirection,float fDistance,float fOffFacing = 0.0,float fOffZ = 0.0f);

// Return a rainbow string
string Rainbow(string sText);

// Return a three digit string usable by other functions
string RandomColor();

// Returns a random uppercase or lower case letter
string RandomLetter(string sAlpha="abcdefghijklmnopqrstuvwxyz");

// Replaces an elment in a string
string ReplaceSubString(string sString, string sReplacement, string sSubString = "%s");

// Roll Arbitrary Dice
int RollDice(int nDice, int nSides = 6);

// Initialize Color tokens for dialogue
void SetColorTokens();

// Sets the integer at nDigit in an integer mask string to nNew
int SetIntegerDigit(int nString, int nDigit, int nNew);

// XXX
void StringToVoid(string sString);

// Tells PC how long until the next reset.
void Time2Reset(object oPC);

// XXX
void ObjectToVoid(object oObject);


////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////


string ColorText(string sText, string sColor = C_NONE, int iMethod = TRUE)
      {
/*
       if (iMethod)
         {
          if (sColor == C_NONE)      return sText;
          if (sColor == C_GRAY)      return "<CUSTOM101>" + sText + "<CUSTOM100>";
          if (sColor == C_WHITE)     return "<CUSTOM102>" + sText + "<CUSTOM100>";
          if (sColor == C_WHITE_T)   return "<CUSTOM103>" + sText + "<CUSTOM100>";
          if (sColor == C_CYAN)      return "<CUSTOM104>" + sText + "<CUSTOM100>";
          if (sColor == C_MAGENTA)   return "<CUSTOM105>" + sText + "<CUSTOM100>";
          if (sColor == C_YELLOW)    return "<CUSTOM106>" + sText + "<CUSTOM100>";
          if (sColor == C_YELLOW_T)  return "<CUSTOM107>" + sText + "<CUSTOM100>";
          if (sColor == C_RED)       return "<CUSTOM108>" + sText + "<CUSTOM100>";
          if (sColor == C_ORANGE)    return "<CUSTOM109>" + sText + "<CUSTOM100>";
          if (sColor == C_GREEN_L)   return "<CUSTOM110>" + sText + "<CUSTOM100>";
          if (sColor == C_GREEN_D)   return "<CUSTOM111>" + sText + "<CUSTOM100>";
          if (sColor == C_BLUE_L)    return "<CUSTOM112>" + sText + "<CUSTOM100>";
          if (sColor == C_BLUE_N)    return "<CUSTOM113>" + sText + "<CUSTOM100>";
          if (sColor == C_BLUE_D)    return "<CUSTOM114>" + sText + "<CUSTOM100>";
          if (sColor == C_VIOLET)    return "<CUSTOM115>" + sText + "<CUSTOM100>";
          if (sColor == C_VIOLET_L)  return "<CUSTOM116>" + sText + "<CUSTOM100>";
          if (sColor == C_VIOLET_SL) return "<CUSTOM117>" + sText + "<CUSTOM100>";
          if (sColor == C_BROWN)     return "<CUSTOM118>" + sText + "<CUSTOM100>";
          if (sColor == C_BLACK)     return "<CUSTOM119>" + sText + "<CUSTOM100>";
          if (sColor == C_SILVER)    return "<CUSTOM120>" + sText + "<CUSTOM100>";
          if (sColor == C_NAVY)      return "<CUSTOM121>" + sText + "<CUSTOM100>";
          if (sColor == C_MAROON)    return "<CUSTOM122>" + sText + "<CUSTOM100>";
          if (sColor == C_OLIVE)     return "<CUSTOM123>" + sText + "<CUSTOM100>";
          if (sColor == C_TEAL)      return "<CUSTOM124>" + sText + "<CUSTOM100>";
          if (sColor == C_PURPLE)    return "<CUSTOM125>" + sText + "<CUSTOM100>";
          if (sColor == C_LIME)      return "<CUSTOM126>" + sText + "<CUSTOM100>";
          if (sColor == C_BLUE)      return "<CUSTOM127>" + sText + "<CUSTOM100>";
          if (sColor == C_AQUA)      return "<CUSTOM128>" + sText + "<CUSTOM100>";
          if (sColor == C_FUCHSIA)   return "<CUSTOM129>" + sText + "<CUSTOM100>";
         }
*/
    return sColor + sText + (sColor == C_NONE ? "" : C_END);
}

string ColorTextRGB(string sText, int iRed, int iGreen, int iBlue){
    return "<c" + GetASCIIChar(iRed) + GetASCIIChar(iGreen) + GetASCIIChar(iBlue) + ">" + sText + C_END;
}

int CountItemsInInventory(object oObject){
    object oInv = GetFirstItemInInventory(oObject);
    int nCount;
    while (oInv != OBJECT_INVALID){
        nCount++;
        oInv = GetNextItemInInventory(oObject);
    }
    return nCount;
}

void FloatToVoid(float fFloat){}

string GetASCIIChar(int iByte){
    return GetSubString(sASCII, iByte, 1);
}

int GetDamagePowerFromNumber(int nPower){
    switch (nPower){
        case 0:  return DAMAGE_POWER_NORMAL;
        case 1:  return DAMAGE_POWER_PLUS_ONE;
        case 2:  return DAMAGE_POWER_PLUS_TWO;
        case 3:  return DAMAGE_POWER_PLUS_THREE;
        case 4:  return DAMAGE_POWER_PLUS_FOUR;
        case 5:  return DAMAGE_POWER_PLUS_FIVE;
        case 6:  return DAMAGE_POWER_PLUS_SIX;
        case 7:  return DAMAGE_POWER_PLUS_SEVEN;
        case 8:  return DAMAGE_POWER_PLUS_EIGHT;
        case 9:  return DAMAGE_POWER_PLUS_NINE;
        case 10: return DAMAGE_POWER_PLUS_TEN;
        case 11: return DAMAGE_POWER_PLUS_ELEVEN;
        case 12: return DAMAGE_POWER_PLUS_TWELVE;
        case 13: return DAMAGE_POWER_PLUS_THIRTEEN;
        case 14: return DAMAGE_POWER_PLUS_FOURTEEN;
        case 15: return DAMAGE_POWER_PLUS_FIFTEEN;
        case 16: return DAMAGE_POWER_PLUS_SIXTEEN;
        case 17: return DAMAGE_POWER_PLUS_SEVENTEEN;
        case 18: return DAMAGE_POWER_PLUS_EIGHTEEN;
        case 19: return DAMAGE_POWER_PLUS_NINTEEN;
        case 20: return DAMAGE_POWER_PLUS_TWENTY;
    }

    if (nPower > 20)return DAMAGE_POWER_PLUS_TWENTY;

    return DAMAGE_POWER_NORMAL;
}

struct SubString GetFirstSubString (string sString, string sSep = " ") {
    struct SubString ret;
    int nSep = FindSubString(sString, sSep);
    if (nSep < 0) {
        ret.first = sString;
        ret.rest  = "";
        return ret;
    }
    ret.first = GetStringLeft(sString, nSep);
    ret.rest  = GetStringRight(sString, GetStringLength(sString) - (nSep + GetStringLength(sSep)));
    return ret;
}

int GetHighestItemFromArray(object oPC, int nNumberInArray)
{
    string sString, sInt, sAdd;
    int nInt, nNum;
    int nHighest = -1;
    int nArrayNum = 0;
    for (nInt = 1; nInt <= nNumberInArray; nInt++)
    {
        sInt = IntToString(nInt);
        sString = GetLocalString(oPC, "PRMember"+sInt);
        if (sString != "")
        {
            nNum = StringToInt(GetStringLeft(sString, 2));
            if (nNum > nHighest)
            {
                nHighest = nNum;
                nArrayNum = nInt;
            }
        }
    }
    return nArrayNum;
}


int GetIntegerDigit(int nString, int nDigit){
    if(nDigit == 0) return nString % 10;

    int nPlace = 1, i;
    for(i = 0; i < nDigit; i++)
        nPlace *= 10;

    return ((nString / nPlace) % 10);
}

// Acaos
struct IntList GetIntList(string sString, string sSep = " "){
    struct IntList il;
    struct SubString ss;
    ss.rest = sString;

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i0 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i1 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i2 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i3 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i4 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i5 = StringToInt(ss.first);

    if(ss.rest == "") return il;
    ss = GetFirstSubString(ss.rest, sSep);
    if(ss.first != "")
        il.i6 = StringToInt(ss.first);

    return il;
}

// Jasperre
/*::///////////////////////////////////////////////
//:: Name: SetLocalTimer, GetLocalTimer
//::///////////////////////////////////////////////
  Gets/Sets a local timer.
//::////////////////////////////////////////////*/
int GetLocalTimer(string sName, object oCreature = OBJECT_SELF)
{
    return GetLocalInt(oCreature, "TIMER_" + sName);
}

void SetLocalTimer(string sName, float fDuration, object oCreature = OBJECT_SELF)
{
    sName = "TIMER_" + sName;
    SetLocalInt(oCreature, sName, TRUE);
    DelayCommand(fDuration, DeleteLocalInt(oCreature, sName));
}

int GetIsLocationValid(location lLoc){
    return GetIsObjectValid(GetAreaFromLocation(lLoc));
}

int GetIsStringLegal(string sString){
    string sIllegalChars = GetLocalString(GetModule(), "ILLEGAL_CHARACTERS");
    int i;

    for(i = 0; i < GetStringLength(sIllegalChars); i++){
        if(FindSubString(sString, GetSubString(sIllegalChars, i, 1)) != -1){
            return FALSE;
        }
    }
    return TRUE;
}

void IntToVoid(int nInt){}

// Logs info... Author: Acaos
string Logger(object oLogger, string sDebugVar, int nLogLevel, string sMessage, string sStr0="",
            string sStr1="", string sStr2="", string sStr3="", string sStr4="",
            string sStr5="", string sStr6="", string sStr7="", string sStr8="",
            string sStr9="", string sStr10="", string sStr11="", string sStr12="",
            string sStr13="", string sStr14="", string sStr15="") {
    int nPos, nCount = 0;
    int bSendMessage = GetLocalInt(oLogger, sDebugVar), bLog = nLogLevel >= LOGLEVEL_MINIMUM;

    if (!bSendMessage && !bLog)
        return "";

    string sLeft = "", sRight = sMessage;
    while ((nPos = FindSubString(sRight, "%s")) >= 0) {
        string sInsert;
        switch (nCount++) {
            case 0:  sInsert = sStr0; break;
            case 1:  sInsert = sStr1; break;
            case 2:  sInsert = sStr2; break;
            case 3:  sInsert = sStr3; break;
            case 4:  sInsert = sStr4; break;
            case 5:  sInsert = sStr5; break;
            case 6:  sInsert = sStr6; break;
            case 7:  sInsert = sStr7; break;
            case 8:  sInsert = sStr8; break;
            case 9:  sInsert = sStr9; break;
            case 10: sInsert = sStr10; break;
            case 11: sInsert = sStr11; break;
            case 12: sInsert = sStr12; break;
            case 13: sInsert = sStr13; break;
            case 14: sInsert = sStr14; break;
            case 15: sInsert = sStr15; break;
            default: sInsert = "*INVALID*"; break;
        }
        sLeft += GetStringLeft(sRight, nPos) + sInsert;
        sRight = GetStringRight(sRight, GetStringLength(sRight) - (nPos + 2));
    }
    sMessage = sLeft + sRight;
    if (bSendMessage)
        SendMessageToPC(oLogger, "<cþþþ>" + sMessage + "</c>");
    if (!bLog)
        return "";
    switch (nLogLevel) {
        case LOGLEVEL_DEBUG:
            sMessage = "DEBUG : " + sMessage;
            break;
        case LOGLEVEL_INFO:
            sMessage = "INFO : " + sMessage;
            break;
        case LOGLEVEL_NOTICE:
            sMessage = "NOTICE : " + sMessage;
            break;
        case LOGLEVEL_ERROR:
            sMessage = "ERROR : " + sMessage;
            break;
        default:
            sMessage = "LOG : " + sMessage;
            break;
    }
    WriteTimestampedLogEntry(sMessage);
    return sMessage;
}

location MoveLocation(location lCurrent,float fDirection,float fDistance,float fOffFacing = 0.0,float fOffZ = 0.0f)
{
    vector vPos = GetPositionFromLocation(lCurrent);
    float fFace = GetFacingFromLocation(lCurrent);
    float fNewX = vPos.x + (fDistance * cos(fFace + fDirection));
    float fNewY = vPos.y + (fDistance * sin(fFace + fDirection));
    float fNewZ = vPos.z + (fOffZ);
    vector vNewPos = Vector(fNewX,fNewY,fNewZ);
    location lNewLoc = Location(GetAreaFromLocation(lCurrent),vNewPos,fFace + fOffFacing);
    return lNewLoc;
}


void ObjectToVoid(object oObject){}

string Rainbow(string sText){
    int iMax = GetStringLength(sText), i = 0;
    string sString = "";

    while (i < iMax){
        sString += "<c" + RandomColor() + ">" + GetSubString(sText, i, 1) + C_END;
        i++;
    }
    return sString;
}


string RandomColor(){
    string sString1 = "", sString2 = "", sString3 = "";

    while (sString1 == "") sString1 = GetSubString(sASCII, Random(251), 1);
    while (sString2 == "") sString2 = GetSubString(sASCII, Random(251), 1);
    while (sString3 == "") sString3 = GetSubString(sASCII, Random(251), 1);

    return sString1 + sString2 + sString3;
}

string RandomLetter(string sAlpha="abcdefghijklmnopqrstuvwxyz"){
    sAlpha = GetSubString(sAlpha, Random(GetStringLength(sAlpha)), 1);

    return (Random(100)+1 > 50) ? GetStringUpperCase(sAlpha) : sAlpha;
}

string ReplaceSubString(string sString, string sReplacement, string sSubString = "%s"){
    string part1, part2, result;
    int nSubLength = GetStringLength(sSubString);
    int nStringLength = GetStringLength(sString);
    int n = FindSubString(sString, sSubString);
    if(n==-1){
        return sString;
    }
    part1 = GetSubString(sString, 0, n);
    part2 = GetSubString(sString, n + nSubLength, (nStringLength-(n + nSubLength)));
    result = part1 + sReplacement + part2;
    return result;
}

int RollDice(int nDice, int nSides = 6){
    int nRoll;
    // Roll our own dice...
    do
        nRoll += Random(nSides) + 1;
    while ( --nDice > 0 );

    return nRoll;
}


void SetColorTokens(){
     SetCustomToken(1500, C_END);
     SetCustomToken(1501, C_GREY);
     SetCustomToken(1502, C_WHITE);
     SetCustomToken(1503, C_WHITE_T);
     SetCustomToken(1504, C_CYAN);
     SetCustomToken(1505, C_MAGENTA);
     SetCustomToken(1506, C_YELLOW);
     //SetCustomToken(107, C_YELLOW_T);
     SetCustomToken(1508, C_RED);
     SetCustomToken(1509, C_ORANGE);
     SetCustomToken(1510, C_GREEN_L);
     //SetCustomToken(111, C_GREEN_D);
     SetCustomToken(1512, C_BLUE_L);
     SetCustomToken(1513, C_BLUE_N);
     SetCustomToken(1514, C_BLUE_D);
     SetCustomToken(1515, C_VIOLET);
     SetCustomToken(1516, C_VIOLET_L);
     SetCustomToken(1517, C_VIOLET_SL);
     SetCustomToken(1518, C_BROWN);
     SetCustomToken(1519, C_BLACK);
     SetCustomToken(1520, C_SILVER);
     //SetCustomToken(121, C_MAROON);
     SetCustomToken(1522, C_NAVY);
     //SetCustomToken(123, C_OLIVE);
     //SetCustomToken(124, C_TEAL);
     SetCustomToken(1525, C_PURPLE);
     SetCustomToken(1526, C_LIME);
     SetCustomToken(1527, C_BLUE);
     SetCustomToken(1528, C_AQUA);
	 // SetCustomToken(129, C_FUCHSIA);
}

/* funkyswerve on bioboards */
int SetIntegerDigit(int nInt, int nDigit, int nValue) {
    if (nValue < 0)
        nValue = 0;
    else if (nValue > 9)
        nValue = 9;

    switch (nDigit) {
        case 0: nDigit = 1; break;
        case 1: nDigit = 10; break;
        case 2: nDigit = 100; break;
        case 3: nDigit = 1000; break;
        case 4: nDigit = 10000; break;
        case 5: nDigit = 100000; break;
        case 6: nDigit = 1000000; break;
        case 7: nDigit = 10000000; break;
        case 8: nDigit = 100000000; break;
        case 9: nDigit = 1000000000; break;
        default:
            return 0;
    }

    nInt -= ((nInt / nDigit) % 10) * nDigit;
    nInt += nValue * nDigit;

    return nInt;
}

void StringToVoid(string sString){}

void Time2Reset(object oPC){
    string sMsg = "The reset will occur in approximately ";
    int nMinutes = SRV_RESET_LENGTH - GetLocalInt(GetModule(), "MOD_RESET_TIMER");
    int nHours = nMinutes / 60;

    int nResetsDelayed = GetLocalInt(GetModule(), "RESETS_DELAYED");
    if(nResetsDelayed >= 2)
        nResetsDelayed = 0;
    else if(nResetsDelayed == 1)
        nResetsDelayed = 1;
    else
        nResetsDelayed = 2;

    if(nHours > 0){
        sMsg += IntToString(nHours);
        sMsg += " hour(s) and ";
    }
    sMsg += IntToString(nMinutes % 60);
    sMsg += " minutes.";

    sMsg += "  The reset may be delayed "+IntToString(nResetsDelayed)+ " more times.";

    SendMessageToPC(oPC, C_AZURE+sMsg+C_END);
}

void Log(string sMsg){
    WriteTimestampedLogEntry("LOG : " + sMsg);
}

int GetIsSpawnCreature(object oTrash);
int GetIsSpawnCreature(object oTrash){
    if(GetIsEncounterCreature(oTrash))
        return TRUE;

    if(GetTag(oTrash) == "Spawned")
        return TRUE;

    if(GetLocalInt(oTrash, "Despawn") > 0)
        return TRUE;

    return FALSE;
}

object GiveItemOnce(object oPC, string sResref);
object GiveItemOnce(object oPC, string sResref){
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        if(GetResRef(oItem) == sResref)
            return OBJECT_INVALID;
        oItem = GetNextItemInInventory(oPC);
    }

    return CreateItemOnObject(sResref, oPC);
}

void UnlockAndOpenDoor(object oDoor);
void UnlockAndOpenDoor(object oDoor){
    AssignCommand(oDoor, SetLocked(oDoor, FALSE));
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
}

void DeleteLocalIntFromNearestObjectsByTag(string sTag, string sVar, object oTarget=OBJECT_SELF);
void DeleteLocalIntFromNearestObjectsByTag(string sTag, string sVar, object oTarget=OBJECT_SELF){
    int nNth;
    object oObj = GetNearestObjectByTag(sVar, oTarget, nNth);
    while(oObj != OBJECT_INVALID){
        DeleteLocalInt(oObj, sVar);
        nNth++;
        oObj = GetNearestObjectByTag(sVar, oTarget, nNth);
    }
}

int IncrementLocalInt(object oTarget, string sVar, int amount = 1);
int IncrementLocalInt(object oTarget, string sVar, int amount = 1){
    int n = GetLocalInt(oTarget, sVar) + amount;
    SetLocalInt(oTarget, sVar, n);

    return n;
}

int DecrementLocalInt(object oTarget, string sVar, int amount = 1);
int DecrementLocalInt(object oTarget, string sVar, int amount = 1){
    int n = GetLocalInt(oTarget, sVar) - amount;
    SetLocalInt(oTarget, sVar, n);

    return n;
}



void SetFloatArray(object oObject, string sVarName, int nComponent, float fValue);
float GetFloatArray(object oObject, string sVarName, int nComponent);

void SetIntArray(object oObject, string sVarName, int nComponent, int nValue);
int GetIntArray(object oObject, string sVarName, int nComponent);

void SetLocationArray(object oObject, string sVarName, int nComponent, location lValue);
location GetLocationArray(object oObject, string sVarName, int nComponent);

void SetObjectArray(object oObject, string sVarName, int nComponent, object oValue);
object GetObjectArray(object oObject, string sVarName, int nComponent);

void SetStringArray(object oObject, string sVarName, int nComponent, string sValue);
string GetStringArray(object oObject, string sVarName, int nComponent);

/////////////////////////////

void SetFloatArray(object oObject, string sVarName, int nComponent, float fValue)
{
    SetLocalFloat(oObject, sVarName+IntToString(nComponent), fValue);
    return;
}

float GetFloatArray(object oObject, string sVarName, int nComponent)
{
    return GetLocalFloat(oObject, sVarName+IntToString(nComponent));
}

void SetIntArray(object oObject, string sVarName, int nComponent, int nValue)
{
    SetLocalInt(oObject, sVarName+IntToString(nComponent), nValue);
    return;
}

int GetIntArray(object oObject, string sVarName, int nComponent)
{
    return GetLocalInt(oObject, sVarName+IntToString(nComponent));
}

void SetLocationArray(object oObject, string sVarName, int nComponent, location lValue)
{
    SetLocalLocation(oObject, sVarName+IntToString(nComponent), lValue);
    return;
}

location GetLocationArray(object oObject, string sVarName, int nComponent)
{
    return GetLocalLocation(oObject, sVarName+IntToString(nComponent));
}

void SetObjectArray(object oObject, string sVarName, int nComponent, object oValue)
{
    SetLocalObject(oObject, sVarName+IntToString(nComponent), oValue);
    return;
}

object GetObjectArray(object oObject, string sVarName, int nComponent)
{
    return GetLocalObject(oObject, sVarName+IntToString(nComponent));
}

void SetStringArray(object oObject, string sVarName, int nComponent, string sValue)
{
    SetLocalString(oObject, sVarName+IntToString(nComponent), sValue);
    return;
}

string GetStringArray(object oObject, string sVarName, int nComponent)
{
    return GetLocalString(oObject, sVarName+IntToString(nComponent));
}

int GetIsValidFeat(int nFeat);
int GetIsValidFeat(int nFeat){

    if(nFeat >= 1080 && nFeat <= 2000)
        return FALSE;

    return TRUE;
}

int max (int n1, int n2){
    return (n1 > n2) ? n1 : n2;
}

int clamp(int n1, int min, int max) {
    if (n1 < min) return min;
    if (n1 > max) return max;

    return n1;
}
